import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallpaper/wallpaper.dart'
    as wallpaper_lib; // Use 'wallpaper_lib' as prefix
import 'package:wallpaper_app/ui/screens/homescreen.dart';

import '../../controllers/main_controller/main_controller.dart';
import '../../models/Wallpaper.dart';
import '../../utils/ImageDownloader.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/CustomProgressDialog.dart';
import 'package:http/http.dart' as http;
import 'package:gal/gal.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:blurhash_ffi/blurhash_ffi.dart';




class WallpaperFullView extends StatefulWidget {

  final Wallpaper wallpaper;

  WallpaperFullView(this.wallpaper);

  @override
  State<WallpaperFullView> createState() => _WallpaperFullViewState();
}

class _WallpaperFullViewState extends State<WallpaperFullView> {
  String? _downloadedImagePath;
  late String _blurhash="LEHV6nWB2yk8pyo0adR*.7kCMdnj";

  void _downloadImage(String type) async {
    Get.find<MainController>().onUserAction();

    String imageUrl = widget.wallpaper.src.large;
    String? downloadedImagePath =
        await ImageDownloader.downloadAndSaveImage(imageUrl);

    setState(() {
      _downloadedImagePath = downloadedImagePath;
    });

    if (_downloadedImagePath != null) {
      CustomProgressDialog progressDialog = CustomProgressDialog(
        message: 'Loading...', // Initial message to display
      );
      showCustomProgressDialog(context, "Loading...");
      Stream<String> progressString =
          wallpaper_lib.Wallpaper.imageDownloadProgress(imageUrl);
      progressString.listen((data) {
        print("Progress: $data");
        if (data == 90) {
          int progress = int.tryParse(data) ??
              0; // Parse data to integer, default to 0 if parsing fails
          if (progress > 10) {
            Fluttertoast.showToast(
              msg: "Wallpaper applied successfully",
              backgroundColor: Colors.white,
              textColor: Colors.black,
              gravity: ToastGravity.BOTTOM,
            );
          }
        }
        // progressDialog.updateMessage("Progress: $data");
        updateCustomProgressDialogMessage(context, "Progress: $data");
      }, onDone: () async {
        try {
          String result = "";

          if (type == "home") {
            result = await wallpaper_lib.Wallpaper.homeScreen();
          } else if (type == "lock") {
            result = await wallpaper_lib.Wallpaper.lockScreen();
          } else if (type == "both") {
            result = await wallpaper_lib.Wallpaper.bothScreen();
          }
          print("result"+result);

          hideCustomProgressDialog(context);
          Fluttertoast.showToast(
            msg: "Wallpaper applied successfully",
            backgroundColor: Colors.white,
            textColor: Colors.black,
            gravity: ToastGravity.BOTTOM,
          );
        } catch (e) {
          print('Failed to set wallpaper.');
          hideCustomProgressDialog(context);
        }
      }, onError: (error) {
        print("Some Error: $error");
        hideCustomProgressDialog(context);
      });
    } else {
      print('Failed to download image');
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateBlurHashFromUrl(widget.wallpaper.src.large);

}
  bool isPreviewMode = false;
  double slideOffset = 0.0;

  String getFormattedTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  String getFormattedDate() {
    final now = DateTime.now();
    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}";
  }

  @override
  Widget build(BuildContext context) {


    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Column(
                children: [
                  Flexible(
                    child: Container(
                      height: height,
                      color: Colors.black,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isPreviewMode = !isPreviewMode;
                          });
                        },
                        child: Container(
                          child: Hero(
                            tag: 'wallpaper_${widget.wallpaper.id}',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child:BlurHash(
                                // hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                hash: _blurhash,
                                image: widget.wallpaper.src.large,
  
                                imageFit: BoxFit.cover, // Adjust this according to your needs
                                duration: Duration(milliseconds: 200), // Optional duration for fade-in animation
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 2.0)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: !isPreviewMode,
                child: Container(
                  padding: EdgeInsets.all(10),
                  alignment: AlignmentDirectional.topStart,
                  child: CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        Get.find<MainController>().onUserAction();
                      },
                      child: Icon(
                        size: 25,
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !isPreviewMode,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom + 20, top: 20),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                      ),
                                      onPressed: () async {
                                        _downloadImage("home");
                                      },
                                      child: Text(
                                        "SET AS HOME WALLPAPER",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                      ),
                                      onPressed: () {
                                        _downloadImage("lock");
                                      },
                                      child: Text(
                                        "SET AS LOCK WALLPAPER",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                      ),
                                      onPressed: () async {
                                        _downloadImage("both");
                                      },
                                      child: Text(
                                        "SET ON BOTH",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "CANCEL",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "SET AS WALLPAPER",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !isPreviewMode,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: InkWell(
                            onTap: () async {
                              String imageUrl = widget.wallpaper.src.large;
                              String? downloadedImagePath =
                                  await ImageDownloader.downloadAndSaveImage(
                                      imageUrl);
                              print("downloadedImagePath" +
                                  downloadedImagePath.toString());
                              bool success =
                                  await saveImageToGallery(downloadedImagePath!);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Image saved to gallery!')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to save image.')),
                                );
                              }
                            },
                            child: Icon(
                              size: 25,
                              Icons.download,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isPreviewMode = true;
                              });
                            },
                            child: Icon(
                              size: 25,
                              Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isPreviewMode)
                Positioned.fill(
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.primaryDelta! < 0) {
                        setState(() {
                          slideOffset += details.primaryDelta!;
                        });
                      }
                    },
                    onVerticalDragEnd: (details) {
                      if (slideOffset < -150 || (details.primaryVelocity ?? 0) < -500) {
                        setState(() {
                          isPreviewMode = false;
                          slideOffset = 0.0;
                        });
                      } else {
                        setState(() {
                          slideOffset = 0.0;
                        });
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Transform.translate(
                        offset: Offset(0, slideOffset),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 100,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    getFormattedTime(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 80,
                                      fontWeight: FontWeight.w200,
                                      shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                                    ),
                                  ),
                                  Text(
                                    getFormattedDate(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                      shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 50,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 30, shadows: [Shadow(color: Colors.black45, blurRadius: 10)]),
                                  SizedBox(height: 10),
                                  Text(
                                    "Swipe up to unlock",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // void _setWallpaper(String path) async {
  //   try {
  //     bool result = await WallpaperManager.setWallpaperFromFile(
  //       path,
  //       WallpaperManager.HOME_SCREEN,
  //     );
  //
  //     if (context.mounted) {
  //       Get.to(HomeScreen());
  //     }
  //   } catch (e) {
  //     print('Failed to set wallpaper: $e');
  //   }
  // }

  Future<bool> saveImageToGallery(String imagePath) async {
    try {
      await Gal.putImage('$imagePath');
      return true;
    } catch (e) {
      print('Error saving image: $e');
      return false;
    }
  }

  // Future<String> generateBlurHashFromUrl(String imageUrl) async {
  //   final response = await http.get(Uri.parse(imageUrl));
  //   final bytes = response.bodyBytes;
  //   final blurHash = encodeBlurHash(bytes);
  //   return blurHash;
  // }
  void generateBlurHashFromUrl(String imageUrl) async {
    final imageProvider = NetworkImage(imageUrl);
    // setState(() async {
      _blurhash= await BlurhashFFI.encode(imageProvider);
      print("blurHashss"+_blurhash!);
    // });


  }
}
