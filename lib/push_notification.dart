
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:partypeopleindividual/individualDashboard/views/individual_dashboard_view.dart';

String? sessionId;
int? callType;
int? callerId;
String? callerName;
Set? opponentsIds;
Map? userInfo;

final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

class PushNotificationsManager {

  AndroidNotificationDetails? androidPlatformChannelSpecifics;

  PushNotificationsManager._();

  //DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  factory PushNotificationsManager() => _instance;
  static final PushNotificationsManager _instance = PushNotificationsManager._();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;
  RemoteMessage? remoteMessage;
  var androidInfo;
  String? selectedNotificationPayload;

  /// A notification action which triggers a url launch event
  static const String urlLaunchActionId = 'id_1';

  /// A notification action which triggers a App navigation event
  static const String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  static const String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  static const String darwinNotificationCategoryPlain = 'plainCategory';

  Future<void> init() async {
    if (!_initialized) {
      _firebaseMessaging.requestPermission();
      _firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      _firebaseMessaging.getToken().then((value) => debugPrint("Firebase Messaging token $value"));
      _initialized = true;

      getIntialMessage();
      onMesage();
      onAppOpened();
    }
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print('notification action tapped with input: ${notificationResponse.input}');
    }
  }


  final List<DarwinNotificationCategory> darwinNotificationCategories =
  <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];


  getIntialMessage() {
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        debugPrint('push not initial message $message');
        notificationRedirection(message);
      }
    });
  }
  @pragma('vm:entry-point')
  onMesage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("======================== FirebaseMessaging  ========================  ${message.data}");
      var androids = AndroidInitializationSettings('drawable/ic_transparent');
      var ios = new DarwinInitializationSettings();
      var platform = new InitializationSettings(android: androids, iOS: ios);

      var androidDetails = AndroidNotificationDetails("1", "Default Notification",
          importance: Importance.max, priority: fln.Priority.max, ticker: 'ticker', playSound: true);
      var iosDetails = DarwinNotificationDetails();
      var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

      flutterLocalNotificationsPlugin.initialize(platform,
          onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
            switch (notificationResponse.notificationResponseType) {
              case NotificationResponseType.selectedNotification:
                selectNotificationStream.add(notificationResponse.payload);
                break;
              case NotificationResponseType.selectedNotificationAction:
                if (notificationResponse.actionId == navigationActionId) {
                  selectNotificationStream.add(notificationResponse.payload);
                }
                break;
            }},
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      if (message.notification != null &&
          message.notification!.title != null &&
          message.notification!.body != null &&
          (message.data['action'] != 'start-call-new' && message.data['action'] != 'end-call-new')) {
        flutterLocalNotificationsPlugin.show(
            1, message.notification!.title, message.notification!.body, generalNotificationDetails);
      }
    });
  }



  onAppOpened() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //// resume app
      debugPrint("message1  open app ${message.data['action']}");
      notificationRedirection(message);
    });
  }

  notificationRedirection(RemoteMessage message) {
  //  final controller = Get.put(MainController());
   // controller.updateComingFromNotification(true);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      debugPrint("action perform ${message.data['action']}");
      switch (message.data['action']) {
       /* case "send-message":
          Get.to(() => SingleChatScreen(
                userId: json.decode(message.data['detail'])['created_by_id'],
                userName: message.data['created_by_name'],
                profileImg: message.data['created_by_image'],
                gender: 0,
                comingFromNotification: true,
              ));
          break;
        case "send-message-group":
          ChatRoomDataModel chatRoomDataModel = ChatRoomDataModel.fromJson(json.decode(message.data['group_detail']));
          Get.to(() => ChatRoom(
                comingFromNotification: true,
                groupUserDetail: chatRoomDataModel,
              ));
          break;
        case "join-group":
          ChatRoomDataModel chatRoomDataModel = ChatRoomDataModel.fromJson(json.decode(message.data['group_detail']));
          Get.to(() => ChatRoom(
                comingFromNotification: true,
                groupUserDetail: chatRoomDataModel,
              ));
          break;
        case "place-order":
          if (json.decode(message.data['detail'])['model_type'].toString() ==
              ("app\\modules\\shop\\models\\OrderSeller")) {
            Get.to(() => ViewOrders(comingFromNotification: true),
                arguments: json.decode(message.data['detail'])['model_id']);
          } else {
            Get.to(() => MyOrderScreen(
                  comingFrom: true,
                ));
          }
          break;
        case "like-dislike":
          Get.to(() => MatchRequests(
                comingFromNotification: true,
              ));
          break;
        case "accept-match-request":
          Get.to(() => Matches(
                comingFromNotification: true,
              ));
          break;
        case "change-status":
          Get.to(() => ViewOrders(comingFromNotification: true),
              arguments: json.decode(message.data['detail'])['model_id']);
          break;
        case "check-duration":
          Get.to(() => SubscriptionScreen());
          break;
        case "pay":
          Get.to(() => PaymentHistory());
          break;
        // case "start-call-new":
        //   if (Platform.isIOS || androidInfo.version.sdkInt >= 31) {
        //     iosCallDialog(message);
        //   } else {
        //     callNotification(message);
        //   }
        //   break;
        // case "end-call":
        //   if (engine != null) {
        //     engine!.leaveChannel();
        //     engine!.release();
        //     if (androidInfo.version.sdkInt < 31) {
        //       await ConnectycubeFlutterCallKit.reportCallEnded(sessionId: message.data['call_session_id']);
        //     }
        //     staticBottomIndex = 0;
        //     Get.offAll(() => BottomNavigationScreen());
        //   }
        //   break;
        case "send-follow-request":
          Get.delete<ProfileViewController>();
          Get.to(() => UserProfileView(id: json.decode(message.data['detail'])['created_by_id'],), arguments: json.decode(message.data['detail'])['created_by_id']);
          break;
        case "event-start":
          var arg = Meeting(
              json.decode(message.data['detail'])['title'],
              json.decode(message.data['detail'])['description'],
              DateTime.parse(getLocalDate(json.decode(message.data['detail'])['start_date'])),
              DateTime.parse(getLocalDate(DateTime.parse(json.decode(message.data['detail'])['end_date']))),
              appColor,
              false);
          Get.to(() => CalendarScreen(), arguments: arg);
          break;
        case "add-member":
          staticBottomIndex = 1;
          HomeTabController controller = Get.find();
          controller.updateIndex(1);
          Get.offAll(() => BottomNavigationScreen(
                comingFromNotification: true,
              ));
          break;
        case "like":
          int id = json.decode(message.data['detail'])['model_id'];
          int type = json.decode(message.data['detail'])['type_id'];
          if (type == TYPE_VIDEO) {
            Get.to(() => PostVideoPlayerViewPage(postId: id), arguments: id);
          } else {
            Get.to(() => ImagePostDetailScreen(postId: id), arguments: id);
          }
          break;
        case "comment":
          int id = json.decode(message.data['detail'])['model_id'];
          int type = json.decode(message.data['detail'])['type_id'];
          Get.to(() => PostCommentsScreen(screenNavigation: ScreenNavigation.fromNotification), arguments: id);
          break;*/
        default:

          Get.to(() => IndividualDashboardView());
          break;
      } // kill contact us
    });
  }

  @pragma('vm:entry-point')
  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    print('firebaseMessagingBackgroundHandler');
    await Firebase.initializeApp();
  }

  void dispose() {
    flutterLocalNotificationsPlugin.cancelAll();
  }
}
