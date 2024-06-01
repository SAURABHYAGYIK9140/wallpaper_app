import 'package:flutter/material.dart';
import 'package:wallpaper_app/ui/screens/homescreen.dart';
import 'package:get/get.dart';
import 'package:wallpaper_app/utils/route_pages/page_name.dart';
import 'package:wallpaper_app/utils/route_pages/route_pages.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallpaper App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black54),
        useMaterial3: true,
      ),
        initialRoute: MyPagesName.homescreen,
        getPages: MyPages.list);
  }
}
