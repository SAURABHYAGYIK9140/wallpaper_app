import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/collection_bloc.dart';
import '../widgets/WallpaperItem.dart';
import 'wallpaperfullview.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dispatch event to load collection when screen builds
    context.read<CollectionBloc>().add(GetCollectionEvent());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "My Collection",
          style: GoogleFonts.alike(
            textStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: BlocBuilder<CollectionBloc, CollectionState>(
        builder: (context, state) {
          if (state.isLoading && state.wallpapers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final wallpapers = state.wallpapers;

          if (wallpapers.isEmpty) {
            return const Center(
              child: Text(
                "Your collection is empty",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: MasonryGridView.builder(
              itemCount: wallpapers.length,
              mainAxisSpacing: 7,
              crossAxisSpacing: 4,
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WallpaperFullView(wallpaper: wallpapers[index]),
                      ),
                    );
                  },
                  child: WallpaperItem(
                    wallpaper: wallpapers[index],
                    index: index,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
