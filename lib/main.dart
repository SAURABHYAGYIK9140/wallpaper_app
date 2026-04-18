import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/features/wallpapers/presentation/pages/homescreen.dart';
import 'package:wallpaper_app/features/wallpapers/presentation/bloc/wallpaper_bloc.dart';
import 'package:wallpaper_app/features/wallpapers/presentation/bloc/wallpaper_event.dart';
import 'package:wallpaper_app/injection_container.dart' as di;
import 'package:google_fonts/google_fonts.dart';
import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:wallpaper_app/core/constants/AppConstraints.dart';
import 'package:wallpaper_app/firebase_options.dart';
import 'package:wallpaper_app/core/services/PushNotificationService.dart';

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
  
  if (apiKey.isNotEmpty) {
    AppConstraints.API_KEY = apiKey;
  }
  
  await PushNotificationService().initialize();
  await di.init();
  
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<WallpaperBloc>(
          create: (context) => di.sl<WallpaperBloc>()..add(GetCuratedEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wallify',
        theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        home: Builder(
          builder: (context) {
            return UpgradeAlert(
              showPrompt: true,
              dialogStyle: UpgradeDialogStyle.cupertino,
              showIgnore: false,
              showLater: false,
              barrierDismissible: false,
              upgrader: Upgrader(
                durationUntilAlertAgain: Duration(hours: 3),
              ),
              child: const HomeScreen(),
            );
          }
        ),
      ),
    );
  }
}
