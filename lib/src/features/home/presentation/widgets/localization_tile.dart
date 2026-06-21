import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalizationTile extends ConsumerWidget {
  const LocalizationTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Locale currentLocale = Localizations.localeOf(context);
    void changeOption(Locale? locale) async {
      await context.setLocale(locale ?? Locale('ru'));
    }

    return RadioGroup(
        groupValue: currentLocale,
        onChanged: changeOption,
        child: Column(
          children: [
            RadioListTile(value: Locale('ru'), title: Text('russian'.tr())),
            RadioListTile(
              value: Locale('en'),
              title: Text('english'.tr()),
            )
          ],
        ));
  }
}
