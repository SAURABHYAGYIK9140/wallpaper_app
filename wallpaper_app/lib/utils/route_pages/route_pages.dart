import 'package:flutter/material.dart';
import 'package:get/get_connect.dart';
import 'package:get/get.dart';
import 'package:wallpaper_app/binding/main_binding/main_binding.dart';
import 'package:wallpaper_app/ui/screens/homescreen.dart';
import 'package:wallpaper_app/utils/route_pages/page_name.dart';

import '../../binding/splash_binding/SplashBinding.dart';
import '../../ui/screens/SplashPage.dart';

class MyPages
{
  static List<GetPage> get list => [
    // GetPage(
    //     name: MyPagesName.splashFile,
    //     page: () => SplashPage(),
    //     binding: SplashBinding()),
    GetPage(
        name: MyPagesName.homescreen,
        page: () => HomeScreen(),
      binding: MainScreenBinding()
    )

  ];
}