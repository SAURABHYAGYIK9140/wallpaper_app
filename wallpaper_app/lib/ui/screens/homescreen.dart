import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/controllers/main_controller/main_controller.dart';
import 'package:wallpaper_app/ui/widgets/Categoryitem.dart';
import 'package:wallpaper_app/ui/widgets/StaggeredListView.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/ui/widgets/WallpaperItem.dart';
import 'package:get/get.dart';
import '../../models/Wallpaper.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreen> {
  MainController mainController=Get.put(MainController());

  @override
  Widget build(BuildContext context) {


    return  Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: Text(style: TextStyle(color: Colors.white),"Wallpaper-App"),
      ),
      body: Column(

        children:[
          CategoryItem(),
          Expanded(

            child: Padding(
              padding: EdgeInsets.all(10),
              child: Obx(
                () =>
                mainController.isLoading.value == true
                  ? Center(child: CircularProgressIndicator())
                :
                    MasonryGridView.builder(
                  itemCount: mainController.allwallpapers.length,
                  mainAxisSpacing: 7,
                  gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  crossAxisSpacing: 4,
                  itemBuilder: (context, index) {
                    return WallpaperItem(wallpaper:mainController.allwallpapers[index]);
                  },
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}