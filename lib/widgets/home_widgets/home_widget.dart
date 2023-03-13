import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/home_controller.dart';
import 'package:note/controller/settings_controller.dart';

import 'package:note/widgets/home_widgets/notes_shape/firstShape.dart';
import 'package:note/widgets/home_widgets/notes_shape/fourthShape.dart';
import 'package:note/widgets/home_widgets/notes_shape/secondShape.dart';
import 'package:note/widgets/home_widgets/notes_shape/thirdShap.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({Key? key}) : super(key: key);
  final SettingController settingCtrl = Get.put(SettingController());
  final HomeController homeCtrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    print("-----------rebuild home widget");
    return SafeArea(
        child: Stack(children: [
      Column(
        children: [
          //search widget
          searchBar(context),
          FutureBuilder(
              future: homeCtrl.fetchData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return settingCtrl.homeShape == 0
                      ? FirstShape()
                      : settingCtrl.homeShape == 1
                          ? SecondShap()
                          : settingCtrl.homeShape == 2
                              ? ThirdShap(ParentWidget.addNote)
                              : FourthShape();
                } else {
                  return const Center();
                }
              })
        ],
      ),
      Obx(() {
        bool isArrOpened = homeCtrl.isArrangeNotesOpen.value;
        if (!homeCtrl.isNotesEmpty && isArrOpened) {
          return sortNodes();
        }
        return const Center();
      }),
    ]));
  }

  searchBar(context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34), color: searchBGColor),
      child: StatefulBuilder(
        builder: (context, setState) => Row(
          children: [
            Expanded(
              child: TextField(
                controller: homeCtrl.searchCtr,
                onChanged: (key) => homeCtrl.search(key),
                onTap: () {
                  if (homeCtrl.isArrangeNotesOpen.value) {
                    homeCtrl.isArrangeNotesOpen.value = false;
                  }

                  if (homeCtrl.searchCtr.selection ==
                      TextSelection.fromPosition(TextPosition(
                          offset: homeCtrl.searchCtr.text.length - 1))) {
                    setState(() {
                      homeCtrl.searchCtr.selection = TextSelection.fromPosition(
                          TextPosition(offset: homeCtrl.searchCtr.text.length));
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: "search".tr,
                  prefixIcon:
                      const Icon(Icons.search, color: myTextFieldBorderColor),
                  border:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            if (homeCtrl.searchCtr.text.trim() != "")
              IconButton(
                  onPressed: () => setState(() {
                        homeCtrl.searchCtr.clear();
                        FocusScope.of(context).unfocus();
                        homeCtrl.search("");
                      }),
                  icon: const Icon(Icons.close,
                      color: myTextFieldBorderColor, size: 20)),
            const SizedBox(width: 8)
          ],
        ),
      ),
    );
  }

  sortNodes() {
    return Positioned(
      top: 0,
      left: Get.locale.toString() == "ar" ? 10 : null,
      right: Get.locale.toString() == "en" ? 10 : null,
      child: Container(
          width: 120,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: mySecondaryColor)),
          child: //Obx(() =>
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
                onTap: () {
                  settingCtrl.isNotesInASCOrder.value = true;
                  homeCtrl.isArrangeNotesOpen.value = false;
                },
                child: Row(
                  children: [
                    Icon(settingCtrl.isNotesInASCOrder.value
                        ? Icons.check
                        : null),
                    Text(
                      "asc".tr,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    )
                  ],
                )),
            const SizedBox(height: 5),
            InkWell(
                onTap: () {
                  settingCtrl.isNotesInASCOrder.value = false;
                  homeCtrl.isArrangeNotesOpen.value = false;
                },
                child: Row(
                  children: [
                    Icon(settingCtrl.isNotesInASCOrder.value
                        ? null
                        : Icons.check),
                    Text(
                      "dsc".tr,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    )
                  ],
                ))
          ])),
      // )
    );
  }
}
