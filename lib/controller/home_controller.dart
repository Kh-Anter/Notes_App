import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/controller/add_alert_controller.dart';
import 'package:note/controller/department_controller.dart';
import 'package:note/controller/note/recordController.dart';
import 'package:note/controller/sqllite_ctrl.dart';
import 'package:note/models/alert.dart';
import 'package:note/models/department.dart';
import 'package:note/models/note.dart';

class HomeController extends GetxController {
  final SqlliteHelper sqlliteCtrl = Get.put(SqlliteHelper());
  final DepartmentController departmentCtrl = Get.put(DepartmentController());
  final TextEditingController searchCtr = TextEditingController();
  late final Future fetchData = fetchNotes();
  RxList allNotes = [].obs;
  RxList searchResult = [].obs;
  RxList allFav = [].obs;
  bool isNotesEmpty = true;
  RxBool isArrangeNotesOpen = false.obs;
  int x = 1;
  int selectedNavBar = 1;

  Future fetchNotes() async {
    allNotes.value = [];
    var result = await sqlliteCtrl.fetchAllNotes();
    await departmentCtrl.fetchDepartments();

    for (int i = 0; i < result.length; i++) {
      var noteId = result[i]["note_id"];
      allNotes.add(Note(
          note_id: noteId,
          date: DateTime.parse(result[i]["noteDate"]),
          noteTitle: TextEditingController(text: result[i]["title"].toString()),
          noteBody: TextEditingController(text: result[i]["body"].toString()),
          emoji: result[i]["emoji"],
          isFav: result[i]["isfav"] == 0 ? false : true,
          isBold: result[i]["isBold"] == 0 ? false : true,
          isRTL: result[i]["isRTL"] == 0 ? false : true,
          isUderline: result[i]["isUderline"] == 0 ? false : true,
          fFamily: result[i]["fFamily"],
          fSize: result[i]["fSize"],
          img: await fetchImages(noteId),
          alerts: await fetchAlerts(noteId),
          audio: await fetchRecords(noteId),
          departments: await fetchDepartments(noteId),
          selectedColor: result[i]["selectedColor"]));
    }
    if (allNotes.isNotEmpty) {
      changeIsNotesEmpty(false);
    }
    return result;
  }

  Future<List<String>> fetchRecords(noteId) async {
    var result = await sqlliteCtrl.fetchRecords(noteId);
    List<String> records = [];
    for (int i = 0; i < result.length; i++) {
      records.add(result[i]["recordUrl"]);
    }
    return records;
  }

  Future<List<String>> fetchImages(noteId) async {
    var result = await sqlliteCtrl.fetchImages(noteId);

    List<String> images = [];
    for (int i = 0; i < result.length; i++) {
      images.add(result[i]["imageUrl"]);
    }
    return images;
  }

  Future<List<Alert>> fetchAlerts(noteId) async {
    var result = await sqlliteCtrl.fetchAlerts(noteId);
    List<Alert> alerts = [];
    for (int i = 0; i < result.length; i++) {
      alerts
          .add(Alert(result[i]["alert_id"], DateTime.parse(result[i]["date"])));
    }
    return alerts;
  }

  Future<List<Department>> fetchDepartments(noteId) async {
    var result = await sqlliteCtrl.fetchAllDepartmentofNote(noteId);
    List<Department> dep = [];
    for (int i = 0; i < result.length; i++) {
      dep.add(departmentCtrl.allDepartments
          .firstWhere((element) => element.id == result[i]["departmentId"]));
    }

    return dep;
  }
  // deleteNoteFromSearch(Note theNote) {
  //   allNotes.remove(theNote);
  //   searchResult.
  //   sqlliteCtrl.deleteNote(theNote);
  //   if (allNotes.isEmpty) {
  //     changeIsNotesEmpty(true);
  //     isArrangeNotesOpen.value = false;
  //   }
  //   update();
  // }

  deleteNote(Note theNote, {bool isSearch = false}) async {
    if (theNote.img!.isNotEmpty) {
      for (var element in theNote.img!) {
        await File(element).delete().catchError(
            (e) => throw ("--------error ocurred when delete img ----"));
      }
    }
    if (theNote.audio!.isNotEmpty) {
      for (var element in theNote.audio!) {
        RecordController.deleteRecordFromStorge(element);
      }
    }
    if (theNote.alerts!.isNotEmpty) {
      for (var element in theNote.alerts!) {
        AddAlertController.cancelAlert(element.id);
      }
    }
    allNotes.remove(theNote);
    if (isSearch) searchResult.remove(theNote);
    sqlliteCtrl.deleteNote(theNote);
    if (allNotes.isEmpty) {
      changeIsNotesEmpty(true);
      isArrangeNotesOpen.value = false;
    }
    update();
  }

  changeIsNotesEmpty(bool value) {
    isNotesEmpty = value;
    update();
  }

  search(String key) {
    searchResult.clear();
    if (key.trim().isNotEmpty) {
      for (Note note in allNotes) {
        if (note.noteTitle.text.contains(key) ||
            note.noteBody.text.contains(key)) {
          searchResult.add(note);
        }
      }
    }
    update();
  }
}
