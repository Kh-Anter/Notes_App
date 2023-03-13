import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);
  static const routeName = "/AboutUs";
  static const titleStyle =
      TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
  static const subtitleStyle =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _myAppBar(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset(
                  "assets/images/splash_screen/note2.png",
                  width: SizeConfig.screenWidth / 1.5,
                )
              ]),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "aboutusTitle".tr,
                      style: titleStyle,
                    ),
                    TextSpan(
                      text: "aboutusP1".tr,
                      style: const TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "aboutusT2".tr,
                      style: subtitleStyle,
                    ),
                    TextSpan(
                      text: "aboutusP2".tr,
                      style: const TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "aboutusT3".tr,
                      style: subtitleStyle,
                    ),
                    TextSpan(
                      text: "aboutusP3".tr,
                      style: const TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text:
                          'https://www.facebook.com/profile.php?id=100090329423752',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(Uri.parse(
                              'https://www.facebook.com/profile.php?id=100090329423752'));
                        },
                    ),
                    TextSpan(
                      text: "aboutusP4".tr,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  _myAppBar() {
    return AppBar(
      toolbarHeight: 35,
      title: Text("about app".tr),
      leading: InkWell(
        onTap: (() => Get.back()),
        child: Container(
          height: 35,
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
            color: myPrimaryColor,
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
