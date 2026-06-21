import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/src/core/widgets/app_error_widget.dart';
import 'package:test_app/src/features/favorite/presentation/provider/favorites_provider.dart';
import 'package:test_app/src/features/home/presentation/widgets/employee_list_tile.dart';

class FavoriteEmployeesScreen extends ConsumerWidget {
  const FavoriteEmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteUsers = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'favorites'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: favoriteUsers.isEmpty
          ? AppEmptyStateWidget(title: 'no_favorite_employees'.tr())
          : ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              itemCount: favoriteUsers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16.0),
              itemBuilder: (context, index) {
                final user = favoriteUsers[index];

                return EmployeeListTile(
                  user: user,
                  isFavorite: true,
                  onFavoritePressed: () {
                    ref.read(favoritesProvider.notifier).toggleFavorite(user);
                  },
                );
              },
            ),
    );
  }
}