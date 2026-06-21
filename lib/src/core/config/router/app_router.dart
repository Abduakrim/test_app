import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/src/core/widgets/app_error_widget.dart';
import 'package:test_app/src/features/auth/data/auth_local_data_source.dart';
import 'package:test_app/src/features/auth/presentation/screens/login_screen.dart';
import 'package:test_app/src/features/auth/presentation/screens/splash_screen.dart';
import 'package:test_app/src/features/favorite/presentation/screens/favorites_screen.dart';
import 'package:test_app/src/features/home/data/model/employee_model.dart';
import 'package:test_app/src/features/home/presentation/screens/employee_details_screen.dart';
import 'package:test_app/src/features/home/presentation/screens/employee_list_screen.dart';

final accessTokenProvider = FutureProvider<bool>((ref) async {
  final localSource = ref.read(authLocalDataSourceProvider);

  final results = await Future.wait([
    localSource.getAccessToken(),
    Future.delayed(const Duration(seconds: 2)),
  ]);

  final token = results[0] as String?;
  return token != null;
});
final appRouter = Provider<GoRouter>((ref) {
  final hasTokenAsync = ref.watch(accessTokenProvider);
  return GoRouter(
    redirect: (context, state) {
      if (hasTokenAsync.isLoading) return '/splash';

      final isLoggedIn = hasTokenAsync.value ?? false;
      final isLoggingIn = state.matchedLocation == '/auth';

      if (!isLoggedIn && !isLoggingIn) {
        return '/auth';
      }
      if (isLoggedIn && isLoggingIn) {
        return '/list';
      }

      return null;
    },
    initialLocation: '/list',
    routes: [
      GoRoute(
        path: '/favourite',
        builder: (context, state) {
          return const FavoriteEmployeesScreen();
        },
      ),
      GoRoute(
        path: '/employee-details',
        builder: (context, state) {
          final employee = state.extra as EmployeeModel?;
          if (employee == null) {
            return AppEmptyStateWidget(title: 'employee_not_found'.tr());
          }
          return EmployeeDetailsScreen(employee: employee);
        },
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
          path: '/list', builder: (context, state) => const EmployeeListScreen()),
      GoRoute(path: '/auth', builder: (context, state) => const LoginScreen()),
    ],
  );
});
