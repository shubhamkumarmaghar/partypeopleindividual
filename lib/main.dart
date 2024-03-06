import 'dart:developer';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:partypeopleindividual/firebase_custom_event.dart';
import 'package:partypeopleindividual/individualDashboard/bindings/individual_dashboard_binding.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:partypeopleindividual/setting_controller.dart';
import 'package:sizer/sizer.dart';
import 'constants.dart';
import 'myhttp_overrides.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FlutterLocalNotificationsPlugin pluginInstance =
      FlutterLocalNotificationsPlugin();
  var init = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'));
  pluginInstance.initialize(init);
  AndroidNotificationDetails androidSpec = const AndroidNotificationDetails(
    'ch_id',
    'ch_name',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );
  NotificationDetails platformSpec = NotificationDetails(android: androidSpec);

  await pluginInstance.show(
      0, message.data['title'], message.data['body'], platformSpec);
  log('A background msg just showed ${message.data}');
  //return;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  final PendingDynamicLinkData? initialLink =
  await FirebaseDynamicLinks.instance.getInitialLink();
//await FirebaseDynamicLinkUtils.handleDynamicLink('${initialLink?.link}');
  //Fluttertoast.showToast(msg:'deeplink from initialLink :: ${initialLink?.link}' );

  log('deeplink from initialLink :: ${initialLink?.link}');
  /*if(initialLink?.link != null){
  FirebaseDynamicLinkPostType.link ='${initialLink?.link}';
  Fluttertoast.showToast(msg:'deeplink from firebase:: ${initialLink?.link}' );
  }*/
  //FirebaseDynamicLinkUtils.handleDynamicLink(initialLink?.link.toString() ??'');
// Get.put(SplashController()).initDynamicLinks();

  analytics = await FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  await GetStorage.init();
  logCustomEvent(eventName: splash, parameters: {'name': 'splash'});

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin pluginInstance =
      FlutterLocalNotificationsPlugin();
  var init = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'));
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
  //Assign publishable key to flutter_stripe

  // for test mode
 // Stripe.publishableKey = "pk_test_51M4TemSDWijp4rP3J0fs5nPBtDxnWq5CE6uPOriDJmEraO9DoRXludYdyqZFFiTth3pIGO5GQdW4819FCtaZ3T0300xgGghZOz";


  // for production
  Stripe.publishableKey = "pk_live_51M4TemSDWijp4rP3mtTpPwsdZTwZdfDlqd4qFUtyOQRbHKNdPfy1UdNksgTjkpBazL1dOkIM5d4m09CaHPrmoXSY00i87UkW20";



  //Load our .env file that contains our Stripe Secret key

  // for test mode we have to paste this key in .env file
  //sk_test_51M4TemSDWijp4rP3FGIbVrzLJ0O3jjwDbyPUbVuEyttYqSGDVLwAVPzzUYn0NmnX0AN4VdWjiAWgulTnYlK9uACQ00CB0ugEeU

  // for live secret key
  //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

  await dotenv.load(fileName: "assets/.env");
  runApp(MyApp(initialLink: initialLink,));
}

class MyApp extends StatefulWidget {
  MyApp({super.key,this.initialLink});

  PendingDynamicLinkData? initialLink;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SettingController settingController = Get.put(SettingController());

  @override
  void initState() {
    log('linkkk in klill : ${widget.initialLink?.link}');
    settingController.link ='${widget.initialLink?.link}';
   // FirebaseDynamicLinkPostType.link ='${widget.initialLink?.link}';
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        initialBinding: IndividualDashboardBinding(),
        debugShowCheckedModeBanner: false,
        title: 'Party People',
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
              child: child ?? Text(''));
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
          ),
        ),
       // home: SplashScreen(),
        home: settingController.getPage(),
        //IndividualDashboardView(),
      );
    });
  }
}
