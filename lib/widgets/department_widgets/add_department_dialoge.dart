import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/department_controller.dart';

class AddDepartmentDialog {
  static addNewDep(context) {
    bool saveLoading = false;
    final departmentCtrl = Get.put(DepartmentController());
    departmentCtrl.depName.clear();
    bool isTextEmpty = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              content: TextField(
                controller: departmentCtrl.depName,
                onChanged: (_) {
                  dialogSetState(() {
                    if (departmentCtrl.depName.value.text.trim() == "") {
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
                        : () async {
                            dialogSetState(() => saveLoading = true);
                            departmentCtrl
                                .saveDepartment()
                                .then((_) => Get.back());
                          },
                    child: saveLoading
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          )
                        : Text("agree".tr,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
              ],
            );
          },
        );
      },
    );
  }
}
