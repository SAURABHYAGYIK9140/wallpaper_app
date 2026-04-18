import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Explicit Notification Permission Check (Especially necessary for Android 13+)
    var status = await Permission.notification.status;
    if (status.isDenied) {
      status = await Permission.notification.request();
    }
    
    if (status.isPermanentlyDenied) {
      if (kDebugMode) {
        print('Notification permissions permanently denied. Users must manually enable them in App Settings.');
      }
      // You can call openAppSettings() here if desired
    }

    // Requesting permission for iOS mostly, Android 13+ also needs this
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted notification permission');
      }
      // Get the token right away
      String? token = await _fcm.getToken();
      if (kDebugMode) {
        print('FCM Token: $token');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted notification permissions');
      }
    }

    // Handles notifications while app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }
      
      if (message.notification != null) {
        if (kDebugMode) {
          print('Message also contained a notification: ${message.notification}');
        }
        
        // Use Fluttertoast to display a beautiful in-app notification headsup
        Fluttertoast.showToast(
          msg: "${message.notification!.title ?? 'New Notification'}\n${message.notification!.body ?? ''}",
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 4,
          backgroundColor: const Color(0xFF000000),
          textColor: const Color(0xFFFFFFFF),
        );
      }
    });

    // Handles notification tap from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      // Example routing: Get.toNamed('/notification_details', arguments: message.data);
    });
  }
}
