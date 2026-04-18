import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_app/features/wallpapers/data/data_sources/ImageDownloader.dart';
import 'package:wallpaper_app/features/wallpapers/presentation/widgets/CustomProgressDialog.dart';
import 'package:gal/gal.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:blurhash_ffi/blurhash_ffi.dart';

import '../../domain/entities/wallpaper_entity.dart';
import '../../../../core/ads/AdsService.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
class WallpaperFullView extends StatefulWidget {
  final WallpaperEntity wallpaper;

  const WallpaperFullView({required this.wallpaper, super.key});

  @override
  State<WallpaperFullView> createState() => _WallpaperFullViewState();
}

class _WallpaperFullViewState extends State<WallpaperFullView> {
  String? _downloadedImagePath;
  String _blurhash = "LEHV6nWB2yk8pyo0adR*.7kCMdnj";
  bool isPreviewMode = false;
  double slideOffset = 0.0;

  @override
  void initState() {
    super.initState();
    generateBlurHashFromUrl(widget.wallpaper.src['large'] ?? '');
  }

  void _downloadImage(String type) async {
    AdsService().showInterstitial(); 

    String imageUrl = widget.wallpaper.src['large'] ?? '';
    
    showCustomProgressDialog(context, "Downloading...");
    
    try {
      var file = await DefaultCacheManager().getSingleFile(imageUrl);
      
      if (mounted) updateCustomProgressDialogMessage(context, "Applying...");

      int location;
      if (type == "home") {
        location = WallpaperManagerFlutter.homeScreen;
      } else if (type == "lock") {
        location = WallpaperManagerFlutter.lockScreen;
      } else {
        location = WallpaperManagerFlutter.bothScreens;
      }
      final wallpaperManager = WallpaperManagerFlutter();
      File imageFile = File(file.path);

      final bool result = await wallpaperManager.setWallpaper(imageFile, location);

      if (mounted) hideCustomProgressDialog(context);
      
      if (result) {
        Fluttertoast.showToast(
          msg: "Wallpaper applied successfully",
          backgroundColor: Colors.white,
          textColor: Colors.black,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(msg: "Failed to apply wallpaper");
      }
    } catch (e) {
      if (mounted) hideCustomProgressDialog(context);
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

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

  void generateBlurHashFromUrl(String imageUrl) async {
    final imageProvider = NetworkImage(imageUrl);
    final hash = await BlurhashFFI.encode(imageProvider);
    if (mounted) {
      setState(() {
        _blurhash = hash;
      });
    }
  }

  Future<bool> saveImageToGallery(String imagePath) async {
    try {
      await Gal.putImage(imagePath);
      return true;
    } catch (e) {
      return false;
    }
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
                          decoration: const BoxDecoration(
                            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 2.0)],
                          ),
                          child: Hero(
                            tag: 'wallpaper_${widget.wallpaper.id}',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: BlurHash(
                                hash: _blurhash,
                                image: widget.wallpaper.src['large'] ?? '',
                                imageFit: BoxFit.cover,
                                duration: const Duration(milliseconds: 200),
                              ),
                            ),
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
                  padding: const EdgeInsets.all(10),
                  alignment: AlignmentDirectional.topStart,
                  child: CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        AdsService().showInterstitial();
                      },
                      child: const Icon(size: 25, Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !isPreviewMode,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 20, top: 20),
                              decoration: const BoxDecoration(
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
                                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.black)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _downloadImage("home");
                                      },
                                      child: const Text("SET AS HOME WALLPAPER", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                                    ),
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.black)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _downloadImage("lock");
                                      },
                                      child: const Text("SET AS LOCK WALLPAPER", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                                    ),
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.black)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _downloadImage("both");
                                      },
                                      child: const Text("SET ON BOTH", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                                    ),
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.white)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("CANCEL", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text("SET AS WALLPAPER", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !isPreviewMode,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: InkWell(
                            onTap: () async {
                              String imageUrl = widget.wallpaper.src['large'] ?? '';
                              String? downloadedImagePath = await ImageDownloader.downloadAndSaveImage(imageUrl);
                              if (downloadedImagePath != null) {
                                bool success = await saveImageToGallery(downloadedImagePath);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(success ? 'Image saved to gallery!' : 'Failed to save image.')),
                                  );
                                }
                              }
                            },
                            child: const Icon(size: 25, Icons.download, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 15),
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isPreviewMode = true;
                              });
                            },
                            child: const Icon(size: 25, Icons.visibility, color: Colors.black),
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
                                    style: const TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.w200, shadows: [Shadow(color: Colors.black45, blurRadius: 10)]),
                                  ),
                                  Text(
                                    getFormattedDate(),
                                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400, shadows: [Shadow(color: Colors.black45, blurRadius: 10)]),
                                  ),
                                ],
                              ),
                            ),
                            const Positioned(
                              bottom: 50,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 30, shadows: [Shadow(color: Colors.black45, blurRadius: 10)]),
                                  SizedBox(height: 10),
                                  Text("Swipe up to unlock", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500, shadows: [Shadow(color: Colors.black45, blurRadius: 10)])),
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
}
