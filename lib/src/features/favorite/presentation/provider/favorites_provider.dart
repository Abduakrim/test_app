import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/src/core/storage/key_value_storage.dart';
import 'package:test_app/src/features/home/data/model/employee_model.dart';

class FavoritesNotifier extends Notifier<List<EmployeeModel>> {
  @override
  List<EmployeeModel> build() {
    return KeyValueStorage.getFavouriteEmployees();
  }

  void toggleFavorite(EmployeeModel employee) {
    final currentFavorites = state;
    final isFavorite = currentFavorites.any((e) => e.id == employee.id);

    List<EmployeeModel> newState;
    if (isFavorite) {
      newState = currentFavorites.where((e) => e.id != employee.id).toList();
    } else {
      newState = [...currentFavorites, employee];
    }

    state = newState; 
    KeyValueStorage.setFavouriteEmployees(newState); 
  }

  bool isFavorite(int id) {
    return state.any((e) => e.id == id);
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<EmployeeModel>>(() {
  return FavoritesNotifier();
});