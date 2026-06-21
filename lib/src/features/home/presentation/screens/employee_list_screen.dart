import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/src/core/widgets/app_empty_state_widget.dart';
import 'package:test_app/src/core/widgets/app_error_widget.dart';
import 'package:test_app/src/core/widgets/no_internet_widget.dart';
import 'package:test_app/src/core/widgets/shimmer_list.dart';
import 'package:test_app/src/features/auth/presentation/providers/auth_notifier.dart';
import 'package:test_app/src/features/favorite/presentation/provider/favorites_provider.dart';
import 'package:test_app/src/features/home/presentation/providers/employee_notifier.dart';
import 'package:test_app/src/features/home/presentation/widgets/employee_list_tile.dart';
import 'package:test_app/src/features/home/presentation/widgets/filter_bottom_sheet.dart';
import 'package:test_app/src/features/home/presentation/widgets/localization_tile.dart';
import 'package:test_app/src/features/home/presentation/widgets/theme_switch_tile.dart';

class EmployeeListScreen extends ConsumerStatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  ConsumerState<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends ConsumerState<EmployeeListScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(employeesProvider.notifier).fetchNextPage();
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(employeesProvider.notifier).searchEmployees(value);
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesProvider);
    final notifier = ref.watch(employeesProvider.notifier);
    final favoriteUsers = ref.watch(favoritesProvider);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: SearchBar(
                  elevation: const WidgetStatePropertyAll(0),
                  hintText: 'search_employees'.tr(),
                  onChanged: _onSearchChanged,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: notifier.currentFilter.isEmpty
                      ? colors.surfaceContainerLow
                      : colors.primaryContainer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(12),
                ),
                icon: Icon(
                  Icons.tune_rounded,
                  color: notifier.currentFilter.isEmpty
                      ? colors.onSurfaceVariant
                      : colors.onPrimaryContainer,
                ),
                onPressed: _showFilterBottomSheet,
              ),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      drawer: Drawer(
        backgroundColor: colors.surface,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Text(
                  'menu'.tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading:
                    const Icon(Icons.favorite_rounded, color: Colors.redAccent),
                title: Text(
                  'favorites'.tr(),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  context.pop();
                  context.push('/favourite');
                },
              ),
              const Divider(),
              ThemeSwitchTile(),
              const Divider(),
              LocalizationTile(),
              Spacer(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: Text(
                  'logout'.tr(),
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  ref.read(authNotifierProvider.notifier).logout();
                },
              ),
            ],
          ),
        ),
      ),
      body: employeesAsync.when(
        loading: () => const ShimmerList(),
        error: (err, stack) {
          Future<void> onRetry() =>
              ref.read(employeesProvider.notifier).refresh();

          if (err is DioException) {
            if (err.type == DioExceptionType.connectionError ||
                err.type == DioExceptionType.connectionTimeout) {
              return NoInternetWidget(onRetry: onRetry);
            }
            if (err.response?.statusCode == 401) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(authNotifierProvider.notifier).logout();
              });
              return const ShimmerList();
            }
          }

          if (err.toString().contains('connection error') ||
              err.toString().contains('XMLHttpRequest')) {
            return NoInternetWidget(onRetry: onRetry);
          }

          return AppErrorWidget(message: err.toString(), onRetry: onRetry);
        },
        data: (users) {
          if (users.isEmpty) {
            return AppEmptyStateWidget(title: 'employees_not_found'.tr());
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(employeesProvider.notifier).refresh(),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              itemCount: users.length +
                  (notifier.hasMore &&
                          notifier.searchQuery.isEmpty &&
                          notifier.currentFilter.isEmpty
                      ? 1
                      : 0),
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 16.0),
              itemBuilder: (context, index) {
                if (index < users.length) {
                  final user = users[index];

                  final isFav = favoriteUsers.any((e) => e.id == user.id);

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      context.push('/employee-details', extra: user);
                    },
                    child: EmployeeListTile(
                      user: user,
                      isFavorite: isFav,
                      onFavoritePressed: () {
                        ref
                            .read(favoritesProvider.notifier)
                            .toggleFavorite(user);
                      },
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
