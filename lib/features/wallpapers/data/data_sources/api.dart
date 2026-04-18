import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:wallpaper_app/core/constants/AppConstraints.dart';

class MyApi{
  static Future<http.Response> getCuratedData(int page, {int perPage = 10}) async {
    var url = Uri.parse("${AppConstraints.BASE_URL}curated?page=$page&per_page=$perPage");
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Authorization': AppConstraints.API_KEY
    };

    var response = await http.get(url, headers: headersList);
    return response;
  }
  static Future<http.Response> getCuratedDataByCat(String search,int page, {int perPage = 10}) async {
    var url = Uri.parse("${AppConstraints.BASE_URL}search?page=$page&query=$search&per_page=$perPage");
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Authorization': AppConstraints.API_KEY
    };

    var response = await http.get(url, headers: headersList);
    return response;
  }
  static Future<http.Response> getCuratedDataByCat2(String search,) async {
    var url = Uri.parse("${AppConstraints.BASE_URL}search?query=$search&per_page=10");
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Authorization': AppConstraints.API_KEY
    };
    // print("catname_get_curateddata" + url.toString());

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();
    return http.Response(resBody, res.statusCode, headers: res.headers);

  }
}