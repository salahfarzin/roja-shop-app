import 'package:flutter/material.dart' as flutter;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'screens/products/list.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await EasyLocalization.ensureInitialized();

  // Read saved locale from shared_preferences
  final prefs = await SharedPreferences.getInstance();
  String? localeCode = prefs.getString('selected_locale');
  Locale startLocale;
  if (localeCode != null) {
    // localeCode format: 'ar_IQ', 'fa_IR', 'en_US'
    final parts = localeCode.split('_');
    if (parts.length == 2) {
      startLocale = Locale(parts[0], parts[1]);
    } else {
      startLocale = const Locale('en', 'US');
    }
  } else {
    startLocale = const Locale('en', 'US');
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'IQ'),
        Locale('fa', 'IR'),
      ],
      path: 'assets/langs',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: startLocale,
      child: MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => ProductProvider())],
        child: const RojaShopApp(),
      ),
    ),
  );
}

class RojaShopApp extends StatelessWidget {
  const RojaShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    const rtlLanguages = ['ar', 'fa'];
    final isRtl = rtlLanguages.contains(context.locale.languageCode);

    final app = flutter.MaterialApp(
      title: 'app title'.tr(),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: flutter.ThemeData(
        fontFamily: 'mahan',
        scaffoldBackgroundColor: const flutter.Color(0xFF181922),
        cardColor: const flutter.Color(0xFF23232B),
        textTheme: flutter.ThemeData.dark().textTheme.apply(
          fontFamily: 'mahan',
          bodyColor: flutter.Colors.white,
          displayColor: flutter.Colors.white,
        ),
      ),
      home: const ProductListScreen(),
      debugShowCheckedModeBanner: false,
    );
    return isRtl
        ? flutter.Directionality(
            textDirection: flutter.TextDirection.rtl,
            child: app,
          )
        : app;
  }
}
