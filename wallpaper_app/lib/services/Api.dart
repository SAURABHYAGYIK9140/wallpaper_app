import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../constants/AppConstraints.dart';

class MyApi{
  static Future<http.Response> get_curateddata(int per_page) async {
    var url = Uri.parse(AppConstraints.BASE_URL+"curated?per_page="+per_page.toString());
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Authorization': 'yI8j2TOVfpkAgIsmLLKSS4vIF4460ydNBKmjf6CD8HTfTJL8e8piKFYY'
    };

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();
    return http.Response(resBody, res.statusCode, headers: res.headers);

  }
  static Future<http.Response> get_curateddata_bycat(String search) async {
    var url = Uri.parse(AppConstraints.BASE_URL+"search?query="+search+"&per_page=10");
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Authorization': 'yI8j2TOVfpkAgIsmLLKSS4vIF4460ydNBKmjf6CD8HTfTJL8e8piKFYY'
    };
    print("catname_get_curateddata" + url.toString());

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();
    return http.Response(resBody, res.statusCode, headers: res.headers);

  }
}