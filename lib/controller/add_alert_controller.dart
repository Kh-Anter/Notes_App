import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/home_controller.dart';
import 'package:note/controller/note/note_controller.dart';
import 'package:note/controller/sqllite_ctrl.dart';
import 'package:note/models/alert.dart';
import 'package:note/models/note.dart';
import 'package:note/models/notification.dart';

class AddAlertController extends GetxController {
  final noteCtrl = Get.put(NoteController());
  final sqlCtrl = Get.put(SqlliteHelper());
  final homeCtrl = Get.put(HomeController());
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? day, month, year;
  RxList allNotes = [].obs;

  initAllAlerts() {
    allNotes.value = [];
    for (var element in homeCtrl.allNotes) {
      if (element.alerts.length > 0) allNotes.add(element);
    }
  }

  deleteNote(Note theNote) {
    for (var a in theNote.alerts!) {
      cancelAlert(a.id);
      removeAlertFromStorage(a.id);
    }
    allNotes.remove(theNote);
    homeCtrl.allNotes[homeCtrl.allNotes.indexOf(theNote)].alerts = [];
    update();
  }

  DateTime getSelectedDate() {
    return DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day,
        selectedTime!.hour, selectedTime!.minute);
  }

  noteDate() {
    if (selectedDate == null) {
      var now = DateTime.now();
      day = now.day.toString();
      year = now.year.toString();
      month = Get.locale == 'en'
          ? EngMONTHS[now.month - 1].toString()
          : ArMONTHS[now.month - 1].toString();
    } else {
      day = selectedDate!.day.toString();
      year = selectedDate!.year.toString();
      month = Get.locale == 'en'
          ? EngMONTHS[selectedDate!.month - 1].toString()
          : ArMONTHS[selectedDate!.month - 1].toString();
    }
  }

  saveAlert(int noteId) async {
    int? alertId = await sqlCtrl.addAlertToSql(noteId, getSelectedDate());
    await MyNotification.showScheduleNotification(
        id: alertId,
        title: "notification",
        body: noteCtrl.swapNote.noteTitle.text,
        payload: "hh---dgg-hhh--h-hh",
        schedualDate: getSelectedDate());
    Alert newAlert = Alert(alertId, getSelectedDate());
    noteCtrl.swapNote.alerts!.add(newAlert);
    noteCtrl.newAlerts.add(newAlert);
    noteCtrl.update();
    Get.back();
  }

  removeAlertFromStorage(alertId) async {
    sqlCtrl.deleteAlert(alertId);
  }

  static cancelAlert(alertId) async {
    try {
      await FlutterLocalNotificationsPlugin().cancel(alertId);
    } catch (e) {
      throw ("-----can't cancel alert----$e");
    }
  }
}
