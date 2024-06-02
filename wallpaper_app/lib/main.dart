import 'package:flutter/material.dart';
import 'package:wallpaper_app/ui/screens/homescreen.dart';
import 'package:get/get.dart';
import 'package:wallpaper_app/utils/route_pages/page_name.dart';
import 'package:wallpaper_app/utils/route_pages/route_pages.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallify',
        theme: ThemeData(
      //   textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
      // bodyMedium: GoogleFonts.oswald(textStyle: textTheme.bodyMedium)),
            fontFamily: GoogleFonts.poppins().fontFamily,

    ),
        initialRoute: MyPagesName.homescreen,
        getPages: MyPages.list);
  }
}
