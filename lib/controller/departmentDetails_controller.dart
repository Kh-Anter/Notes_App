import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/controller/department_controller.dart';
import 'package:note/controller/home_controller.dart';
import 'package:note/controller/sqllite_ctrl.dart';
import 'package:note/models/note.dart';

class DepartmentDetailsController extends GetxController {
  final sqlliteCtrl = Get.put(SqlliteHelper());
  final homeCtrl = Get.put(HomeController());
  final departmentCtrl = Get.put(DepartmentController());
  RxList allNotes = [].obs;
  TextEditingController depNameController = TextEditingController();

  Future fetchDepartmentChildren(dep) async {
    allNotes.value = [];
    var result = await sqlliteCtrl.fetchAllDepartmentChildren(dep.id);
    print("-----$result");
    for (int i = 0; i < result.length; i++) {
      allNotes.add(homeCtrl.allNotes
          .firstWhere((element) => element.note_id == result[i]["note_id"]));
    }

    return allNotes;
  }

  updateDepName(dep) {
    departmentCtrl
        .allDepartments[departmentCtrl.allDepartments
            .indexWhere((element) => element == dep)]
        .name = depNameController.text;
    sqlliteCtrl.updateDepName(dep.id, depNameController.text);
    depNameController.clear();
  }

  deleteNote(Note theNote, depId) {
    allNotes.remove(theNote);
    sqlliteCtrl.deleteNoteFromNoteDepartment(theNote.note_id!, depId);
    update();
  }
}
