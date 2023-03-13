import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/settings_controller.dart';
import 'package:note/screens/pin_screen.dart';
import 'package:note/screens/security_question_screen.dart';

class LockAppScreen extends StatelessWidget {
  LockAppScreen({Key? key}) : super(key: key);
  static const routeName = "/LockAppScreen";
  var fToast = FToast();

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
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
              "assets/images/home/drawer2.svg",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 25),
              Expanded(child: _myList()),
            ],
          ),
        ],
      ),
    );
  }

  _myList() {
    var txtstyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    return ListView(
      children: [
        ListTile(
          minVerticalPadding: 20,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "app lock".tr,
              style: txtstyle,
            ),
          ),
          subtitle: Text("app lock_Subtitle".tr),
          trailing: mySwitch(),
        ),
        ListTile(
            onTap: () => Get.toNamed(PinScreen.routeName,
                arguments: "fromLockAppScreen"),
            minVerticalPadding: 20,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "set app lock".tr,
                style: txtstyle,
              ),
            ),
            subtitle: Text("set app lock_Subtitle".tr)),
        ListTile(
          onTap: () => Get.toNamed(SecurityQuestionScreen.routeName,
              arguments: "fromLockAppScreen"),
          minVerticalPadding: 20,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "set security question".tr,
              style: txtstyle,
            ),
          ),
          subtitle: Text("set security question_Subtitle".tr),
        ),
      ],
    );
  }

  _myAppBar() {
    return AppBar(
      toolbarHeight: 35,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(
            Icons.lock_outlined,
            color: mySecondaryColor,
          ),
          Text("setAppLock".tr),
          const SizedBox(width: 20)
        ],
      ),
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

  Widget mySwitch() {
    final SettingController settingCtrl = Get.put(SettingController());
    bool currentSwitchVal = settingCtrl.isAppLock;
    return StatefulBuilder(
      builder: (context, setState) => GestureDetector(
        onHorizontalDragStart: (details) {
          setState(() {
            currentSwitchVal = !currentSwitchVal;
            settingCtrl.changeAppLock();
          });
          if (settingCtrl.appPin == "") {
            setState(() {
              fToast.showToast(
                child:
                    myToast("Enter a pin first".tr, color: Colors.red.shade200),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );
              currentSwitchVal = !currentSwitchVal;
              settingCtrl.changeAppLock();
            });
          }
        },
        child: AnimatedContainer(
          width: 40,
          height: 23,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: currentSwitchVal ? mySecondaryColor : Colors.white,
              border: Border.all(color: switchBorder)),
          duration: myAnimationDuration,
          child: AnimatedAlign(
            duration: mySwitchDuration,
            alignment:
                currentSwitchVal ? Alignment.bottomLeft : Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentSwitchVal ? Colors.white : mySecondaryColor),
              ),
            ),
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
