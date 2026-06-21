import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/src/features/home/data/model/employee_model.dart';

class KeyValueStorage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? loginStatusKey = 'login_status';
  static Future<void> setLoginStatus(bool status) async {
    await _prefs?.setBool(loginStatusKey!, status);
  }

  static Future<bool?> getLoginStatus() async {
    return _prefs?.getBool(loginStatusKey!);
  }

  static String appThemeKey = 'app_theme';
  static Future<void> setAppTheme(String theme) async {
    await _prefs?.setString(appThemeKey, theme);
  }

  static Future<String?> getAppTheme() async {
    return _prefs?.getString(appThemeKey);
  }

  static String favouriteEmployeesKey = 'favourite_employees';

  static Future<void> setFavouriteEmployees(
      List<EmployeeModel> employees) async {
    final List<String> jsonList =
        employees.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs?.setStringList(favouriteEmployeesKey, jsonList);
  }

  static List<EmployeeModel> getFavouriteEmployees() {
    final List<String>? jsonList = _prefs?.getStringList(favouriteEmployeesKey);
    if (jsonList == null) return [];

    return jsonList.map((e) => EmployeeModel.fromJson(jsonDecode(e))).toList();
  }
}

final prefsProvider = Provider((ref) => KeyValueStorage());
