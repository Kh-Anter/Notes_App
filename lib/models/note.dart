import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/models/department.dart';
import 'package:flutter/foundation.dart';

class Note {
  int? note_id;
  TextEditingController noteTitle;
  TextEditingController noteBody;
  DateTime? date;
  bool isFav;
  int? emoji;
  List? audio;
  List? img;
  List? alerts;
  List<Department>? departments;
  double fSize;
  String? fFamily;
  bool isUderline;
  bool isBold;
  bool isRTL;
  int selectedColor;
  int bgColor;
  Note(
      {this.note_id,
      required this.noteTitle,
      required this.noteBody,
      this.departments,
      this.date,
      this.isFav = false,
      this.audio,
      this.img,
      this.emoji,
      this.alerts,
      this.fSize = 14,
      this.fFamily,
      this.isUderline = false,
      this.isBold = false,
      required this.isRTL,
      this.selectedColor = 0,
      this.bgColor = 0});

  bool isEquel(Note otherNote) {
    if (noteTitle.value.text == otherNote.noteTitle.value.text &&
        noteBody.value.text == otherNote.noteBody.value.text &&
        listEquals(departments, otherNote.departments) &&
        date == otherNote.date &&
        isFav == otherNote.isFav &&
        listEquals(audio, otherNote.audio) &&
        listEquals(img, otherNote.img) &&
        emoji == otherNote.emoji &&
        listEquals(alerts, otherNote.alerts) &&
        fSize == otherNote.fSize &&
        fFamily == otherNote.fFamily &&
        isUderline == otherNote.isUderline &&
        isBold == otherNote.isBold &&
        selectedColor == otherNote.selectedColor &&
        bgColor == otherNote.bgColor) {
      return true;
    } else {
      return false;
    }
  }

  static Note clearData(theNote) {
    theNote.note_id = null;
    theNote.noteTitle.text = "";
    theNote.noteBody.text = "";
    theNote.date = DateTime.now();
    theNote.isFav = false;
    theNote.fSize = 16.0;
    theNote.fFamily = null;
    theNote.isUderline = false;
    theNote.isBold = false;
    theNote.audio = [];
    theNote.img = [];
    theNote.emoji = null;
    theNote.alerts = [];
    theNote.selectedColor = 0;
    theNote.bgColor = 0;
    return theNote;
  }

  static Note addData(Note emptyNote, Note completeNote) {
    emptyNote.note_id = completeNote.note_id;
    emptyNote.noteTitle.value = completeNote.noteTitle.value;
    emptyNote.noteBody.value = completeNote.noteBody.value;
    emptyNote.departments = completeNote.departments ?? [];
    emptyNote.date = completeNote.date;
    emptyNote.isFav = completeNote.isFav;
    emptyNote.audio = [...completeNote.audio ?? []];
    emptyNote.img = [...completeNote.img ?? []];
    emptyNote.alerts = [...completeNote.alerts ?? []];
    emptyNote.emoji = completeNote.emoji;
    emptyNote.fSize = completeNote.fSize;
    emptyNote.fFamily = completeNote.fFamily;
    emptyNote.isBold = completeNote.isBold;
    emptyNote.isRTL = completeNote.isRTL;
    emptyNote.isUderline = completeNote.isUderline;
    emptyNote.selectedColor = completeNote.selectedColor;
    emptyNote.bgColor = completeNote.bgColor;
    return emptyNote;
  }

  static Note getNewNote(Note swapeNote) {
    var newNote = Note(
        // note_id: noteId,
        isRTL: Get.locale.toString() == "ar" ? true : false,
        noteTitle: TextEditingController(),
        noteBody: TextEditingController(),
        departments: <Department>[]);
    newNote = addData(newNote, swapeNote);
    return newNote;
  }

  static bool isNoteEmpty(Note otherNote) {
    return (otherNote.noteTitle.text == "" &&
        otherNote.noteBody.text == "" &&
        otherNote.departments!.isEmpty &&
        otherNote.isFav == false &&
        otherNote.audio!.isEmpty &&
        otherNote.img!.isEmpty &&
        otherNote.emoji == null &&
        otherNote.alerts!.isEmpty &&
        otherNote.fSize == 16 &&
        otherNote.fFamily == null &&
        otherNote.isUderline == false &&
        otherNote.isBold == false &&
        otherNote.selectedColor == 0 &&
        otherNote.bgColor == 0);
  }
}
