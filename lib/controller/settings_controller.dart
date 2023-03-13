import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/utils/themes/darkmode.dart';
import 'package:note/utils/themes/lightmode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  final navigatorKey = GlobalKey<NavigatorState>();
  SharedPreferences? myLocalData;
  late String language = "ar";
  late String mode = "light";
  late bool isFirstTime = true;
  late int homeShape;
  late int appShape = 0;
  late RxBool isNotesInASCOrder = true.obs;
  late bool isAppLock = false;
  late String appPin, securityQ, securityA;

  init() async {
    myLocalData = await SharedPreferences.getInstance();
    language = myLocalData!.getString("language") ?? "ar";
    mode = myLocalData!.getString("mode") ?? "light";
    isFirstTime = myLocalData!.getBool("firstUse") == null ? true : false;
    homeShape = myLocalData!.getInt("homeShape") ?? 3;
    appShape = myLocalData!.getInt("appShape") ?? 0;
    isNotesInASCOrder.value = myLocalData!.getBool("isNotesInASCOrder") ?? true;
    isAppLock = myLocalData!.getBool("isAppLock") ?? false;
    appPin = myLocalData!.getString("appPin") ?? "";
    securityQ = myLocalData!.getString("securityQ") ?? "";
    securityA = myLocalData!.getString("securityA") ?? "";
  }

  changeSecurityQuestion(String? question, String? answer) {
    securityQ = question ?? "";
    securityA = answer ?? "";
    addToCach(name: "securityQ", value: question);
    addToCach(name: "securityA", value: answer);
  }

  changePin(String newPin) {
    appPin = newPin;
    addToCach(name: "appPin", value: newPin);
  }

  changeHomeShape(int newShapeIndex) {
    homeShape = newShapeIndex;
    myLocalData!.setInt("homeShape", newShapeIndex);
    update();
  }

  changeAppShape(int newShape) {
    appShape = newShape;
    myLocalData!.setInt("appShape", newShape);
    update();
  }

  changeMode() {
    if (mode == "dark") {
      mode = "light";
      Get.changeTheme(lightMode);
    } else {
      mode = "dark";
      Get.changeTheme(darkMode);
    }
    addToCach(name: "mode", value: mode);
    update();
  }

  changeLanguage() {
    if (language == "en") {
      language = "ar";
    } else {
      language = "en";
    }
    addToCach(name: "language", value: language);
    Get.updateLocale(Locale(language));
    update();
  }

  changeAppLock() async {
    isAppLock = !isAppLock;
    await myLocalData!.setBool("isAppLock", isAppLock);
  }

  addToCach({required name, required value}) async {
    await myLocalData!.setString(name, value);
  }
}
