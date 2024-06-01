import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageDownloader {
  static Future<String?> downloadAndSaveImage(String imageUrl) async {
    try {
      // Send a GET request to the image URL
      final http.Response response = await http.get(Uri.parse(imageUrl));

      // Get the local app directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String localPath = appDir.path;

      // Generate a unique file name for the image
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

      // Create a new file in the local directory
      final File localFile = File('$localPath/$fileName');

      // Write the image data to the local file
      await localFile.writeAsBytes(response.bodyBytes);

      // Return the local path of the downloaded image
      return localFile.path;
    } catch (e) {
      print('Error downloading image: $e');
      return null;
    }
  }
}
