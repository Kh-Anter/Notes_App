import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/lock_controller.dart';
import 'package:note/controller/settings_controller.dart';
import 'package:note/screens/home_screen.dart';
import 'package:note/screens/security_question_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({Key? key}) : super(key: key);
  static const routeName = "/PinScreen";

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  var fToast = FToast();
  final settingCtrl = Get.put(SettingController());

  bool newPinRenenter = false;
  String? parent = Get.arguments;
  final lockCtrl = Get.put(LockController());
  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: parent == null ? null : _myAppBar(),
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
          SizedBox(
              width: double.infinity,
              child: Obx(
                () => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 35, bottom: 35),
                      child: Text(
                        newPinRenenter ? "reEnterThePin".tr : "enterThePin".tr,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _fourNumbers(),
                    const SizedBox(height: 60),
                    _myKeyBoard(),
                    if (settingCtrl.securityQ != "" && parent == null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextButton(
                                onPressed: () => Get.toNamed(
                                    SecurityQuestionScreen.routeName),
                                child: Text(
                                  "forgot password?".tr,
                                  style: const TextStyle(
                                      color: mySecondaryColor,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      )

                    // const SizedBox(height: 40),
                  ],
                ),
              )),
        ],
      ),
    );
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

  Widget _fourNumbers() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
              4,
              (index) => Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: keyboardBtb),
                    child: Center(
                        child: Text(
                      _fourNumbersBtnText(index),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                  )),
        ),
      ),
    );
  }

  String _fourNumbersBtnText(int index) {
    switch (index) {
      case 0:
        if (lockCtrl.fourNums.isEmpty) {
          return "";
        } else {
          return lockCtrl.fourNums.value[0];
        }
      case 1:
        if (lockCtrl.fourNums.value.length < 2) {
          return "";
        } else {
          return lockCtrl.fourNums.value[1];
        }
      case 2:
        if (lockCtrl.fourNums.value.length < 3) {
          return "";
        } else {
          return lockCtrl.fourNums.value[2];
        }
      case 3:
        if (lockCtrl.fourNums.value.length < 4) {
          return "";
        } else {
          return lockCtrl.fourNums.value[3];
        }
    }
    return "";
  }

  Widget _myKeyBoard() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 370,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1.3),
              itemBuilder: (context, index) {
                if (index == 9) {
                  if (lockCtrl.fourNums.value.length == 4) {
                    return IconButton(
                        onPressed: checkAction,
                        icon: const Icon(Icons.check, size: 25));
                  } else {
                    return const Text("");
                  }
                } else if (index == 11) {
                  return IconButton(
                      icon: const Icon(
                        Icons.backspace,
                        size: 25,
                        color: Colors.black,
                      ),
                      onPressed: deleteAction

                      // },
                      );
                } else {
                  return _keyboartBtnText(index);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void deleteAction() {
    if (lockCtrl.fourNums.value.isNotEmpty) {
      print("hhhhhhhhhhhhhhhhhhhhh");
      lockCtrl.fourNums.value = lockCtrl.fourNums.value
          .substring(0, lockCtrl.fourNums.value.length - 1);
    }
  }

  void checkAction() {
    if (parent == null) {
      // parent is null when is login;
      if (settingCtrl.appPin == lockCtrl.fourNums.value) {
        Get.offAndToNamed(HomeScreen.routeName);
      } else {
        fToast.showToast(
          child: myToast("Wrong pin".tr, color: Colors.red.shade200),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
        lockCtrl.fourNums.value = "";
      }
    } else {
      if (newPinRenenter) {
        if (lockCtrl.finalfourNum == lockCtrl.fourNums.value) {
          settingCtrl.changePin(lockCtrl.finalfourNum);
          Get.back();
        }
      } else {
        lockCtrl.finalfourNum = lockCtrl.fourNums.value;
        lockCtrl.fourNums.value = "";
        newPinRenenter = true;
      }
    }
  }

  Widget _keyboartBtnText(int index) {
    String? num, txt;
    var action = () {};
    switch (index) {
      case 0:
        num = "1";
        action = () {
          if (lockCtrl.fourNums.value.length < 4) {
            lockCtrl.fourNums.value += "1";
          }
        };
        break;
      case 1:
        num = "2";
        txt = "ABC";
        action = () {
          if (lockCtrl.fourNums.value.length < 4) {
            lockCtrl.fourNums.value += "2";
          }
        };
        break;
      case 2:
        num = "3";
        txt = "DEF";
        action = () {
          if (lockCtrl.fourNums.value.length < 4) {
            lockCtrl.fourNums.value += "3";
          }
        };
        break;
      case 3:
        num = "4";
        txt = "GHI";
        action = () {
          if (lockCtrl.fourNums.value.length < 4) {
            lockCtrl.fourNums.value += "4";
          }
        };
        break;
      case 4:
        num = "5";
        txt = "JKL";
        action = () {
          if (lockCtrl.fourNums.value.length < 4) {
            lockCtrl.fourNums.value += "5";
          }
        };
        break;
      case 5:
        num = "6";
        txt = "MNO";
        action = () {
          if (lockCtrl.fourNums.value.length < 4) {
            lockCtrl.fourNums.value += "6";
          }
        };
        break;
      case 6:
        num = "7";
        txt = "PQRS";
        action = () {
          if (lockCtrl.fourNums.value.length < 4) {
            lockCtrl.fourNums.value += "7";
          }
        };
        break;
      case 7:
        num = "8";
        txt = "TUV";
        action = () {
          if (lockCtrl.fourNums.value.length < 4) {
            lockCtrl.fourNums.value += "8";
          }
        };
        break;
      case 8:
        num = "9";
        txt = "WXYZ";
        action = () {
          if (lockCtrl.fourNums.value.length < 4) {
            lockCtrl.fourNums.value += "9";
          }
        };
        break;
      case 10:
        num = "0";
        action = () {
          if (lockCtrl.fourNums.value.length < 4) {
            lockCtrl.fourNums.value += "0";
          }
        };
        break;
    }
    return InkWell(
      onTap: action,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      child: Container(
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: keyboardBtb),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  num ?? "",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (txt != null)
                  Text(txt,
                      style: const TextStyle(
                          fontSize: 12, color: mySecondTextColor))
              ],
            ),
          )),
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
