import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/src/core/network/dio_client.dart';
import 'package:test_app/src/features/auth/data/auth_local_data_source.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(authenticatedDioProvider);
  final localDataSource = ref.read(authLocalDataSourceProvider);
  return AuthRepository(dio, localDataSource);
});

class AuthRepository {
  final Dio _dio;
  final AuthLocalDataSource _localDataSource;
  AuthRepository(this._dio, this._localDataSource);
  Future<String> login(String username, String password) async {
    final response = await _dio.post(
      '/login',
      data: {'username': username, 'password': password, 'expiresInMins': 1},
    );
    final accessToken = response.data['accessToken'];
    final refreshToken = response.data['refreshToken'];
    await _localDataSource.saveAccessToken(accessToken);
    await _localDataSource.saveRefreshToken(refreshToken);
    return accessToken;
  }
}
