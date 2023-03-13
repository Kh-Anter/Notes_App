import 'package:get/get.dart';
import 'package:note/models/department.dart';
import 'package:note/models/note.dart';
import 'package:sqflite/sqflite.dart';

class SqlliteHelper extends GetxController {
  Database? database;

  Future<int?> addNoteToSQLLite(Note note) async {
    int? noteId;
    try {
      await database!.transaction((txn) async {
        noteId = await txn.rawInsert(
            "INSERT INTO notes(noteDate,title,body,emoji,isfav,fSize,fFamily,isUderline,isBold,isRTL,selectedColor) VALUES (?,?,?,?,?,?,?,?,?,?,?)",
            [
              note.date!.toIso8601String(),
              note.noteTitle.value.text,
              note.noteBody.value.text,
              note.emoji,
              note.isFav ? 1 : 0,
              note.fSize,
              note.fFamily,
              note.isUderline ? 1 : 0,
              note.isBold ? 1 : 0,
              note.isRTL ? 1 : 0,
              note.selectedColor
            ]);
      });
    } catch (e) {
      throw ("--- can't add note to sqllite --- $e");
    }
    return noteId;
  }

  Future<int?> addDepartmentToSQLLite(String name, int cover) async {
    int? id;
    try {
      await database!.transaction((txn) async {
        id = await txn.rawInsert(
            "INSERT INTO department(name,cover) VALUES (?,?)", [name, cover]);
      });
    } catch (e) {
      throw ("-----------$e");
    }
    return id;
  }

  Future addNoteDepartmentToSQLLite(int noteId, int depId) async {
    try {
      await database!.transaction((txn) async {
        await txn.rawInsert(
            "INSERT INTO noteDepartment(note_id,dep_id) VALUES (?,?)",
            [noteId, depId]);
      });
    } catch (e) {
      throw ("--- can't add noteDepartment to sqllite ---");
    }
  }

  Future<int> addAlertToSql(int noteId, DateTime date) async {
    int alertId;
    try {
      alertId = await database!.transaction((txn) async {
        return await txn.rawInsert(
            "INSERT INTO alerts(note_id,date) VALUES (?,?)",
            [noteId, date.toIso8601String()]);
      });
    } catch (e) {
      throw ("--- can't add alert to sqllite ---");
    }

    return alertId;
  }

  Future deleteAlert(int alertId) async {
    await database!.rawDelete('DELETE FROM alerts WHERE alert_id = ? ', [
      alertId
    ]).catchError((e) => throw ("--- error when delete alert --- $e"));
  }

  Future addImageToSql(int noteId, String imgUrl) async {
    try {
      await database!.transaction((txn) async {
        return await txn.rawInsert(
            "INSERT INTO images(note_id,imageUrl) VALUES (?,?)",
            [noteId, imgUrl]);
      });
    } catch (e) {
      throw ("--- can't add image to sqllite ---");
    }
  }

  Future addRecrods(int noteId, String recordUrl) async {
    try {
      await database!.transaction((txn) async {
        return await txn.rawInsert(
            "INSERT INTO records(note_id,recordUrl) VALUES (?,?)",
            [noteId, recordUrl]);
      });
    } catch (e) {
      throw ("--- can't add image to sqllite ---");
    }
  }

  Future deleteRecrods(int noteId, String recordUrl) async {
    await database!.rawDelete(
        'DELETE FROM records WHERE note_id = ? AND recordUrl = ? ', [
      noteId,
      recordUrl
    ]).catchError((e) => throw ("--- error when delete record --- $e"));
  }

  Future deleteAllImages(noteId) async {
    await database!.rawDelete('DELETE FROM images WHERE note_id = ?',
        [noteId]).catchError(throw ("--- error when delete images --- "));
  }

  Future fetchAllNotes() async {
    return await database!
        .rawQuery("SELECT * FROM notes ORDER BY noteDate DESC");
  }

  Future fetchAllDepartments() async {
    return await database!.rawQuery("SELECT * FROM department");
  }

  Future fetchAllDepartmentChildren(int departmentId) async {
    return await database!.rawQuery(
        "SELECT note_id FROM noteDepartment WHERE dep_id=?",
        [departmentId]).catchError((e) {
      throw ("--- error when fetch departmentChildren --- $e");
    });
  }

  Future fetchAllDepartmentofNote(int noteId) async {
    return await database!.rawQuery(
        "SELECT * FROM department WHERE departmentId IN (SELECT dep_id FROM noteDepartment WHERE note_id=?)",
        [noteId]).catchError((e) {
      throw ("--- error when fetch departmentChildren --- $e");
    });
  }

  Future fetchRecords(noteId) async {
    return await database!.rawQuery(
        "SELECT * FROM records WHERE note_id=?", [noteId]).catchError((e) {
      throw ("--- error when fetch records --- $e");
    });
  }

  Future fetchImages(noteId) async {
    return await database!.rawQuery(
        "SELECT * FROM images WHERE note_id=?", [noteId]).catchError((e) {
      throw ("--- error when fetch images --- $e");
    });
  }

  Future fetchAlerts(noteId) async {
    return await database!.rawQuery(
        "SELECT * FROM alerts WHERE note_id=?", [noteId]).catchError((e) {
      throw ("--- error when fetch alerts --- $e");
    });
  }

  Future deleteNote(Note theNote) async {
    await database!.rawDelete('DELETE FROM notes WHERE note_id = ?',
        [theNote.note_id]).catchError((e) {
      throw ("cannot delete record from sqllite : $e");
    });
  }

  Future deleteImage(imgUrl, noteId) async {
    await database!.rawDelete(
        'DELETE FROM images  WHERE note_id = ? and imageUrl = ?',
        [noteId, imgUrl]).catchError((e) {
      throw ("cannot delete image from sqllite : $e");
    });
  }

  Future deleteNoteFromNoteDepartment(int noteId, int depId) async {
    await database!.rawDelete(
        'DELETE FROM noteDepartment WHERE  note_id = ? and  dep_id =?',
        [noteId, depId]).catchError((e) {
      throw ("cannot delete noteDepartment from sqllite : $e");
    });
  }

  Future deleteDepartment(Department department) async {
    await database!.rawDelete('DELETE FROM department WHERE departmentId =?',
        [department.id]).catchError((e) {
      throw ("cannot delete department from sqllite : $e");
    });
  }

  Future updateNote(Note newNote) async {
    await database!.rawUpdate(
        'UPDATE notes SET noteDate = ?, title = ?, body = ?, emoji = ?, isfav = ?, fSize = ?, fFamily = ?, isUderline = ?, isBold = ? ,isRTL = ? ,selectedColor = ?  WHERE note_id = ?',
        [
          newNote.date!.toIso8601String(),
          newNote.noteTitle.value.text,
          newNote.noteBody.value.text,
          newNote.emoji,
          newNote.isFav ? 1 : 0,
          newNote.fSize,
          newNote.fFamily,
          newNote.isUderline ? 1 : 0,
          newNote.isBold ? 1 : 0,
          newNote.isRTL ? 1 : 0,
          newNote.selectedColor,
          newNote.note_id,
        ]).catchError((e) => throw ("--- error when update note --- $e"));
  }

  Future updateDepName(int depId, String newName) async {
    await database!.rawUpdate(
        'UPDATE department SET name = ?  WHERE departmentId = ?', [
      newName,
      depId
    ]).catchError((e) => throw ("--- error when update dep name --- $e"));
  }

  Future updateDepColor(int depId, int cover) async {
    await database!.rawUpdate(
        'UPDATE department SET cover = ?  WHERE departmentId = ?', [
      cover,
      depId
    ]).catchError((e) => throw ("--- error when update dep color --- $e"));
  }

  _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  createDatabase() async {
    database = await openDatabase('notesAppSql',
        version: 1,
        onConfigure: _onConfigure, onCreate: (Database db, int version) async {
      await db
          .execute(
              'CREATE TABLE notes (note_id INTEGER PRIMARY KEY AUTOINCREMENT,noteDate DATE , title TEXT, body TEXT, emoji INTEGER,isfav INTEGER,fSize REAL,fFamily Text,isUderline INTEGER,isBold INTEGER,isRTL INTEGER,selectedColor INTEGER)')
          .catchError((e) => throw ("error when create notes table"));
      await db
          .execute(
              'CREATE TABLE alerts (alert_id INTEGER PRIMARY KEY AUTOINCREMENT, note_id INTEGER, date DATE ,FOREIGN KEY(note_id) REFERENCES notes(note_id)  ON DELETE CASCADE)')
          .catchError((e) => throw ("error when create alerts table"));

      await db
          .execute(
              'CREATE TABLE records (record_id INTEGER PRIMARY KEY AUTOINCREMENT, note_id INTEGER, date DATE , recordUrl Text ,FOREIGN KEY(note_id) REFERENCES notes(note_id)  ON DELETE CASCADE)')
          .catchError((e) => throw ("error when create records table"));

      await db
          .execute(
              'CREATE TABLE images (images_id INTEGER PRIMARY KEY AUTOINCREMENT, note_id INTEGER , imageUrl Text ,FOREIGN KEY(note_id) REFERENCES notes(note_id)  ON DELETE CASCADE)')
          .catchError((e) => throw ("error when create images table"));

      await db
          .execute(
              'CREATE TABLE department (departmentId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, cover INTEGER)')
          .catchError((e) => throw ("error when create department table"));

      await db.execute("""
            CREATE TABLE noteDepartment (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              note_id INTEGER NOT NULL,
              dep_id INTEGER NOT NULL,
              FOREIGN KEY (note_id) REFERENCES notes (note_id) 
                ON DELETE CASCADE,
              FOREIGN KEY (dep_id) REFERENCES department (departmentId) 
                ON DELETE CASCADE
            )""").catchError((e) => throw ("error when create noteDepartment table"));
    }, onOpen: ((db) {
      print("data base opend");
    }));
  }
}
