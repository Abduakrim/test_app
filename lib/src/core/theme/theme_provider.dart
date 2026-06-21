import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/src/core/storage/key_value_storage.dart';

final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final themeStr = await KeyValueStorage.getAppTheme();

    if (themeStr == 'dark') return ThemeMode.dark;
    if (themeStr == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  Future<void> toggleTheme() async {
    final isDark =
        state.value == ThemeMode.dark ||
        (state.value == ThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);

    final newTheme = isDark ? ThemeMode.light : ThemeMode.dark;

    state = AsyncValue.data(newTheme);
    await KeyValueStorage.setAppTheme(
      newTheme == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}
