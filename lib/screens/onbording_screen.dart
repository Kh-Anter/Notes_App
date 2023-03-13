import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/controller/onboarding_controller.dart';

import 'package:note/widgets/splash_widgets/build_dot.dart';
import '../constants.dart';
import '../size_config.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  static const routeName = "/Onboarding";

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final myPageController = PageController();
  int currentIndex = 0;
  final OnboardingCtrl controller = Get.put(OnboardingCtrl());

  @override
  void dispose() {
    myPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig size = SizeConfig();
    size.init(context);
    return Scaffold(
      body: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight - 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: (SizeConfig.screenHeight - 100) / 6,
              child: Obx(() => Text(
                    controller.currentPage == 0 ? "welcome".tr : "",
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  )),
            ),
            SizedBox(
              width: SizeConfig.getProportionateScreenWidth(248),
              height: SizeConfig.getProportionateScreenHeight(220),
              child: PageView(
                onPageChanged: ((value) {
                  controller.changePageView(value);
                }),
                controller: myPageController,
                children: [
                  Image.asset("assets/images/onboarding/0.png",
                      fit: BoxFit.contain),
                  Image.asset("assets/images/onboarding/1.png"),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: (SizeConfig.screenHeight - 100) / 6,
              //   color: Colors.pink,
              child: Obx(() => Text(
                    controller.currentPage == 0
                        ? "add your notes".tr
                        : "add your voice notes".tr,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
      bottomSheet: SizedBox(
          height: 100,
          child: Obx(() =>
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                BuildDot(length: 2, currentIndex: controller.currentPage.value),
                SizedBox(
                  width: SizeConfig.getProportionateScreenWidth(99),
                  height: SizeConfig.getProportionateScreenHeight(42),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                          backgroundColor:
                              MaterialStateProperty.all(myPrimaryColor)),
                      child: Text(
                        controller.currentPage.value == 0
                            ? "next".tr
                            : "start".tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      onPressed: () {
                        if (controller.currentPage.value == 0) {
                          myPageController.animateToPage(1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        } else {
                          controller.writeInSharedPreferences();
                          Get.offAllNamed("/Home");
                        }
                      }),
                )
              ]))),
    );
  }
}
