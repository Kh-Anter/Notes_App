import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/settings_controller.dart';
import 'package:note/screens/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SecurityQuestionScreen extends StatelessWidget {
  SecurityQuestionScreen({Key? key}) : super(key: key);
  static const routeName = "/securityQuestion";

  SettingController settingCtrl = Get.put(SettingController());
  TextEditingController question = TextEditingController();
  TextEditingController answer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var fToast = FToast();
    var theArg = Get.arguments ?? "";
    question.text = settingCtrl.securityQ;
    if (theArg == "") {
      answer.text = "";
    } else {
      answer.text = settingCtrl.securityA;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _myAppBar(),
      body: Stack(
        children: [
          Positioned(
            right: -80,
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              "assets/images/home/drawer1.svg",
              fit: BoxFit.cover,
            ),
          ),
          StatefulBuilder(
            builder: (context, setState) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 30),
                  child: Text(
                    theArg == ""
                        ? "EnterTheAnswer".tr
                        : "setSecurityQuestion".tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )),
                if (theArg == "")
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(width: 20),
                    Text("${settingCtrl.securityQ} \n"),
                  ]),
                if (theArg != "") Text("setSecurityQuestion2".tr),
                if (theArg != "")
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      onTap: () {
                        if (question.selection ==
                            TextSelection.fromPosition(TextPosition(
                                offset: question.text.length - 1))) {
                          setState(() {
                            question.selection = TextSelection.fromPosition(
                                TextPosition(offset: question.text.length));
                          });
                        }
                      },
                      controller: question,
                      decoration: InputDecoration(
                          hintText: "enterQuestion".tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                  child: TextField(
                    onTap: () {
                      // print(answer.selection.);
                      if (answer.selection ==
                          TextSelection.fromPosition(
                              TextPosition(offset: answer.text.length - 1))) {
                        setState(() {
                          answer.selection = TextSelection.fromPosition(
                              TextPosition(offset: answer.text.length));
                        });
                      }
                    },
                    controller: answer,
                    decoration: InputDecoration(
                        hintText: "enterAnswer".tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                ),
                SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(myPrimaryColor)),
                      onPressed: () => confirmBtnAction(theArg, fToast),
                      child: Text(
                        "Confirm".tr,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ))
              ]),
            ),
          )
        ],
      ),
    );
  }

  confirmBtnAction(theArg, fToast) {
    if (theArg == "") {
      if (answer.text.trim() == settingCtrl.securityA) {
        Get.offAndToNamed(HomeScreen.routeName);
      } else {
        FocusNode().unfocus();
        fToast.showToast(
          child: myToast("Wrong Answer".tr, color: Colors.red.shade200),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
        answer.text = "";
      }
    } else {
      settingCtrl.changeSecurityQuestion(
          question.text.trim(), answer.text.trim());
      Get.back();
    }
  }

  _myAppBar() {
    return AppBar(
      toolbarHeight: 35,
      leading: InkWell(
        onTap: (() => Get.back()),
        child: Container(
          height: 35,
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          decoration: BoxDecoration(
            borderRadius: Get.locale.toString() == "ar"
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30))
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
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

  Widget myToast(String text, {theIcon, color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (theIcon != null) theIcon,
          if (theIcon != null)
            const SizedBox(
              width: 12.0,
            ),
          Text(text),
        ],
      ),
    );
  }
}
