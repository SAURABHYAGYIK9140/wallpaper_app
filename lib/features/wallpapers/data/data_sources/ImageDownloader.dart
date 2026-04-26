import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageDownloader {
  static Future<String?> downloadAndSaveImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();

        final fileName =
            "${DateTime.now().millisecondsSinceEpoch}.jpg";

        final file = File("${dir.path}/$fileName");

        await file.writeAsBytes(response.bodyBytes);

        return file.path;
      }

      return null;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Download error: $e",
        backgroundColor: Colors.white,
        textColor: Colors.black,
        gravity: ToastGravity.BOTTOM,
      );
      print("Download error: $e");
      return null;
    }
  }

}
