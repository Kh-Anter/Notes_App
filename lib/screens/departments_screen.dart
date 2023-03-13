import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/department_controller.dart';
import 'package:note/controller/home_controller.dart';
import 'package:note/controller/note/note_controller.dart';
import 'package:note/models/department.dart';
import 'package:note/screens/departmentDetails_screen.dart';
import 'package:note/widgets/department_widgets/add_department_dialoge.dart';
import 'package:note/widgets/department_widgets/department_card_widget.dart';

class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({Key? key}) : super(key: key);
  static const routeName = "/department";

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreen();
}

class _DepartmentsScreen extends State<DepartmentsScreen> {
  final HomeController homeCtrl = Get.put(HomeController());
  final DepartmentController departmentCtrl = Get.put(DepartmentController());
  final NoteController noteCtrl = Get.put(NoteController());

  String arg = Get.arguments[0];
  bool isMultiSelectionEnabled = Get.arguments[1];

  bool isTextEmpty = true;

  @override
  void initState() {
    super.initState();

    if (arg == "addNote") {
      departmentCtrl.selectedDepartments.clear();
      departmentCtrl.selectedDepartments
          .addAll(noteCtrl.swapNote.departments as Iterable);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepartmentController>(
        builder: (controller) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: _myAppBar(arg),
              body: SafeArea(
                  child: Stack(
                children: [
                  Positioned(
                      bottom: 0,
                      right: -100,
                      left: 0,
                      child: SvgPicture.asset(
                        "assets/icon/background_right.svg",
                        fit: BoxFit.cover,
                      )),
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 38.0, left: 8, right: 8),
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                        children: List.generate(
                          controller.allDepartments.length,
                          (index) => Stack(children: [
                            InkWell(
                                onTap: () {
                                  if (isMultiSelectionEnabled) {
                                    doMultipleSelection(
                                        controller.allDepartments[index]);
                                  } else {
                                    Get.toNamed(
                                        DepartmentDetailsScreen.routeName,
                                        arguments:
                                            controller.allDepartments[index]);
                                  }
                                },
                                onLongPress: () {
                                  isMultiSelectionEnabled = true;
                                  doMultipleSelection(
                                      controller.allDepartments[index]);
                                },
                                child: DepartmentCardWidget(
                                    title:
                                        controller.allDepartments[index].name!,
                                    color: controller
                                        .allDepartments[index].cover)),
                            if (departmentCtrl.selectedDepartments
                                .contains(controller.allDepartments[index]))
                              const Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.check,
                                    size: 40,
                                    color: Colors.white,
                                  )),
                            Positioned(
                                bottom: 10,
                                left: 2,
                                child: InkWell(
                                  onTap: () => changeDepColor(
                                      controller.allDepartments[index]),
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
                                )),
                          ]),
                        ),
                      )),
                ],
              )),
            ));
  }

  doMultipleSelection(Department department) {
    setState(() {
      if (departmentCtrl.selectedDepartments.contains(department)) {
        departmentCtrl.selectedDepartments.remove(department);
        if (departmentCtrl.selectedDepartments.isEmpty && arg == "dep") {
          isMultiSelectionEnabled = false;
        }
      } else {
        //  departmentCtrl.i.add(department);
        departmentCtrl.selectedDepartments.add(department);
      }
    });
  }

  _myAppBar(arg) {
    return AppBar(
        toolbarHeight: 35,
        title: Text("department".tr),
        leading: InkWell(
          onTap: () {
            departmentCtrl.selectedDepartments.clear();
            Get.back();
          },
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
        actions: appBarActions());
  }

  appBarActions() {
    return [
      if (arg == "dep" && isMultiSelectionEnabled)
        IconButton(
            onPressed: () {
              departmentCtrl.deleteDepartments();
              isMultiSelectionEnabled = false;
            },
            icon: const Icon(Icons.delete, color: Colors.redAccent)),
      if (arg == "addNote")
        Row(
          children: [
            IconButton(
                onPressed: () {
                  departmentCtrl.selectedDepartments.clear();
                  Get.back();
                },
                icon: const Icon(Icons.close)),
            IconButton(
                onPressed: () {
                  // noteCtrl.swapNote.departments = departmentCtrl
                  //     .selectedDepartments
                  //     .toList()
                  //     .cast<Department>();
                  noteCtrl.calcChangesInDepartments(
                      departmentCtrl.selectedDepartments);
                  departmentCtrl.selectedDepartments.clear();
                  Get.back();
                },
                icon: const Icon(
                  Icons.check,
                ))
          ],
        ),
      IconButton(
          onPressed: () => AddDepartmentDialog.addNewDep(context),
          icon: SvgPicture.asset("assets/icon/folder-add.svg")),
    ];
  }

  changeDepColor(Department dep) {
    departmentCtrl.depColor = dep.cover;
    return showDialog(
      context: context,
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
                          departmentCtrl.depColor = index;
                          dialogSetState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          width: 50,
                          decoration: BoxDecoration(
                              border: departmentCtrl.depColor == index
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
                    departmentCtrl.updateDepColor(dep);
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
