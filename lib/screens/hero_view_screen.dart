import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeroViewScreen extends StatelessWidget {
  HeroViewScreen({Key? key}) : super(key: key);
  static const routeName = "/heroViewScreen";
  var arg = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: "",
        child: Container(
            //  margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          image: DecorationImage(image: Image.file(arg).image),
        )),
      ),
    );
  }
}
