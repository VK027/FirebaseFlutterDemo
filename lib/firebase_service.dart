import 'dart:async';

import 'package:ffd/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Int32List, Int64List, TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum NotificationDetailType {NormalMsg, Vibrate, OnlyMusic, VibrateNMusic}

class FirebaseService {

  static FirebaseMessaging? _firebaseMessaging;
  static FirebaseMessaging get firebaseMessaging => FirebaseService._firebaseMessaging ?? FirebaseMessaging.instance;

  static late NotificationDetails platformChannelSpecifics;

  /// Initialize the FlutterLocalNotificationsPlugin.
  static late FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static late AndroidNotificationChannel androidNotificationChannel;

  bool isNotificationsInitialized = false;

  static StreamController<String?> selectedNotificationStream = StreamController<String?>.broadcast();
  
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseService._firebaseMessaging = FirebaseMessaging.instance;
    // Set the background messaging handler early on, as a named top-level function
    await onBackgroundMsg();
    await initializeLocalNotifications();
    await FirebaseService.onMessage();
    //await FirebaseService.onGetInitialMsg();
  }

  //2. when app not terminated and in background
  @pragma('vm:entry-point')
  static Future<void> onBackgroundMsg() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await initializeLocalNotifications();
    print('Handling a background message ${message.messageId}');
    showBackgroundPushNotification(message);
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
  }

  static void showBackgroundPushNotification(RemoteMessage message) async {
    print('message>> $message');
    print('message>>data>> ${message.data}');

    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;
    print('notification>> $notification');
    print('android>> $android');
    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   final AndroidNotification? android = message.notification?.android;
    // }
    // else{
    //
    // }
    final NotificationDetails notificationDetails = setUpNotificationDetails(NotificationDetailType.NormalMsg);
    await FirebaseService.localNotificationsPlugin.show(0, "title", "body", notificationDetails, payload: message.data.toString());
    //await FirebaseService.localNotificationsPlugin.show(notification.hashCode,, "title", "body", notificationDetails, payload: message.data.toString(),);
  }

  // init for the platform specific notification details
  static NotificationDetails setUpNotificationDetails(NotificationDetailType notifyType) {
    NotificationDetails platformSpecificsDetails;

    final String channelId = "high_importance_channel";
    final String channelName = "High Importance Notifications";

    final AndroidNotificationDetails androidNormal =  AndroidNotificationDetails(channelId, channelName,
      priority: Priority.high,
      importance: Importance.high,
      playSound: true,
      enableLights: true,
    );

    switch(notifyType){
      case NotificationDetailType.NormalMsg:
        platformSpecificsDetails = NotificationDetails(
          android: androidNormal,
        );
        break;
      case NotificationDetailType.Vibrate:
        final Int64List pattern = Int64List(4);
        pattern[0] = 0;
        pattern[1] = 4000;
        pattern[2] = 4000;
        pattern[3] = 4000;
        final AndroidNotificationDetails androidVibration =  AndroidNotificationDetails(channelId, channelName,
            priority: Priority.high,
            importance: Importance.high,
            playSound: true,
            ongoing: true,
            vibrationPattern: pattern,
            enableLights: true,
            color:  Color.fromARGB(255, 255, 0, 0),
            ledColor:  Color.fromARGB(255, 255, 0, 0),
            ledOnMs: 1000,
            ledOffMs: 500
        );
        platformSpecificsDetails = NotificationDetails(
          android: androidVibration,
        );
        break;

      case NotificationDetailType.OnlyMusic:

        final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(channelId, channelName,
          priority: Priority.high,
          importance: Importance.high,
          playSound: true,
          sound: const RawResourceAndroidNotificationSound('ring'),
          enableLights: true,
          ongoing: true,
          audioAttributesUsage: AudioAttributesUsage.alarm,
        );
        const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(sound: 'ring.aiff');
        final LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(sound: AssetsLinuxSound('sound/ring.mp3'));
        platformSpecificsDetails = NotificationDetails(
          android: androidDetails,
          iOS: darwinNotificationDetails,
          macOS: darwinNotificationDetails,
          linux: linuxPlatformChannelSpecifics,
        );
        break;

      case NotificationDetailType.VibrateNMusic:
        final Int64List vibrationPattern = Int64List(4);
        vibrationPattern[0] = 0;
        vibrationPattern[1] = 1000;
        vibrationPattern[2] = 5000;
        vibrationPattern[3] = 2000;
        int insistentFlag = 4;
        final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(channelId, channelName,
            priority: Priority.high,
            importance: Importance.high,
            playSound: true,
            additionalFlags: Int32List.fromList(<int>[insistentFlag]),
            sound: const RawResourceAndroidNotificationSound('ring'),
            enableLights: true,
            ongoing: true,
            audioAttributesUsage: AudioAttributesUsage.alarm,
            //largeIcon: const DrawableResourceAndroidBitmap('sample_large_icon'),
            vibrationPattern: vibrationPattern,
            color: const Color.fromARGB(255, 255, 0, 0),
            ledColor: const Color.fromARGB(255, 255, 0, 0),
            ledOnMs: 1000,
            ledOffMs: 500);

        const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(sound: 'ring.aiff');
        final LinuxNotificationDetails linuxPlatformChannelSpecifics = LinuxNotificationDetails(sound: AssetsLinuxSound('sound/ring.mp3'));
        platformSpecificsDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: darwinNotificationDetails,
          macOS: darwinNotificationDetails,
          linux: linuxPlatformChannelSpecifics,
        );
        break;
      default:
        platformSpecificsDetails = NotificationDetails(
          android: androidNormal,
        );
        break;
    }
    return platformSpecificsDetails;
  }


  Future<String?> getDeviceToken() async => await FirebaseMessaging.instance.getToken();
  
  Future<String?> getWebToken() async => await FirebaseMessaging.instance.getToken(vapidKey: 'BMZi-4E_gZmiHDYXF_xH6Pu2VO_2bpilppADcp9xrpZR8iWrnnOxzqGdE7lfic71zqcYEHaPBoCNLdYNFShFczg');
  
   static Future<void> initializeLocalNotifications() async {
     // check the notification permission authenticated
    final NotificationSettings settings = await FirebaseService.firebaseMessaging.requestPermission(alert: true, announcement: false,
      badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true,
    );
    print('notify_permission: ${settings.authorizationStatus}');

    // initialize local notification
    if (localNotificationsPlugin == null) {
      localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    }

     DarwinInitializationSettings darwinInitializationSettings = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true,
        requestSoundPermission: true);

    final LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
    );

    final InitializationSettings _initSettings = InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: darwinInitializationSettings,
        macOS: darwinInitializationSettings,
        linux: initializationSettingsLinux
    );

    // on did receive notification response = for when app is opened via notification while in foreground on android
    await localNotificationsPlugin.initialize(_initSettings, onDidReceiveBackgroundNotificationResponse : onTapNotification, onDidReceiveNotificationResponse: onTapNotification);

    if (defaultTargetPlatform == TargetPlatform.android) {
      androidNotificationChannel = const AndroidNotificationChannel('high_importance_channel', // channel_id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      final bool granted = await localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled() ?? false;

      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final bool? requestGranted = await androidImplementation?.requestPermission();

      print('requestGranted>> $requestGranted, granted>> $granted');
      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidNotificationChannel);

    }else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {

      await localNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(critical: true, alert: true, badge: true, sound: true);

      await localNotificationsPlugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(critical: true, alert: true, badge: true, sound: true);
    }  

    // need this for ios foreground notification
    await FirebaseService.firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }


  //1. This method only call when App in foreground it mean app must be opened
  //for receiving message when app is in  foreground
  static Future<void> onMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('onMessage.listen>> $message');
      print('onMessage.listen>> ${message.data}');
      // if (FCMProvider._refreshNotifications != null)
      //  await FCMProvider._refreshNotifications!(true);
      // if this is available when Platform.isIOS, you'll receive the notification twice
      if (!kIsWeb) {
        final NotificationDetails notificationDetails = setUpNotificationDetails(NotificationDetailType.NormalMsg);
        await FirebaseService.localNotificationsPlugin.show(0, "title", "body", notificationDetails, payload: message.data.toString());
       //  RemoteNotification? notification = message.notification;
       //  AndroidNotification android = message.notification?.android;
       //  await FirebaseService.localNotificationsPlugin.show(notification.hashCode, notification?.title, notification?.body,
       //      NotificationDetails(android: AndroidNotificationDetails(
       //          'high',
       //          'high priority',
       //          icon: 'some_icon_in_drawable_folder',
       //        ),
       //      ));
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


  // 3. on tap the notification item.
  static Future<void> onTapNotification(NotificationResponse? response) async {
    print('onTapNotification>> ${response?.payload}');
    if (response?.payload == null)
      return;
    if (response?.payload != null) {
      selectedNotificationStream.add(response?.payload);
    }
    // final Json _data = FCMProvider.convertPayload(response!.payload!);
    // if (_data.containsKey(...)){
    //   await Navigator.of(FCMProvider._context!).push(...);
    // }
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: ''${notificationResponse.actionId} with' ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print('notification action tapped with input: ${notificationResponse.input}');
    }
  }

  static Future<void> onGetInitialMsg() async {
    // This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method
    await FirebaseService.firebaseMessaging.getInitialMessage().then((message) {
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