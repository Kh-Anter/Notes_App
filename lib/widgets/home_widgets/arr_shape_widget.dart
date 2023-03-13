import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/controller/home_controller.dart';
import 'package:note/controller/settings_controller.dart';

class ArrShapeWidget extends StatelessWidget {
  ArrShapeWidget({Key? key}) : super(key: key);
  final HomeController homeCtrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
        builder: (controller) => Column(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    buildImage(0, controller),
                    buildImage(1, controller)
                  ],
                )),
                Expanded(
                    child: Row(
                  children: [
                    buildImage(2, controller),
                    buildImage(3, controller)
                  ],
                )),
              ],
            ));
  }

  Widget buildImage(index, controller) {
    return Expanded(
      child: InkWell(
          child: Stack(
            children: [
              Image.asset(
                "assets/images/arrange_shape/arr_shape$index.png",
                fit: BoxFit.fill,
              ),
              if (controller.homeShape == index)
                const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.check_sharp,
                    size: 50,
                  ),
                )
            ],
          ),
          onTap: () {
            controller.changeHomeShape(index);
            homeCtrl.selectedNavBar = 1;
            homeCtrl.update();
          }),
    );
  }
}
