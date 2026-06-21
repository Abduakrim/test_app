import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/src/features/auth/presentation/providers/auth_notifier.dart';
import 'package:test_app/src/features/home/presentation/widgets/localization_tile.dart';
import 'package:test_app/src/features/home/presentation/widgets/theme_switch_tile.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colors.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Text(
                'menu'.tr(),
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading:
                  const Icon(Icons.favorite_rounded, color: Colors.redAccent),
              title: Text(
                'favorites'.tr(),
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                context.pop();
                context.push('/favourite');
              },
            ),
            const Divider(),
            const ThemeSwitchTile(),
            const Divider(),
            const LocalizationTile(),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                'logout'.tr(),
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                ref.read(authNotifierProvider.notifier).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}