import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rojashop/components/language_selector_dialog.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF181922),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.grid_view, color: Color(0xFF2EC4F1), size: 30),
              const SizedBox(height: 2),
              Text(
                'products'.tr(),
                style: const TextStyle(
                  color: Color(0xFF2EC4F1),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white38),
            onPressed: () async {
              final currentLocale = context.locale;
              final result = await showDialog<Locale>(
                context: context,
                builder: (context) => LanguageSelectorDialog(
                  currentLocale: currentLocale,
                  onSelected: (locale) {
                    Navigator.of(context).pop(locale);
                  },
                ),
              );
              if (result != null && result != currentLocale) {
                context.setLocale(result);
                // Persist to shared_preferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('app_locale', result.languageCode);
              }
            },
          ),
        ],
      ),
    );
  }
}
