import 'package:get/get.dart';

import '../../controllers/main_controller/main_controller.dart';
class MainScreenBinding extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut<MainController>(()=> MainController());
  }
  
}