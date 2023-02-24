import 'dart:async';

import 'package:ffd/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show Int32List, Int64List, TargetPlatform, defaultTargetPlatform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {

  static FirebaseMessaging? _firebaseMessaging;
  static FirebaseMessaging get firebaseMessaging => FirebaseService._firebaseMessaging ?? FirebaseMessaging.instance;

  static late NotificationDetails platformChannelSpecifics;

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseService._firebaseMessaging = FirebaseMessaging.instance;
    await FirebaseService.initializeLocalNotifications();
    await FirebaseService.onMessage();
    await FirebaseService.onBackgroundMsg();
    //await FirebaseService.onGetInitialMsg();
  }

  Future<String?> getDeviceToken() async => await FirebaseMessaging.instance.getToken();

  Future<String?> getWebToken() async => await FirebaseMessaging.instance.getToken(vapidKey: 'BFyTlzDFZc1kKPPe9RrTqtblJUtqj-3q8pq-7WVDPqUelBi_-OHUhqHUYhyUQJ1-rK5FH4AuK4QTylULnPjaDh4');

  static  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();


  static Future<void> initializeLocalNotifications() async {
    NotificationSettings settings = await FirebaseService.firebaseMessaging.requestPermission(alert: true, announcement: false,
      badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true,
    );
    print('notify_permission: ${settings.authorizationStatus}');

    const  DarwinInitializationSettings darwinInitializationSettings = DarwinInitializationSettings(
        requestAlertPermission: true, requestBadgePermission: true,
        requestSoundPermission: true);

    const InitializationSettings _initSettings = InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: darwinInitializationSettings,
        macOS: darwinInitializationSettings
    );

    // on did receive notification response = for when app is opened via notification while in foreground on android
    await FirebaseService.localNotificationsPlugin.initialize(_initSettings,
        onDidReceiveBackgroundNotificationResponse : onTapNotification,
        onDidReceiveNotificationResponse: onTapNotification);

    // need this for ios foreground notification
    await FirebaseService.firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }

  // init for the platform specific notification details
  static setPlatformSpecifications() {
    Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 4000;
    vibrationPattern[2] = 4000;
    vibrationPattern[3] = 4000;
    int insistentFlag = 4;
    platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        "high_importance_channel", "High Importance Notifications",
        priority: Priority.high,
        importance: Importance.high,
        playSound: true,
        additionalFlags: Int32List.fromList(<int>[insistentFlag]),
        sound: const RawResourceAndroidNotificationSound('ring'),
        enableLights: true,
        ongoing: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
        vibrationPattern: vibrationPattern,
      ),
    );
  }

  //1. This method only call when App in foreground it mean app must be opened
  static Future<void> onMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // if (FCMProvider._refreshNotifications != null)
      //   await FCMProvider._refreshNotifications!(true);
      // if this is available when Platform.isIOS, you'll receive the notification twice

      FirebaseService.setPlatformSpecifications();
      if (defaultTargetPlatform == TargetPlatform.android) {

        // FirebaseService.localNotificationsPlugin.zonedSchedule(0,
        //     title, body, scheduledDate,
        //     notificationDetails,
        //     uiLocalNotificationDateInterpretation: uiLocalNotificationDateInterpretation,
        //     androidAllowWhileIdle: androidAllowWhileIdle)
        await FirebaseService.localNotificationsPlugin.show(0, "title",
          "body", platformChannelSpecifics,
          payload: message.data.toString(),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        // if (message.notification != null) {
        //   print(message.notification!.title);
        //   print(message.notification!.body);
        //   print("message.data22 ${message.data['_id']}");
        // }
      },
    );
  }
  //2. when app not terminated and in background
  static Future<void> onBackgroundMsg() async {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }
  // 2. when app not terminated and in background
  static Future<void> backgroundHandler(RemoteMessage message) async {

    print('backgroundHandler>> ${message}');
    print('backgroundHandler>>data>> ${message.data}');
    FirebaseService.setPlatformSpecifications();
    if (defaultTargetPlatform == TargetPlatform.android) {
      await FirebaseService.localNotificationsPlugin.show(0, "title",
       "body", platformChannelSpecifics,
        payload: message.data.toString(),
      );
    }
  }

  // 3. on tap the notification item.
  static Future<void> onTapNotification(NotificationResponse? response) async {
    print('onTapNotification>> ${response?.payload}');
    if (response?.payload == null)
      return;
    // final Json _data = FCMProvider.convertPayload(response!.payload!);
    // if (_data.containsKey(...)){
    //   await Navigator.of(FCMProvider._context!).push(...);
    // }
  }

  static Future<void> onGetInitialMsg() async {
    // This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method
    FirebaseService.firebaseMessaging.getInitialMessage().then((message) {
      print('getInitialMessage>>$message');
      print('getInitialMessage>>data>> ${message?.data}');
      print("FirebaseMessaging.getInitialMessage");

      // if (message != null) {
      //   Navigator.of(context).pushNamed('/call');
      // }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
    //   // Handle navigation or perform any logic here
    // });
  }


  // for receiving message when app is in background or foreground
  /*static Future<void> onMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (Platform.isAndroid) {
        // if this is available when Platform.isIOS, you'll receive the notification twice
        await FirebaseService._localNotificationsPlugin.show(
          0, message.notification!.title, message.notification!.body, FirebaseService.platformChannelSpecifics,
          payload: message.data.toString(),
        );
      }
    });
  }*/
}