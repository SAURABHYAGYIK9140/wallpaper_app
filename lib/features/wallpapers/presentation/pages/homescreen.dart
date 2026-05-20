import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../bloc/wallpaper_bloc.dart';
import '../bloc/wallpaper_event.dart';
import '../bloc/wallpaper_state.dart';
import '../widgets/Categoryitem.dart';
import '../widgets/WallpaperItem.dart';
import 'collection_screen.dart';
import 'wallpaperfullview.dart';
import '../../domain/entities/wallpaper_entity.dart';
import '../../../../core/ads/AdsService.dart';
import '../../../../core/services/IAPService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController textcontroller = TextEditingController();
  Timer? _timer;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _bannerAd = BannerAd(
      adUnitId: AdsService().bannerId,
      size: AdSize.banner,
      request: AdsService().request,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() {}),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();
    AdsService().loadInterstitial();
    AdsService().loadRewarded();
    IAPService().init();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    textcontroller.dispose();
    _timer?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  void _showAdFreeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AdFreeBottomSheet(),
    );
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
              if (value == 'adfree') {
                _showAdFreeBottomSheet(context);
              }
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
                const String appLink = "https://play.google.com/store/apps/details?id=com.saurabh.wallify";
                await Share.share("Check out this amazing wallpaper app: $appLink");
              }
            },
            itemBuilder: (context) => [
              // ── Ad-Free upgrade (highlighted) ──────────────────────────────
              PopupMenuItem(
                value: 'adfree',
                child: ValueListenableBuilder<bool>(
                  valueListenable: IAPService().isAdFree,
                  builder: (_, adFree, __) => Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                        ).createShader(bounds),
                        child: const Icon(Icons.workspace_premium, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        adFree ? 'Ad-Free ✓ Activated' : 'Go Ad-Free ✨',
                        style: TextStyle(
                          color: adFree ? Colors.greenAccent : const Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const PopupMenuDivider(),
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
            // Hide the banner while the store restore is in-flight (prevents
            // a brief ad flash after reinstall) AND when the user is ad-free.
            ValueListenableBuilder<bool>(
              valueListenable: IAPService().isRestoring,
              builder: (_, restoring, __) => ValueListenableBuilder<bool>(
                valueListenable: IAPService().isAdFree,
                builder: (_, adFree, __) {
                  if (adFree || restoring || _bannerAd == null) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    height: 50,
                    child: AdWidget(ad: _bannerAd!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Ad-Free Purchase Bottom Sheet ───────────────────────────────────────────

class _AdFreeBottomSheet extends StatelessWidget {
  const _AdFreeBottomSheet();

  @override
  Widget build(BuildContext context) {
    final iap = IAPService();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Premium icon + gradient title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
            ).createShader(bounds),
            child: const Icon(Icons.workspace_premium, color: Colors.white, size: 52),
          ),
          const SizedBox(height: 12),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
            ).createShader(bounds),
            child: const Text(
              'Wallify Premium',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'One-time purchase · No subscription',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Feature list
          _FeatureTile(icon: Icons.block, label: 'Remove all banner & interstitial ads'),
          _FeatureTile(icon: Icons.bolt_rounded, label: 'Faster, cleaner browsing experience'),
          _FeatureTile(icon: Icons.all_inclusive, label: 'Support the developer ❤️'),
          const SizedBox(height: 28),

          // Error message
          ValueListenableBuilder<String?>(
            valueListenable: iap.errorMessage,
            builder: (_, msg, __) {
              if (msg == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(msg,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                    textAlign: TextAlign.center),
              );
            },
          ),

          // Already activated check
          ValueListenableBuilder<bool>(
            valueListenable: iap.isAdFree,
            builder: (_, adFree, __) {
              if (adFree) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.4)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, color: Colors.greenAccent),
                        SizedBox(width: 10),
                        Text('Ad-Free is active!',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                  ),
                );
              }

              return ValueListenableBuilder<bool>(
                valueListenable: iap.isPurchasing,
                builder: (_, purchasing, __) => Column(
                  children: [
                    // Buy button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: purchasing
                              ? null
                              : () async {
                                  await iap.buyAdFree();
                                },
                          child: purchasing
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      color: Colors.black, strokeWidth: 2.5))
                              : Text(
                                  iap.priceString != null
                                      ? 'Buy for ${iap.priceString}'
                                      : 'Go Ad-Free ✨',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Restore button
                    TextButton(
                      onPressed: purchasing ? null : () => iap.restorePurchases(),
                      child: const Text('Restore Purchase',
                          style: TextStyle(color: Colors.white54, fontSize: 13)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFF8C00)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.black, size: 16),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

