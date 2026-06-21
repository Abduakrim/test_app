import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/src/core/network/dio_client.dart';
import 'package:test_app/src/features/auth/data/auth_local_data_source.dart';

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(ref);
});

class AuthInterceptor extends Interceptor {
  final Ref _ref;
  final _authErrorController = StreamController<void>.broadcast();
  Stream<void> get authErrorStream => _authErrorController.stream;
  AuthInterceptor(this._ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final localDatasource = _ref.read(authLocalDataSourceProvider);
    final token = await localDatasource.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final localDatasource = _ref.read(authLocalDataSourceProvider);
      final refreshToken = await localDatasource.getRefreshToken();
      if (refreshToken != null) {
        try {
          final dio = _ref.read(dioProvider);
          final response = await dio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
          );
          final newAccessToken = response.data['accessToken'];
          final newRefreshToken = response.data['refreshToken'];
          await localDatasource.saveAccessToken(newAccessToken);
          await localDatasource.saveRefreshToken(newRefreshToken);
          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          final clonedReponse = await dio.fetch(requestOptions);
          return handler.resolve(clonedReponse);
        } catch (e) {
          await localDatasource.clearTokens();
          _authErrorController.add(null);
        }
      }
    }

    return handler.next(err);
  }
}
