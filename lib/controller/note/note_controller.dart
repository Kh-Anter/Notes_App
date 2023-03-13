import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/add_alert_controller.dart';
import 'package:note/controller/departmentDetails_controller.dart';
import 'package:note/controller/department_controller.dart';
import 'package:note/controller/favorite_controller.dart';
import 'package:note/controller/home_controller.dart';
import 'package:note/controller/note/recordController.dart';
import 'package:note/controller/sqllite_ctrl.dart';
import 'package:note/models/alert.dart';
import 'package:note/models/department.dart';
import 'package:note/models/note.dart';

class NoteController extends GetxController {
  RecordController recordController = Get.put(RecordController());
  HomeController homeCtrl = Get.put(HomeController());
  DepartmentController departmentCtrl = Get.put(DepartmentController());
  DepartmentDetailsController departmentDetailsCtrl =
      Get.put(DepartmentDetailsController());
  FavoriteController favCtrl = Get.put(FavoriteController());
  SqlliteHelper sqlliteCtrl = Get.put(SqlliteHelper());
  Note swapNote = Note(
      departments: [],
      isRTL: Get.locale.toString() == "ar" ? true : false,
      noteTitle: TextEditingController(),
      noteBody: TextEditingController());
  List<String> deletedRecords = [];
  List<Alert> deletedAlerts = [];
  List<Department> deletedDepartments = [];
  List<String> deletedImags = [];
  List<String> newRecords = [];
  List<Alert> newAlerts = [];
  List<Department> newDepartments = [];
  List<String> newImags = [];

  DateTime? selectedDate = DateTime.now();
  String? day, month, year;
  bool letterA = false;
  dynamic commingNote = "";
  List<String> allFonts = [
    "Amiri",
    "Aref_Ruqaa",
    "Cairo",
    "IBM_Plex_Sans",
    "Mynerve",
    "New_Rocker",
    "Roboto",
    "Scheh",
    "Shantell_Sans"
  ];

  init(commingNote) {
    Note.clearData(swapNote);
    if (commingNote != "") {
      this.commingNote = commingNote;
      swapNote = Note.addData(swapNote, commingNote);
      if (swapNote.alerts != null || swapNote.alerts != []) {
        for (int i = 0; i < swapNote.alerts!.length; i++) {
          if (swapNote.alerts![i].date.isBefore(DateTime.now())) {
            deletedAlerts.add(swapNote.alerts![i]);
            swapNote.alerts!.remove(swapNote.alerts![i]);
            // commingNote.alerts!.remove(swapNote.alerts![i]);
          }
        }
        updateAlerts(swapNote.note_id!);
      }
      selectedDate = swapNote.date;
    } else {
      Note.clearData(swapNote);
    }
  }

  noteDate() {
    if (selectedDate == null) {
      var now = DateTime.now();
      day = now.day.toString();
      year = now.year.toString();
      month = Get.locale.toString() == "en"
          ? EngMONTHS[now.month - 1].toString()
          : ArMONTHS[now.month - 1].toString();
    } else {
      day = selectedDate!.day.toString();
      year = selectedDate!.year.toString();
      month = Get.locale.toString() == "en"
          ? EngMONTHS[selectedDate!.month - 1].toString()
          : ArMONTHS[selectedDate!.month - 1].toString();
    }
  }

  Future saveNote() async {
    swapNote.date = selectedDate;
    var id;
    // mean new note created
    if (commingNote == "") {
      id = await sqlliteCtrl.addNoteToSQLLite(swapNote);
      swapNote.note_id = id;
      homeCtrl.allNotes.add(Note.getNewNote(swapNote));
      homeCtrl.allNotes.sort((a, b) => b.date.compareTo(a.date));
      if (homeCtrl.isNotesEmpty) {
        homeCtrl.changeIsNotesEmpty(false);
        homeCtrl.isArrangeNotesOpen.value = false;
      }
      await saveNoteDepartments(id!);
      await saveImages(id);
      await saveRecords(id);

      // mean update on note
    } else // if edit on note
    if (!swapNote.isEquel(commingNote) ||
        deletedDepartments.isNotEmpty ||
        newDepartments.isNotEmpty) {
      id = commingNote.note_id;
      updateDepartments(id);
      updateImages(id);
      updateRecords(id);
      updateAlerts(id);
      Note.addData(commingNote, swapNote);
      homeCtrl.allNotes.sort((a, b) => b.date.compareTo(a.date));
      sqlliteCtrl.updateNote(commingNote);

      commingNote = "";
      // await saveNoteDepartments(id);
      //  await saveImages(id);
    }
    homeCtrl.update();
  }

  Future updateImages(id) async {
    for (String img in deletedImags) {
      await sqlliteCtrl.deleteImage(img, id);
    }
    for (String img in newImags) {
      await sqlliteCtrl.addImageToSql(id, img);
    }
    deletedImags = [];
    newImags = [];
  }

  Future updateDepartments(id) async {
    for (Department dep in newDepartments) {
      await sqlliteCtrl.addNoteDepartmentToSQLLite(id, dep.id);
      swapNote.departments!.add(dep);
    }
    newDepartments.clear();

    for (Department dep in deletedDepartments) {
      await sqlliteCtrl.deleteNoteFromNoteDepartment(id, dep.id);
      swapNote.departments!.remove(dep);
    }
    deletedDepartments.clear();
  }

  Future updateRecords(id) async {
    for (String url in deletedRecords) {
      await RecordController.deleteRecordFromStorge(url);
      sqlliteCtrl.deleteRecrods(id, url);
    }
    deletedRecords.clear();
    for (String url in newRecords) {
      sqlliteCtrl.addRecrods(id, url);
    }
    newRecords.clear();
  }

  Future updateAlerts(id) async {
    var alertCtrl = Get.put(AddAlertController());
    for (Alert alert in deletedAlerts) {
      await alertCtrl.removeAlertFromStorage(alert.id);
      AddAlertController.cancelAlert(alert.id);
    }
    deletedAlerts.clear();
    // newRecords.clear();
  }

  Future saveNoteDepartments(int noteId) async {
    if (swapNote.departments != null) {
      for (var element in swapNote.departments!) {
        await sqlliteCtrl.addNoteDepartmentToSQLLite(noteId, element.id);
      }
    }
  }

  Future saveImages(int noteId) async {
    if (commingNote == "") {
      for (var element in swapNote.img!) {
        await sqlliteCtrl.addImageToSql(noteId, element);
      }
    } else {
      await sqlliteCtrl.deleteAllImages(noteId);
      for (var element in swapNote.img!) {
        await sqlliteCtrl.addImageToSql(noteId, element);
      }
    }
  }

  Future saveRecords(int noteId) async {
    if (commingNote == "") {
      for (var element in swapNote.audio!) {
        await sqlliteCtrl.addRecrods(noteId, element);
      }
    }
  }

  calcChangesInDepartments(hashset) {
    if (commingNote != "") {
      List<Department> selected = hashset.toList().cast<Department>();
      if (!listEquals(selected, swapNote.departments)) {
        //  newDepartments.add()
        var newD = selected.toSet().difference(swapNote.departments!.toSet());
        var deletedD =
            swapNote.departments!.toSet().difference(selected.toSet());
        for (Department dep in newD) {
          newDepartments.add(dep);
        }
        for (Department dep in deletedD) {
          deletedDepartments.add(dep);
        }
      }
    } else {
      swapNote.departments =
          departmentCtrl.selectedDepartments.toList().cast<Department>();
    }
  }
}
