import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/src/core/theme/theme_provider.dart';

class ThemeSwitchTile extends ConsumerWidget {
  const ThemeSwitchTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    final isDark = themeMode.value == ThemeMode.dark ||
        (themeMode.value == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return SwitchListTile(
      title: Text(
        isDark ? 'dark_theme'.tr() : 'light_theme'.tr(),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      secondary: Icon(
        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
        color: isDark ? Colors.blueAccent : Colors.orangeAccent,
      ),
      value: isDark,
      activeThumbColor: Colors.blueAccent,
      onChanged: (bool value) {
        ref.read(themeProvider.notifier).toggleTheme();
      },
    );
  }
}
