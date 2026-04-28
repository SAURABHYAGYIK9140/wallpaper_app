import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import '../bloc/wallpaper_bloc.dart';
import '../bloc/wallpaper_event.dart';
import '../bloc/wallpaper_state.dart';
import '../widgets/Categoryitem.dart';
import '../widgets/WallpaperItem.dart';
import 'collection_screen.dart';
import 'wallpaperfullview.dart';
import '../../domain/entities/wallpaper_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController textcontroller = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    textcontroller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<WallpaperBloc>().add(LoadMoreEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  query: 'subject=Wallify Mode Support',
                );
                await launchUrl(emailUri);
              }
              if (value == 'privacy') {
                final Uri url = Uri.parse('https://v0-wallify-policy-page-m7cm5exvj-saurabh-s-projects-2b332bae.vercel.app/#privacy');
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
              if (value == 'about') {
                showAboutDialog(
                  context: context,
                  applicationName: 'Wallify',
                  applicationVersion: '1.0.0',
                  applicationLegalese: 'your own wallpaper app.',
                );
              }
              if (value == 'ChangeTheme') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CollectionScreen()),
                );
              }
              if (value == 'share') {
                const String appLink = "https://play.google.com/store/apps/details?id=com.saurabh.wallify"; // Replace with your actual app link
                await Share.share("Check out this amazing wallpaper app: $appLink");
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'ChangeTheme',
                child: Row(
                  children: [
                    Icon(Icons.wallpaper, color: Colors.white),
                    SizedBox(width: 12),
                    Text("See your collection", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share_outlined, color: Colors.white),
                    SizedBox(width: 12),
                    Text("Share App", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'contact',
                child: Row(
                  children: [
                    Icon(Icons.email_outlined, color: Colors.white),
                    SizedBox(width: 12),
                    Text("Contact Us", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'privacy',
                child: Row(
                  children: [
                    Icon(Icons.privacy_tip_outlined, color: Colors.white),
                    SizedBox(width: 12),
                    Text("Privacy Policy", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white),
                    SizedBox(width: 12),
                    Text("About", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.black,
        title: Text(
          "Wallify",
          style: GoogleFonts.alike(
            textStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              '✨ Your Screen Deserves the Best – Discover, Download, and Set Today! ✨',
              style: GoogleFonts.alef(
                textStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                controller: textcontroller,
                onChanged: (value) async {
                  _timer?.cancel();
                  _timer = Timer(const Duration(seconds: 1), () {
                    if (value.isEmpty) {
                      context.read<WallpaperBloc>().add(GetCuratedEvent());
                    } else {
                      context.read<WallpaperBloc>().add(SearchWallpapersEvent(value));
                    }
                  });
                },
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search your wallpaper here ",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CategoryItem(
              onCategorySelected: () {
                textcontroller.clear();
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: BlocBuilder<WallpaperBloc, WallpaperState>(
                  builder: (context, state) {

                    List<WallpaperEntity> wallpapers = [];
                    bool isLoading = false;

                    if (state is WallpaperLoading && state.isFirstFetch) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is WallpaperLoaded) {
                      wallpapers = state.wallpapers;
                    } else if (state is WallpaperLoading) {
                      wallpapers = state.oldWallpapers;
                      isLoading = true;
                    } else if (state is WallpaperError) {
                      return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
                    }

                    return Stack(
                      children: [
                        MasonryGridView.builder(
                          controller: _scrollController,
                          itemCount: wallpapers.length,
                          mainAxisSpacing: 7,
                          crossAxisSpacing: 4,
                          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => WallpaperFullView(wallpaper: wallpapers[index])),
                                );
                              },
                              child: WallpaperItem(
                                wallpaper: wallpapers[index],
                                index: index,
                              ),
                            );
                          },
                        ),
                        if (isLoading)
                          const Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Ad Banner logic can be integrated here similarly by wrapping with another BlocBuilder or using a separate Bloc for Ads if needed.
            // For now, keeping it simple as we are refactoring.
          ],
        ),
      ),
    );
  }
}
