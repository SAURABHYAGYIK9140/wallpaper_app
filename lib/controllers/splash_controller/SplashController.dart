import 'package:get/get.dart';

import '../../utils/route_pages/page_name.dart';

class SplashController extends GetxController {
  var seconds = 3.obs;

  @override
  void onInit() {
    _startTimer();
    super.onInit();
  }

  _startTimer() {
    Future.delayed(Duration(seconds: seconds.value), () {
      Get.offNamed(MyPagesName.homescreen);
      // Get.offNamed(MyPagesName.demo);
    });
  }
}
