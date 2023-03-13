import 'package:get/get.dart';
import 'package:note/controller/home_controller.dart';
import 'package:note/controller/sqllite_ctrl.dart';
import 'package:note/models/note.dart';

class FavoriteController extends GetxController {
  final homeCtrl = Get.put(HomeController());
  final sqlliteCtrl = Get.put(SqlliteHelper());
  RxList allNotes = [].obs;
  initAllFav() {
    allNotes.value = [];
    for (var element in homeCtrl.allNotes) {
      if (element.isFav) allNotes.add(element);
    }
  }

  deleteNote(Note theNote) {
    allNotes.remove(theNote);
    homeCtrl.deleteNote(theNote);
    update();
  }

  deleteNoteFromFav(Note theNote) {
    sqlliteCtrl.updateNote(theNote);
    allNotes.remove(theNote);
    homeCtrl.allNotes[homeCtrl.allNotes.indexOf(theNote)].isFav = false;

    update();
  }
}
