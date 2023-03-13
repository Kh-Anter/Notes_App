import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/controller/sqllite_ctrl.dart';
import 'package:note/models/department.dart';

class DepartmentController extends GetxController {
  final depName = TextEditingController();
  int depColor = 0;
  final SqlliteHelper sqlliteCtrl = Get.put(SqlliteHelper());
  HashSet selectedDepartments = HashSet();
  // List<Department> i = [];
  List<Department> allDepartments = [];

  Future<void> saveDepartment() async {
    var id = await sqlliteCtrl.addDepartmentToSQLLite(depName.value.text, 0);
    print(depName.value.text);
    var newDep = Department(id: id!, name: depName.text, cover: 0);
    allDepartments.add(newDep); //add to array
    update();
    //add to sqllite
  }

  Future fetchDepartments() async {
    allDepartments = [];
    var result = await sqlliteCtrl.fetchAllDepartments();
    print("-------result $result");
    for (int i = 0; i < result.length; i++) {
      allDepartments.add(Department(
        id: result[i]["departmentId"],
        name: result[i]["name"],
        cover: result[i]["cover"],
      ));
    }
    print("----- all departments---- $result");
  }

  void deleteDepartments() {
    for (int i = 0; i < selectedDepartments.length; i++) {
      allDepartments.remove(selectedDepartments.elementAt(i));
      sqlliteCtrl.deleteDepartment(selectedDepartments.elementAt(i));
    }
    selectedDepartments.clear();
    update();
  }

  void updateDepColor(Department dep) {
    allDepartments[allDepartments.indexWhere((element) => element == dep)]
        .cover = depColor;
    update();
    sqlliteCtrl.updateDepColor(dep.id, depColor);
  }
}
