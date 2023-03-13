import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/department_controller.dart';
import 'package:note/controller/home_controller.dart';
import 'package:note/controller/settings_controller.dart';
import 'package:note/models/department.dart';
import 'package:note/screens/departmentDetails_screen.dart';
import 'package:note/widgets/department_widgets/add_department_widget.dart';
import 'package:note/widgets/department_widgets/department_card_widget.dart';
import 'package:note/widgets/home_widgets/notes_shape/thirdShap.dart';

class FourthShape extends StatelessWidget {
  FourthShape({Key? key}) : super(key: key);

  final HomeController homeCtrl = Get.put(HomeController());
  final SettingController settingCtrl = Get.put(SettingController());
  final DepartmentController controller = Get.put(DepartmentController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20),
                child: Text("department".tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                height: 200,
                child: GetBuilder<DepartmentController>(
                  builder: (controller) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(10),
                    itemCount: controller.allDepartments.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return const AddDepartmentWidget();
                      }
                      return SizedBox(
                        width: 110,
                        child: Stack(children: [
                          InkWell(
                            onTap: () => Get.toNamed(
                                DepartmentDetailsScreen.routeName,
                                arguments:
                                    controller.allDepartments[index - 1]),
                            child: DepartmentCardWidget(
                                title:
                                    controller.allDepartments[index - 1].name!,
                                color:
                                    controller.allDepartments[index - 1].cover),
                          ),
                          Positioned(
                              bottom: 10,
                              left: 2,
                              child: InkWell(
                                onTap: () => changeDepColor(
                                    controller.allDepartments[index - 1]),
                                child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: myPrimaryColor,
                                        border: Border.all(
                                            color: Colors.white, width: 2)),
                                    child: SvgPicture.asset(
                                      alignment: Alignment.center,
                                      "assets/icon/draw_icon.svg",
                                      fit: BoxFit.scaleDown,
                                    )),
                              ))
                        ]),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    "notes".tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              ThirdShap(ParentWidget.fourthShape)
            ],
          ),
          if (homeCtrl.allNotes.isEmpty)
            Column(
              children: [
                const Spacer(),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Addyourfirstnote".tr,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 50)
              ],
            ),
        ],
      ),
    );
  }

  changeDepColor(Department dep) {
    controller.depColor = dep.cover;
    return showDialog(
      context: settingCtrl.navigatorKey.currentContext!,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) => AlertDialog(
            content: SizedBox(
              width: 50,
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: departmentCardColors.length,
                  itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          controller.depColor = index;
                          dialogSetState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          width: 50,
                          decoration: BoxDecoration(
                              border: controller.depColor == index
                                  ? Border.all(width: 3, color: Colors.green)
                                  : null,
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  colors: departmentCardColors[index],
                                  begin: Alignment.bottomCenter)),
                        ),
                      )),
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
                  onPressed: () {
                    //   departmentDetailsCtrl.updateDepName(dep);
                    controller.updateDepColor(dep);
                    Get.back();
                    // dialogSetState(() {});
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
