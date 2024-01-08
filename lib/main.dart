import 'dart:developer';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeopleindividual/firebase_custom_event.dart';
import 'package:partypeopleindividual/individualDashboard/bindings/individual_dashboard_binding.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:partypeopleindividual/splash_screen/view/splash_screen.dart';
import 'package:sizer/sizer.dart';
import 'constants.dart';
import 'individualDashboard/views/individual_dashboard_view.dart';
import 'myhttp_overrides.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FlutterLocalNotificationsPlugin pluginInstance = FlutterLocalNotificationsPlugin();
  await setUpForLocalNotification(pluginInstance);
}

Future<NotificationDetails> setUpForLocalNotification(
     FlutterLocalNotificationsPlugin pluginInstance) async {
  var init = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
       // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      ));

  pluginInstance.initialize(init);

  AndroidNotificationDetails androidSpec = const AndroidNotificationDetails(
    'ch_id',
    'ch_name',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );
  const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      playSound: true);

  await pluginInstance
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidChannel);

  pluginInstance.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    categoryIdentifier: 'plainCategory',
  );
  NotificationDetails platformSpec = NotificationDetails(
    android: androidSpec,
    iOS: iosNotificationDetails,
  );
  return platformSpec;
}

Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
  log('notification ::: $title  $body   $payload');
  // display a dialog with the notification details, tap ok to go to another page
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title!),
      content: Text(body!),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Ok'),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            Get.to(IndividualDashboardView());
          },
        )
      ],
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  analytics = await FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver(analytics: analytics);
  await GetStorage.init();
  logCustomEvent(eventName: splash, parameters: {'name': 'splash'});

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  FlutterLocalNotificationsPlugin pluginInstance = FlutterLocalNotificationsPlugin();
  final platformSpec=await setUpForLocalNotification(pluginInstance);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    log('ddddd ${message.data['title']}');
    await pluginInstance.show(0, message.data['title'], message.data['body'], platformSpec,);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        initialBinding: IndividualDashboardBinding(),
        debugShowCheckedModeBanner: false,
        title: 'Party People',
        builder: (context, child) {
          return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9), child: child ?? Text(''));
        },

        theme: ThemeData.light(useMaterial3: false).copyWith(
          scaffoldBackgroundColor: Colors.red.shade900,
          primaryColor: Colors.red.shade900,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.red.shade900,
            titleTextStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.normal,
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontFamily: 'Poppins',
            ),
            // Add more text styles as needed
          ),
        ),
        home: SplashScreen(),
        //IndividualDashboardView(),
      );
    });
  }
}
