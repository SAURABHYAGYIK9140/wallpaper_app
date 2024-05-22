import 'dart:convert';

import 'package:get/get.dart';
import 'package:wallpaper_app/models/Wallpaper.dart';
import 'package:wallpaper_app/services/Api.dart';
import 'package:wallpaper_app/ui/widgets/WallpaperItem.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MainController extends GetxController {
  List<Wallpaper> allwallpapers = <Wallpaper>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    _getdata();
    super.onInit();
  }

  _getdata() async {
    isLoading.value = true;

    http.Response response = await MyApi.get_curateddata(10);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var photos = data['photos'] as List;
      print("get_curateddata" + photos.toString());
      isLoading.value = false;
      allwallpapers.assignAll(
          photos.map<Wallpaper>((e) => Wallpaper.fromJson(e)).toList());

    }
  }

  getdata_bycat(String catname) async {
    isLoading.value = true;

    allwallpapers.clear();
    http.Response response = await MyApi.get_curateddata_bycat(catname);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var photos = data['photos'] as List;
      print("catname_get_curateddata" + photos.toString());
      isLoading.value = false;

      allwallpapers.assignAll(
          photos.map<Wallpaper>((e) => Wallpaper.fromJson(e)).toList());

    }
  }
}
