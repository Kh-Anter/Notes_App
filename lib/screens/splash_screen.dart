import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/settings_controller.dart';
import 'package:note/screens/home_screen.dart';

import '../screens/onbording_screen.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
  static const routeName = "/Splash";
  final settingCtrl = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 100000,
      duration: 3000,
      animationDuration: const Duration(milliseconds: 1000),
      splash: Column(
        children: [
          const SizedBox(height: 130),
          SizedBox(
              width: 250,
              height: 200,
              child: Image.asset("assets/images/splash_screen/note.png",
                  fit: BoxFit.fill)),
          const Spacer(),
          SizedBox(
            width: 400,
            height: 400,
            child: Stack(
              children: [
                Positioned(
                  left: -190,
                  bottom: 0,
                  child: SvgPicture.asset(
                    "assets/images/splash_screen/bottom.svg",
                  ),
                ),
                const Positioned(
                    left: 90,
                    bottom: 180,
                    child: Icon(Icons.circle, color: myPrimaryColor, size: 50)),
                const Positioned(
                    right: 90,
                    bottom: 80,
                    child: Icon(Icons.circle, color: myPrimaryColor)),
                const Positioned(
                    right: 70,
                    bottom: 100,
                    child: Icon(Icons.circle, color: myPrimaryColor)),
              ],
            ),
          ),
        ],
      ),
      nextScreen: settingCtrl.isFirstTime
          ? const OnBoardingScreen()
          : const HomeScreen(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
