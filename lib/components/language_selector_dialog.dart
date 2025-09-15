import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSelectorDialog extends StatelessWidget {
  final Locale currentLocale;
  final void Function(Locale) onSelected;
  const LanguageSelectorDialog({
    super.key,
    required this.currentLocale,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'locale': const Locale('fa', 'IR'), 'label': 'فارسی'},
      {'locale': const Locale('ar', 'IQ'), 'label': 'کوردی'},
      {'locale': const Locale('en', 'US'), 'label': 'English'},
    ];
    return AlertDialog(
      title: Text('choose language'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: languages.map((lang) {
          final isSelected =
              currentLocale.languageCode ==
              (lang['locale'] as Locale).languageCode;
          return ListTile(
            title: Text(lang['label'] as String),
            trailing: isSelected
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () => onSelected(lang['locale'] as Locale),
          );
        }).toList(),
      ),
    );
  }
}
