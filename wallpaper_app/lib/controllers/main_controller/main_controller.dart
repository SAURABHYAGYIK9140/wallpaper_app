import 'dart:convert';
import 'package:get/get.dart';
import 'package:wallpaper_app/models/Wallpaper.dart';
import 'package:wallpaper_app/services/Api.dart';
import 'package:http/http.dart' as http;

class MainController extends GetxController {
  List<Wallpaper> allwallpapers = <Wallpaper>[].obs;
  var isLoading = true.obs;
  var currentPage = 10;
  var selected_catname="";
  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;


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
