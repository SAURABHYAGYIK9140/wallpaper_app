import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../models/Wallpaper.dart';
import 'WallpaperItem.dart';
class StaggeredListView extends StatelessWidget {
  final List<Wallpaper> wallpapers;

   StaggeredListView({super.key, required this.wallpapers});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,

      itemBuilder: (context, index) {
        return Text("data",style: TextStyle(color: Colors.black),);
      },
    );
  }
}