import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' as trans;
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rojashop/models/product.dart';
import 'package:rojashop/screens/products/add_product.dart';
import 'package:rojashop/screens/products/details.dart';
import 'providers/product_provider.dart';
import 'screens/products/list.dart';
import 'screens/splash_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/settings_screen.dart';

void _onReceiveTaskData(Object data) {
  if (data is Map<String, dynamic>) {
    final dynamic timestampMillis = data["timestampMillis"];
    if (timestampMillis != null) {
      final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
        timestampMillis,
        isUtc: true,
      );
      print('timestamp: ${timestamp.toString()}');
    }
  }
}

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

class RojaShopApp extends StatefulWidget {
  const RojaShopApp({super.key});

  @override
  State<RojaShopApp> createState() => _RojaShopAppState();
}

class _RojaShopAppState extends State<RojaShopApp> {
  @override
  void initState() {
    super.initState();

    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestNotificationPermissions(context);
      _requestForgroundPermissions(context);
      _initForegroundService();
      _startForgroundService();
    });
  }

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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const ProductListScreen(),
        '/add-product': (context) => const AddProductScreen(),
        '/product-details': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is Product) {
            return ProductDetailScreen(product: args);
          }
          // If no product, pop and show nothing
          return Builder(
            builder: (context) {
              Future.microtask(() => Navigator.of(context).pop());
              return const SizedBox.shrink();
            },
          );
        },
        '/edit-product': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          // args can be product or product id, adapt as needed
          if (args is Product) {
            return AddProductScreen(product: args);
          }
          // If only id is passed, you may need to fetch product from provider
          if (args is String) {
            final provider = Provider.of<ProductProvider>(
              context,
              listen: false,
            );
            final product = provider.products
                .where((p) => p.id == args)
                .toList();
            if (product.isNotEmpty) {
              return AddProductScreen(product: product.first);
            }
          }
          // fallback: show empty add screen
          return const AddProductScreen();
        },
        '/settings': (context) => SettingsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
    return isRtl
        ? Directionality(textDirection: TextDirection.rtl, child: app)
        : app;
  }

  Future<void> _requestNotificationPermissions(BuildContext context) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    try {
      final status = await Permission.notification.request();
      if (!status.isGranted) {
        // Show message or guide user to settings
      }
    } catch (e) {
      if (e is PlatformException &&
          e.code == 'PermissionRequestCancelledException') {
        // Show a friendly message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permission request was cancelled.')),
        );
      }
    }
  }

  Future<void> _requestForgroundPermissions(BuildContext context) async {
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      try {
        await FlutterForegroundTask.requestNotificationPermission();
      } catch (e) {
        if (e is PlatformException &&
            e.code == 'PermissionRequestCancelledException') {
          print('Permission request was cancelled.');
        }
      }
    }

    if (Platform.isAndroid) {
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }
    }
  }

  void _initForegroundService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<ServiceRequestResult> _startForgroundService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        serviceTypes: [
          ForegroundServiceTypes.dataSync,
          ForegroundServiceTypes.remoteMessaging,
        ],
        serviceId: 256,
        notificationTitle: 'RojaS',
        notificationText: 'Notification service',
        notificationIcon: null,
        notificationButtons: [
          const NotificationButton(id: 'btn_open', text: 'Open'),
        ],
        notificationInitialRoute: '/',
        callback: () {
          // FlutterForegroundTask.setTaskHandler(MyTaskHandler());
        },
      );
    }
  }

  Future<ServiceRequestResult> _stopForegroundService() {
    return FlutterForegroundTask.stopService();
  }
}
