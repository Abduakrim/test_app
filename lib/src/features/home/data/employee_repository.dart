import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/src/core/network/dio_client.dart';
import 'package:test_app/src/features/home/data/model/employees_response.dart';

final employeesRepositoryProvider = Provider<EmployeesRepository>((ref) {
  final dio = ref.read(dioProvider);
  return EmployeesRepository(dio);
});

class EmployeesRepository {
  final Dio _dio;
  EmployeesRepository(this._dio);
  Future<EmployeesResponse> getEmployees({
    required int skip,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        '/users',
        queryParameters: {'limit': limit, 'skip': skip},
      );
      return EmployeesResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }

  Future<EmployeesResponse> searchEmployees({required String? query}) async {
    try {
      final response = await _dio.get(
        '/users/search',
        queryParameters: {'q': query},
      );
      return EmployeesResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }
}
