import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' as trans;
import 'package:provider/provider.dart';
import 'package:rojashop/screens/products/add_product.dart';
import 'package:rojashop/screens/products/management.dart';
import 'providers/product_provider.dart';
import 'screens/products/list.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await trans.EasyLocalization.ensureInitialized();

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
    trans.EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'IQ'),
        Locale('fa', 'IR'),
      ],
      path: 'assets/langs',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: startLocale,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider(startLocale)),
        ],
        child: const RojaShopApp(),
      ),
    ),
  );
}

class RojaShopApp extends StatelessWidget {
  const RojaShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isRtl = Provider.of<LocaleProvider>(context).isRtl;
    final fontFamily = isRtl ? 'mahan' : null;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final app = MaterialApp(
      title: 'app title'.tr(),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: fontFamily,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: fontFamily,
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: fontFamily,
        scaffoldBackgroundColor: const Color(0xFF181922),
        cardColor: const Color(0xFF23232B),
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: fontFamily,
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      themeMode: themeProvider.themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const ProductListScreen(),
        '/manage-products': (context) => const ProductManagementScreen(),
        '/add-product': (context) => const AddProductScreen(),
        '/settings': (context) => SettingsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
    return isRtl
        ? Directionality(textDirection: TextDirection.rtl, child: app)
        : app;
  }
}
