import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';
import 'package:android_intent_plus/android_intent.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  const SettingsScreen({super.key, this.onThemeToggle});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? isDark;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    isDark ??= themeProvider.isDarkMode;
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final iconColor = theme.iconTheme.color ?? Colors.black;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('settings'.tr(), style: TextStyle(color: textColor)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: iconColor),
              title: Text(
                'manage products'.tr(),
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/manage-products');
              },
            ),
            ListTile(
              leading: Icon(Icons.language, color: iconColor),
              title: Text(
                'change language'.tr(),
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              ),
              onTap: () async {
                final currentLocale = context.locale;
                final result = await showDialog<Locale>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    backgroundColor: theme.dialogBackgroundColor,
                    title: Text(
                      'change language'.tr(),
                      style: TextStyle(color: textColor),
                    ),
                    children: [
                      SimpleDialogOption(
                        child: Text(
                          'English',
                          style: TextStyle(color: textColor),
                        ),
                        onPressed: () =>
                            Navigator.pop(context, const Locale('en', 'US')),
                      ),
                      SimpleDialogOption(
                        child: Text(
                          'فارسی',
                          style: TextStyle(color: textColor),
                        ),
                        onPressed: () =>
                            Navigator.pop(context, const Locale('fa', 'IR')),
                      ),
                      SimpleDialogOption(
                        child: Text(
                          'کوردی',
                          style: TextStyle(color: textColor),
                        ),
                        onPressed: () =>
                            Navigator.pop(context, const Locale('ar', 'IQ')),
                      ),
                    ],
                  ),
                );
                if (result != null && result != currentLocale) {
                  context.setLocale(result);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(
                    'selected_locale',
                    '${result.languageCode}_${result.countryCode}',
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6, color: iconColor),
              title: Text(
                'toggle theme'.tr(),
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              ),
              trailing: Switch(
                value: isDark!,
                activeThumbColor: theme.colorScheme.secondary,
                activeThumbImage: null,
                onChanged: (val) async {
                  setState(() {
                    isDark = val;
                  });
                  await themeProvider.toggleTheme(val);
                },
              ),
              onTap: null,
            ),
            ListTile(
              title: const Text('Notification Access Settings'),
              trailing: ElevatedButton.icon(
                icon: const Icon(Icons.settings),
                label: const Text('Open'),
                onPressed: _openNotificationAccessSettings,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openNotificationAccessSettings() {
    // Android only
    // Requires android_intent_plus in pubspec.yaml
    // You may want to check Platform.isAndroid before calling
    // import 'package:android_intent_plus/android_intent.dart';
    final intent = AndroidIntent(
      action: 'android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS',
    );
    intent.launch();
  }
}
