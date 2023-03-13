import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCtrl extends GetxController {
  RxInt currentPage = 0.obs;

  changePageView(newPage) {
    currentPage.value = newPage;
  }

  Future<void> writeInSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstUse', false);
  }
}
