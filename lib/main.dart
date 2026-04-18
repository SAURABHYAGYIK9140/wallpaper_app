import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/ui/screens/homescreen.dart';
import 'package:get/get.dart';
import 'package:wallpaper_app/utils/route_pages/page_name.dart';
import 'package:wallpaper_app/utils/route_pages/route_pages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'constants/AppConstraints.dart';
import 'firebase_options.dart';
import 'services/PushNotificationService.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) {
    if (kReleaseMode) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    }
  }).catchError((e) {
    if (kDebugMode) {
      print('Error initializing Firebase: $e');
    }
  });

  final config = ClarityConfig(
    projectId: "vuons1mxnv",
    logLevel: LogLevel.None,
  );
  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 0),
    ),
  );
  
  await remoteConfig.fetchAndActivate();
  String apiKey = remoteConfig.getString('image_api_key') ?? '';
  
  print('Fetched API Key: $apiKey');
  if (apiKey.isNotEmpty) {
    AppConstraints.API_KEY = apiKey;
  } else {
    print('API Key is empty. Please check Remote Config settings.');
  }
  
  await PushNotificationService().initialize();
  
  runApp(
    ClarityWidget(
      clarityConfig: config,
      app: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return   GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallify',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      initialRoute: MyPagesName.homescreen,
      getPages: MyPages.list,

      builder: (context, child) {
        return UpgradeAlert(
          showPrompt: true,
          dialogStyle: UpgradeDialogStyle.cupertino,
          showIgnore: false,
          showLater: false,
          barrierDismissible: false,
          upgrader: Upgrader(
            durationUntilAlertAgain: Duration(hours: 3),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
