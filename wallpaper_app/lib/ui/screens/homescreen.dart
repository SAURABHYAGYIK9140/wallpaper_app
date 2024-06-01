import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/controllers/main_controller/main_controller.dart';
import 'package:wallpaper_app/main.dart';
import 'package:wallpaper_app/ui/screens/wallpaperfullview.dart';
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
  MainController mainController = Get.put(MainController());
  final ScrollController _scrollController = ScrollController();
  var textcontroller=new TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainController.loadMoreData();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mainController.dispose();
    mainController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Reached the end of the list
        mainController.loadMoreData();
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(style: TextStyle(color: Colors.white), "Wallpaper-App"),
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: TextField(
            controller: textcontroller,
            onChanged:  (value) async{
              // Cancel previous timer if exists
              _timer?.cancel();
              // Start a new timer for 3 seconds
              _timer = Timer(Duration(seconds: 2), () {
                mainController.getDataByCat(value,true);
              });
            },
            textCapitalization: TextCapitalization.words,

            style:TextStyle(color: Colors.white),
            decoration: InputDecoration( hintText: "Search your wallpaper here ",hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(13))
            )
            ,prefixIcon: Icon(Icons.search,color: Colors.white,)),

          ),
        ),
        SizedBox(
          height: 10,
        ),
        CategoryItem(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Obx(
              () => Stack(
                children: [
                  Expanded(
                    child: MasonryGridView.builder(
                      controller: _scrollController,
                      // Assign scroll controller
                      itemCount: mainController.allwallpapers.length,
                      mainAxisSpacing: 7,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.to(WallpaperFullView(
                                mainController.allwallpapers[index]));
                          },
                          child: WallpaperItem(
                            wallpaper: mainController.allwallpapers[index],
                            index: index,
                          ),
                        );
                      },
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: mainController.isLoading.value,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                ],
                
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
