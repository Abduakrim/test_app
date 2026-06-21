import 'employee_model.dart';

class EmployeesResponse {
  final List<EmployeeModel> users;
  final int total;
  final int skip;
  final int limit;

  EmployeesResponse({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory EmployeesResponse.fromJson(Map<String, dynamic> json) {
    return EmployeesResponse(
      users:
          (json['users'] as List<dynamic>?)
              ?.map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 15,
    );
  }

  bool get hasMore => skip + users.length < total;
}
