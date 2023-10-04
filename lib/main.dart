import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
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




@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  FlutterLocalNotificationsPlugin pluginInstance =
  FlutterLocalNotificationsPlugin();
  var init = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon')
  );
  pluginInstance.initialize(init);
  AndroidNotificationDetails androidSpec = const AndroidNotificationDetails(
    'ch_id',
    'ch_name',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );
  NotificationDetails platformSpec =

  NotificationDetails(android: androidSpec);

  await pluginInstance.show(
      0, message.data['title'], message.data['body'], platformSpec);
  log('A background msg just showed ${message.data}');
  //return;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  analytics = await FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  await GetStorage.init();
  logCustomEvent(eventName: splash, parameters: {'name':'splash'});

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin pluginInstance =
  FlutterLocalNotificationsPlugin();
  var init = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon')
  );
  pluginInstance.initialize(init);
  NotificationSettings settings = await messaging.requestPermission();
  AndroidNotificationDetails androidSpec = const AndroidNotificationDetails(
    'ch_id',
    'ch_name',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined permission');
  }
  messaging.getToken().then((value) {
    print('Firebase Messaging Token : ${value}');
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print(message.messageType);
    print(message.data);
    NotificationDetails platformSpec =
    NotificationDetails(android: androidSpec);
    await pluginInstance.show(
        0, message.data['title'], message.data['body'], platformSpec);
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
        builder: (context,child){
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
        home:SplashScreen(),
        //IndividualDashboardView(),
      );
    });
  }
}
