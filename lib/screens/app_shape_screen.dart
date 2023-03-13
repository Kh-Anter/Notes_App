import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:note/controller/home_controller.dart';

import 'package:note/controller/settings_controller.dart';
import 'package:note/size_config.dart';

class AppShapeScreen extends StatefulWidget {
  const AppShapeScreen({Key? key}) : super(key: key);
  static const routeName = "/AppShape";

  @override
  State<AppShapeScreen> createState() => _AppShapeScreenState();
}

class _AppShapeScreenState extends State<AppShapeScreen> {
  final SettingController settingCtrl = Get.put(SettingController());
  final homeCtrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController(
        initialScrollOffset:
            (SizeConfig.getProportionateScreenWidth(248) + 20) *
                (settingCtrl.appShape));
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
                Text(
                  "app shape".tr,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(35)),
                SizedBox(
                    height: SizeConfig.getProportionateScreenHeight(425),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 20,
                      itemBuilder: (context, index) =>
                          myShape(index, settingCtrl.appShape == index),
                      scrollDirection: Axis.horizontal,
                      controller: controller,
                    )),
              ],
            ),
            Positioned(
              right: 0,
              bottom: -50,
              left: -90,
              child: SvgPicture.asset(
                "assets/images/app_shape/background.svg",
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }

  myShape(theImgIndex, isSelected) {
    return InkWell(
        child: Container(
          width: SizeConfig.getProportionateScreenWidth(248),
          height: SizeConfig.getProportionateScreenHeight(425),
          margin: const EdgeInsets.all(10),
          decoration: isSelected
              ? BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 26, 122, 28), width: 5),
                  borderRadius: BorderRadius.circular(15))
              : null,
          child: Stack(children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                "assets/images/app_shape/bg$theImgIndex.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 30,
              right: 30,
              child: SizedBox(
                width: 24,
                // height: 25,
                child: Image.asset(
                  "assets/images/app_shape/top.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: -18,
              left: -25,
              right: -25,
              child: Image.asset(
                "assets/images/app_shape/bottom.png",
                fit: BoxFit.contain,
              ),
            ),
          ]),
        ),
        onTap: () {
          settingCtrl.changeAppShape(theImgIndex);
          // settingCtrl.appShape = theImgIndex;
          Get.back();
        });
  }
}
