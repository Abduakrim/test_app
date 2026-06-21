import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/src/features/home/data/model/employees_filter.dart';
import 'package:test_app/src/features/home/presentation/providers/employee_notifier.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  String? _tempDept;
  String? _tempPos;
  bool? _tempActive;
  EmployeeSortType? _tempSort;

  final List<String> _departments = ['Engineering', 'Sales', 'Marketing', 'HR', 'Support'];
  final List<String> _positions = ['Sales Manager', 'Developer', 'Designer', 'Lead'];

  @override
  void initState() {
    super.initState();
    final current = ref.read(employeesProvider.notifier).currentFilter;
    _tempDept = current.department;
    _tempPos = current.position;
    _tempActive = current.isActive;
    _tempSort = current.sortType;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'filters_and_sorting'.tr(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.onSurface),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('sorting'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.onSurfaceVariant)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: Text('by_name'.tr()),
                  selected: _tempSort == EmployeeSortType.name,
                  onSelected: (val) => setState(() => _tempSort = val ? EmployeeSortType.name : null),
                ),
                ChoiceChip(
                  label: Text('by_id'.tr()),
                  selected: _tempSort == EmployeeSortType.id,
                  onSelected: (val) => setState(() => _tempSort = val ? EmployeeSortType.id : null),
                ),
                ChoiceChip(
                  label: Text('by_position'.tr()),
                  selected: _tempSort == EmployeeSortType.position,
                  onSelected: (val) => setState(() => _tempSort = val ? EmployeeSortType.position : null),
                ),
              ],
            ),
            const Divider(height: 32),
            Text('department'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.onSurfaceVariant)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _departments.map((dept) {
                  final isSelected = _tempDept == dept;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(dept.tr()),
                      selected: isSelected,
                      onSelected: (val) => setState(() => _tempDept = val ? dept : null),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text('position'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.onSurfaceVariant)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _positions.map((pos) {
                  final isSelected = _tempPos == pos;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(pos.tr()),
                      selected: isSelected,
                      onSelected: (val) => setState(() => _tempPos = val ? pos : null),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text('status'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.onSurfaceVariant)),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: Text('active'.tr()),
                  selected: _tempActive == true,
                  onSelected: (val) => setState(() => _tempActive = val ? true : null),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('inactive'.tr()),
                  selected: _tempActive == false,
                  onSelected: (val) => setState(() => _tempActive = val ? false : null),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(employeesProvider.notifier).clearFilters();
                      Navigator.pop(context);
                    },
                    child: Text('reset'.tr()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      ref.read(employeesProvider.notifier).setFilters(
                        EmployeeFilter(
                          department: _tempDept,
                          position: _tempPos,
                          isActive: _tempActive,
                          sortType: _tempSort,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Text('apply'.tr()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}