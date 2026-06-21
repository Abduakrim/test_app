enum EmployeeSortType { name, id, position }

class EmployeeFilter {
  final String? department;
  final String? position;
  final bool? isActive;
  final EmployeeSortType? sortType;

  const EmployeeFilter({
    this.department,
    this.position,
    this.isActive,
    this.sortType,
  });

  bool get isEmpty => department == null && position == null && isActive == null && sortType == null;

  EmployeeFilter copyWith({
    String? Function()? department,
    String? Function()? position,
    bool? Function()? isActive,
    EmployeeSortType? Function()? sortType,
  }) {
    return EmployeeFilter(
      department: department != null ? department() : this.department,
      position: position != null ? position() : this.position,
      isActive: isActive != null ? isActive() : this.isActive,
      sortType: sortType != null ? sortType() : this.sortType,
    );
  }
}