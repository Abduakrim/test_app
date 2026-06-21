import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/src/core/config/router/app_router.dart';
import 'package:test_app/src/features/auth/data/auth_interceptor.dart';
import 'package:test_app/src/features/auth/data/auth_local_data_source.dart';
import 'package:test_app/src/features/auth/data/auth_repository.dart';

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(
  () => AuthNotifier(),
);

class AuthNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    final interceptor = ref.read(authInterceptorProvider);
    final subscription = interceptor.authErrorStream.listen((_) {
      logout();
    });
    ref.onDispose(() {
      subscription.cancel();
    });
    return null;
  }

  Future<bool> login(String username, String password) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).login(username, password);
    });
    state = result;
    return !result.hasError;
  }

  Future<void> logout() async {
    await ref.read(authLocalDataSourceProvider).clearTokens();
    ref.invalidate(accessTokenProvider);
  }
}
