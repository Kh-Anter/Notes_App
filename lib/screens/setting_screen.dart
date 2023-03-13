import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/settings_controller.dart';
import 'package:note/screens/about_us_screen.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);
  static const routeName = "/Setting";
  TextStyle ts = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  SettingController settingCtrl = Get.put(SettingController());
  String? dropDownValue;
  @override
  Widget build(BuildContext context) {
    dropDownValue = settingCtrl.language;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          centerTitle: false,
          title: Text("setting".tr),
          leadingWidth: 60,
          leading: InkWell(
            onTap: () => Get.back(),
            child: Container(
              alignment: Alignment.center,
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
          )),
      body: SafeArea(
          child: Column(children: [
        const SizedBox(height: 30),
        ListTile(
          leading: const Icon(Icons.language, color: myPrimaryColor),
          title: Text("language".tr, style: ts),
          trailing: SizedBox(
            width: 50,
            height: 50,
            child: StatefulBuilder(
              builder: (context, dropDownSetState) => DropdownButton(
                value: dropDownValue,
                items: [
                  DropdownMenuItem(
                    value: "en",
                    onTap: () {
                      if (dropDownValue != "en") settingCtrl.changeLanguage();
                    },
                    child: const Text("EN"),
                  ),
                  DropdownMenuItem(
                    value: "ar",
                    onTap: () {
                      if (dropDownValue != "ar") settingCtrl.changeLanguage();
                    },
                    child: const Text("AR"),
                  )
                ],
                onChanged: (newValue) {},
              ),
            ),
          ),
        ),
        ListTile(
            leading: const Icon(Icons.mode_night, color: myPrimaryColor),
            title: Text("night mode".tr, style: ts),
            trailing: mySwitch()),
        ListTile(
          leading: const Icon(Icons.info_outline, color: myPrimaryColor),
          title: Text("about app".tr, style: ts),
          onTap: () => Get.toNamed(AboutUsScreen.routeName),
        ),
      ])),
    );
  }

  Widget mySwitch() {
    bool currentSwitchVal = settingCtrl.mode == "dark" ? true : false;
    return StatefulBuilder(
      builder: (context, setState) => GestureDetector(
        onHorizontalDragStart: (details) => setState(() {
          currentSwitchVal = !currentSwitchVal;
          settingCtrl.changeMode();
        }),
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
}
