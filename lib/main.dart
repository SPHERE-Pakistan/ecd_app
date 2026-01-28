

import 'package:babysafe/app/apiEndPoint/global_key.dart';
import 'package:babysafe/app/controllers/babyArticleController.dart';
import 'package:babysafe/app/controllers/pregnancyArticleController.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/controllers/track_my_pregnancy_controller.dart';
import 'package:babysafe/app/services/baby_dos_notification.dart';
import 'package:babysafe/app/services/vaccination_notification_service.dart';
import 'package:babysafe/app/services/breastfeeding_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/neo_safe_theme.dart';
import 'app/translations/app_translations.dart';
import 'app/services/notification_service.dart';
import 'app/services/auth_service.dart';
import 'app/services/article_service.dart';
import 'app/services/connectivity_service.dart';
import 'app/services/image_download_service.dart';
import 'app/services/speech_service.dart';
import 'app/services/goal_service.dart';
import 'app/services/theme_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'app/data/providers/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GlobalGoal().init();
  // Initialize notifications
  await TrackMyBabyDos.instance.initialize();
  await VaccinationNotificationService.instance.initialize();

  await BreastfeedingNotificationService.instance.initialize();
  BreastfeedingNotificationService.instance.markAppReady();

  await NotificationService.instance.initialize();
  NotificationService.instance.markAppReady();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Karachi'));
  Get.put(ApiClient());
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Make status bar icons black (Android) and adjust iOS accordingly
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // Android dark icons
    statusBarBrightness: Brightness.light, // iOS dark icons
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  await GetStorage.init();



  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final android =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

// 1. Notification Permission (Android 13+)
  await android?.requestNotificationsPermission();

// 2. Exact Alarm Permission (Android 12/13/14/15+)
  await android?.requestExactAlarmsPermission();

  await NotificationService.instance.initialize();

  // Mark app ready so pending notification taps can navigate
  NotificationService.instance.markAppReady();

  // Initialize services
  Get.put(AuthService());
  Get.put(ArticleService());
  Get.put(ConnectivityService());
  Get.put(ImageDownloadService());
  Get.put(SpeechService());
  Get.put(ThemeService());
  Get.put(BabyArticleController());
  Get.put(PregnancyArticleController());
  Get.put(TrackMyPregnancyController());

  final box = GetStorage();
  final savedLang = box.read('locale');
  Locale initialLocale;

  print(savedLang);
  if (savedLang == 'ur') {
    initialLocale = const Locale('ur', 'PK');
  } else if (savedLang == 'ar') {
    initialLocale = const Locale('ar', 'SA');
  } else {
    initialLocale = const Locale('en', 'US');
  }

  final appTranslations = AppTranslations();
  final localeKey =
      '${initialLocale.languageCode}_${initialLocale.countryCode}';
  final translations =
      appTranslations.keys[localeKey] ?? appTranslations.keys['en_US'] ?? {};

  // Schedule daily notifications using translation keys based on locale
  await TrackMyBabyDos.instance.scheduleDaily830Notifications(
    tipKeys: const [
      'baby_tip_1',
      'baby_tip_2',
      'baby_tip_3',
    ],
    translations: translations,
    titleKey: 'baby_tips_title',
  );

  // Schedule annual date-specific notifications (October 15 - Cold, March 15 - Heat/Diarrhea)
  await TrackMyBabyDos.instance.scheduleAnnualDateNotifications(
    translations: translations,
  );

  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sardar Trust',
      theme: NeoSafeTheme.lightTheme,
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ur', 'PK'),
        Locale('ar', 'SA'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      /// 🔥 THIS IS THE MAGIC
      routingCallback: (routing) {
        debugPrint(
          '📍 ROUTE CHANGE → '
              'FROM: ${routing?.previous ?? 'NONE'} '
              'TO: ${routing?.current ?? 'NONE'}',
        );
      },

      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      navigatorObservers: [routeObserver],
    );
  }
}
