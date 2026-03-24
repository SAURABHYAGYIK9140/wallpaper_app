import 'package:flutter/material.dart';
import 'package:wallpaper_app/ui/screens/homescreen.dart';
import 'package:get/get.dart';
import 'package:wallpaper_app/utils/route_pages/page_name.dart';
import 'package:wallpaper_app/utils/route_pages/route_pages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = ClarityConfig(
    projectId: "vuons1mxnv",
    logLevel: LogLevel.None,
  );

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
          upgrader: Upgrader(),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
