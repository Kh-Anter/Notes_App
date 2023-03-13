import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/departmentDetails_controller.dart';
import 'package:note/controller/settings_controller.dart';
import 'package:note/widgets/home_widgets/notes_shape/thirdShap.dart';

class DepartmentDetailsScreen extends StatefulWidget {
  const DepartmentDetailsScreen({Key? key}) : super(key: key);
  static const routeName = "/DepartmentDetails";

  @override
  State<DepartmentDetailsScreen> createState() =>
      _DepartmentDetailsScreenState();
}

class _DepartmentDetailsScreenState extends State<DepartmentDetailsScreen> {
  final departmentDetailsCtrl = Get.put(DepartmentDetailsController());
  // final noteCtrl = Get.put(NoteController());
  // final settingCtrl = Get.put(SettingController());
  var dep = Get.arguments;
  bool isTextEmpty = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: _myAppBar(),
        body: GetBuilder<SettingController>(
          builder: (controller) => DecoratedBox(
            decoration: BoxDecoration(
                image: controller.appShape == "bg0.jpg"
                    ? null
                    : DecorationImage(
                        image: AssetImage(
                            "assets/images/app_shape/bg${controller.appShape}.jpg"),
                        fit: BoxFit.cover)),
            child: GetBuilder<DepartmentDetailsController>(
              builder: (controller) => FutureBuilder(
                  future: departmentDetailsCtrl.fetchDepartmentChildren(dep),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          ThirdShap(ParentWidget.departmentDetails,
                              depId: dep.id),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ),
        ));
  }

  _myAppBar() {
    return AppBar(
      toolbarHeight: 35,
      title: Text(dep.name),
      leading: InkWell(
        onTap: (() => Get.back()),
        child: Container(
          height: 35,
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
      actions: [
        IconButton(
            onPressed: () {
              editDepartmentName();
            },
            icon: const Icon(Icons.edit))
      ],
    );
  }

  editDepartmentName() {
    departmentDetailsCtrl.depNameController.text = dep.name;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) => AlertDialog(
            content: TextField(
              controller: departmentDetailsCtrl.depNameController,
              onTap: () {
                if (departmentDetailsCtrl.depNameController.selection ==
                    TextSelection.fromPosition(TextPosition(
                        offset: departmentDetailsCtrl
                                .depNameController.text.length -
                            1))) {
                  setState(() {
                    departmentDetailsCtrl.depNameController.selection =
                        TextSelection.fromPosition(TextPosition(
                            offset: departmentDetailsCtrl
                                .depNameController.text.length));
                  });
                }
              },
              onChanged: (_) {
                dialogSetState(() {
                  if (departmentDetailsCtrl.depNameController.text.trim() ==
                      "") {
                    isTextEmpty = true;
                  } else {
                    isTextEmpty = false;
                  }
                });
              },
              decoration: InputDecoration(
                  hintText: "department name".tr,
                  errorText: isTextEmpty ? "enterDepName".tr : null),
            ),
            actions: <Widget>[
              OutlinedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          const BorderSide(color: myPrimaryColor)),
                      foregroundColor:
                          MaterialStateProperty.all(myPrimaryColor)),
                  onPressed: () => Get.back(),
                  child: Text(
                    "cancel".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(myPrimaryColor)),
                  onPressed: isTextEmpty
                      ? null
                      : () {
                          departmentDetailsCtrl.updateDepName(dep);
                          Get.back();
                          setState(() {});
                        },
                  child: Text("agree".tr,
                      style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        );
      },
    );
  }
}
