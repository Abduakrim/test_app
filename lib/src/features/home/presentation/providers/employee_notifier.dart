import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/src/features/home/data/employee_repository.dart';
import 'package:test_app/src/features/home/data/model/employee_model.dart';
import 'package:test_app/src/features/home/data/model/employees_filter.dart';

final employeesProvider =
    AsyncNotifierProvider<EmployeesNotifier, List<EmployeeModel>>(() {
  return EmployeesNotifier();
});

class EmployeesNotifier extends AsyncNotifier<List<EmployeeModel>> {
  int _skip = 0;
  final int _limit = 15;
  String _searchQuery = '';
  EmployeeFilter _currentFilter = const EmployeeFilter();
  List<EmployeeModel> _allFetchedUsers = [];
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  String get searchQuery => _searchQuery;
  EmployeeFilter get currentFilter => _currentFilter;

  @override
  FutureOr<List<EmployeeModel>> build() async {
    _skip = 0;
    _hasMore = true;
    _searchQuery = '';
    _currentFilter = const EmployeeFilter();
    _allFetchedUsers = [];

    final repository = ref.read(employeesRepositoryProvider);
    final response = await repository.getEmployees(skip: _skip, limit: _limit);

    _hasMore = response.hasMore;
    _skip = response.users.length;
    _allFetchedUsers = List.from(response.users);

    return response.users;
  }

  void searchEmployees(String queryText) {
    _searchQuery = queryText.trim();
    _applyFiltersAndSearch();
  }

  void setFilters(EmployeeFilter filter) {
    _currentFilter = filter;
    _applyFiltersAndSearch();
  }

  void clearFilters() {
    _currentFilter = const EmployeeFilter();
    _applyFiltersAndSearch();
  }

  void _applyFiltersAndSearch() {
    List<EmployeeModel> result = List.from(_allFetchedUsers);

    if (_searchQuery.isNotEmpty) {
      final lowerCaseQuery = _searchQuery.toLowerCase();
      result = result.where((user) {
        return user.firstName.toLowerCase().contains(lowerCaseQuery) ||
            user.lastName.toLowerCase().contains(lowerCaseQuery) ||
            user.email.toLowerCase().contains(lowerCaseQuery) ||
            user.id.toString().contains(lowerCaseQuery);
      }).toList();
    }

    if (_currentFilter.department != null) {
      result = result
          .where((user) => user.department == _currentFilter.department)
          .toList();
    }

    if (_currentFilter.position != null) {
      result = result
          .where((user) => user.title == _currentFilter.position)
          .toList();
    }

    if (_currentFilter.isActive != null) {
      result = result
          .where((user) => user.isActive == _currentFilter.isActive)
          .toList();
    }

    if (_currentFilter.sortType != null) {
      switch (_currentFilter.sortType!) {
        case EmployeeSortType.name:
          result.sort(
            (a, b) =>
                a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()),
          );
          break;
        case EmployeeSortType.id:
          result.sort((a, b) => a.id.compareTo(b.id));
          break;
        case EmployeeSortType.position:
          result.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
          );
          break;
      }
    }

    state = AsyncValue.data(result);
  }

  Future<void> fetchNextPage() async {
    if (_isLoadingMore ||
        !_hasMore ||
        _searchQuery.isNotEmpty ||
        !_currentFilter.isEmpty) {
      return;
    }

    _isLoadingMore = true;

    state = await AsyncValue.guard(() async {
      final repository = ref.read(employeesRepositoryProvider);
      final response = await repository.getEmployees(
        skip: _skip,
        limit: _limit,
      );

      _hasMore = response.hasMore;
      _skip += response.users.length;

      for (var newUser in response.users) {
        if (!_allFetchedUsers.any((existing) => existing.id == newUser.id)) {
          _allFetchedUsers.add(newUser);
        }
      }

      return List.from(_allFetchedUsers);
    });
    _isLoadingMore = false;
  }

  Future<void> refresh() async {
    _skip = 0;
    _hasMore = true;
    _isLoadingMore = false;
    _searchQuery = '';
    _currentFilter = const EmployeeFilter();
    _allFetchedUsers = [];

    ref.invalidateSelf();
    await future;
  }
}
