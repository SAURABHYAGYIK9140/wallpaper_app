import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/controllers/main_controller/main_controller.dart';
import 'package:wallpaper_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaper_app/ui/screens/wallpaperfullview.dart';
import 'package:wallpaper_app/ui/widgets/Categoryitem.dart';
import 'package:wallpaper_app/ui/widgets/StaggeredListView.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/ui/widgets/WallpaperItem.dart';
import 'package:get/get.dart';
import '../../models/Wallpaper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        actions: [
          PopupMenuButton<String>(
            color: const Color(0xFF1C1C1C),
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              if (value == 'contact') {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'saurabhyagyik123@gmail.com',
                  query: 'subject=Detox Mode Support',
                );
                await launchUrl(emailUri);
              }

              if (value == 'privacy') {
                final Uri url = Uri.parse(
                    'https://www.termsfeed.com/live/be3fbf5d-2002-4ad3-a3cf-28c12ba96c27'); // 🔥 your policy link
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }

              if (value == 'about') {
                showAboutDialog(
                  context: Get.context!,
                  applicationName: 'Wallify',
                  applicationVersion: '1.0.0',
                  applicationLegalese: 'your own wallpaper app.',
                );
              }
              if (value == 'ChangeTheme') {
                Fluttertoast.showToast(
                  msg: "See collection coming soon!",
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'ChangeTheme',
                child: Row(
                  children: [
                    Icon(Icons.wallpaper, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "See your collection",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'contact',
                child: Row(
                  children: [
                    Icon(Icons.email_outlined, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "Contact Us",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'privacy',
                child: Row(
                  children: [
                    Icon(Icons.privacy_tip_outlined, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "Privacy Policy",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "About",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],

        backgroundColor: Colors.black,
        title: Text(          style: GoogleFonts.alike(textStyle:
        TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                "Wallify"),
      ),
        body: Column(
          children: [
            Text(
              '✨ Your Screen Deserves the Best – Discover, Download, and Set Today! ✨',
              style: GoogleFonts.alef(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                controller: textcontroller,
                onChanged: (value) async {
                  _timer?.cancel();
                  _timer = Timer(Duration(seconds: 2), () {
                    mainController.getDataByCat(value, true);
                  });
                },
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Search your wallpaper here ",
                    hintStyle: TextStyle(color: Colors.grey),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
                    prefixIcon: Icon(Icons.search, color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
            CategoryItem(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Obx(
                      () => Stack(
                    children: [
                      MasonryGridView.builder(
                        controller: _scrollController,
                        itemCount: mainController.allwallpapers.length,
                        mainAxisSpacing: 7,
                        crossAxisSpacing: 4,
                        gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
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
                      Obx(
                            () => Visibility(
                          visible: mainController.isLoading.value,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
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
          ],
        )
    );
  }
}
