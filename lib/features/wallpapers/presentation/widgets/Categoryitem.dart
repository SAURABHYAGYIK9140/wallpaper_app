import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/wallpaper_bloc.dart';
import '../bloc/wallpaper_event.dart';

class CategoryItem extends StatefulWidget {
  final VoidCallback? onCategorySelected;
  const CategoryItem({super.key, this.onCategorySelected});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  int selectedIndex = 0;

  List<String> categoryList = [
    "All",
    "Nature",
    "Abstract",
    "Animals",
    "Art",
    "Cars",
    "City",
    "Fantasy",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categoryList.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                if (widget.onCategorySelected != null) {
                  widget.onCategorySelected!();
                }
                if (categoryList[index] == "All") {
                  context.read<WallpaperBloc>().add(GetCuratedEvent());
                } else {
                  context.read<WallpaperBloc>().add(SearchWallpapersEvent(categoryList[index]));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: index == selectedIndex ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  categoryList[index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
