import 'package:flutter/material.dart';
import 'package:wallpaper_app/controllers/main_controller/main_controller.dart';
import 'package:get/get.dart';
class CategoryItem extends StatefulWidget {
  const CategoryItem({Key? key}) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  int selectedIndex = 0;
  MainController _mainController=Get.put(MainController());

  List<String> categoryList = [
    "All",
    "Nature",
    "Abstract",
    "Animals",
    "Art",
    "Cars",
    "City",
    "Fantasy",
    // Add more categories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categoryList.length,
              (index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                _mainController.getdata_bycat(categoryList[selectedIndex]);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: index == selectedIndex ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  categoryList[index],
                  style: TextStyle(
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
