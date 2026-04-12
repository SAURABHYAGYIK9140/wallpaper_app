import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaper_app/ads/AdsService.dart';
import 'package:wallpaper_app/models/Wallpaper.dart';
import 'package:wallpaper_app/services/Api.dart';
import 'package:http/http.dart' as http;

class MainController extends GetxController {
  List<Wallpaper> allwallpapers = <Wallpaper>[].obs;
  var isLoading = true.obs;
  var currentPage = 10;
  var selected_catname="";
  BannerAd? bannerAd;
  RxBool isBannerLoaded = false.obs;
  int actionCount = 0;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    AdsService().loadInterstitial();
    AdsService().loadRewarded();
    AdsService().loadRewardedInterstitial();
    AdsService().loadAppOpen();
    loadBanner();

  }
  // void onUserAction() {
  //   actionCount++;
  //   if (actionCount % 3 == 0) {
  //     AdsService().showInterstitial();
  //   }
  // }

  DateTime? lastAdTime;

  void onUserAction() {
    actionCount++;

    if (actionCount < 3) return;

    if (lastAdTime != null &&
        DateTime.now().difference(lastAdTime!) < Duration(seconds: 30)) {
      return;
    }

    if (Random().nextInt(100) < 30) {
      AdsService().showInterstitial();
      lastAdTime = DateTime.now();
      actionCount = 0;
    }
  }

  void loadBanner() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdsService().bannerId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isBannerLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          isBannerLoaded.value = false;
        },
      ),
    )..load();
  }
  void _getData() async {
    // isLoading.value = true;

    final response = await MyApi.get_curateddata(currentPage, perPage: 10);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var photos = data['photos'] as List;
      print("get_curateddata" + data.toString());
      isLoading.value = false;
      // Add only new items to the list
      allwallpapers.addAll(photos
          .map<Wallpaper>((e) => Wallpaper.fromJson(e))
          .toList());
      currentPage += 10; // Increment page by 10 after fetching data
    } else {
      // Handle error
      print("Failed to fetch data");
    }
  }
  void cleardata()
  {
    allwallpapers.clear();

  }
  void getDataByCat(String catname,bool clearlist) async {
    onUserAction();
    selected_catname=catname;
    if(clearlist)
      {
        allwallpapers.clear();
        currentPage = 1;

      }
    print("getDataByCat" + catname.toString());

    isLoading.value = true;

    final response = await MyApi.get_curateddata_bycat(catname,currentPage, perPage: 10);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var photos = data['photos'] as List;
      print("catname_get_curateddata" + photos.toString());
      isLoading.value = false;

      allwallpapers.addAll(
          photos.map<Wallpaper>((e) => Wallpaper.fromJson(e)).toList());
      currentPage += 10; // Increment page by 10 after fetching data
    } else {
      // Handle error
      print("Failed to fetch data");
    }
  }

  void loadMoreData() {
    if(selected_catname==""){
      _getData();

    }else{
      getDataByCat(selected_catname,false);

    }
  }
}
