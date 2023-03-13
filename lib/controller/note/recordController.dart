import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note/constants.dart';
import 'package:note/controller/note/note_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class RecordController extends GetxController {
  late FlutterSoundRecorder recorder;
  RxBool isRecorderReady = false.obs;
  var recorderState = RecordStatus.start.obs;
  RxInt soundDecibls = 0.obs;
  Timer? timer;
  StreamSubscription<RecordingDisposition>? _recorderSubscription;
  RxInt twoDigitsMinits = 0.obs;
  RxInt twoDigitsSeconds = 0.obs;
  late Stopwatch stopWatch;
  String? _path;
  String? _resultPath;

  Future initRecorder() async {
    recorder = FlutterSoundRecorder();
    stopWatch = Stopwatch();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw ("micro phone not allowed ):");
    }
    await recorder.openRecorder();
    isRecorderReady.value = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 50));
    final directory = await getApplicationDocumentsDirectory();
    _path = directory.path;
  }

  Future _writeFileToStorage() async {
    String date =
        DateFormat("yyyy-mm-dd hh-mm-ss").format(DateTime.now()).toString();
    File newAudiofile = File('$_path/$date.aac');
    File audiofile = File('$_resultPath');
    Uint8List bytes = await audiofile.readAsBytes();
    await newAudiofile.writeAsBytes(bytes);
    final noteCtrl = Get.put(NoteController());
    noteCtrl.swapNote.audio!.add(newAudiofile.path);
    noteCtrl.newRecords.add(newAudiofile.path);
    noteCtrl.update();
  }

  Future record() async {
    if (!isRecorderReady.value) return;
    recorder.startRecorder(toFile: "Recording_");
    recorderState.value = RecordStatus.record;
    timer = Timer.periodic(const Duration(seconds: 1), (_) => calcTimer());
    stopWatch.start();
    _recorderSubscription = recorder.onProgress!.listen((event) {
      soundDecibls.value = event.decibels!.floor();
    });
    update();
  }

  Future pause() async {
    if (!isRecorderReady.value) return;
    await recorder.pauseRecorder();
    recorderState.value = RecordStatus.pause;
    _recorderSubscription!.pause();
    update();
  }

  Future resume() async {
    if (!isRecorderReady.value) return;
    await recorder.resumeRecorder();
    recorderState.value = RecordStatus.record;
    _recorderSubscription!.resume();
    update();
  }

  Future<String> stop() async {
    if (!isRecorderReady.value) return "";
    _resultPath = await recorder.stopRecorder();
    await _writeFileToStorage();
    recorderState.value = RecordStatus.start;
    timer!.cancel();
    twoDigitsMinits.value = 0;
    twoDigitsSeconds.value = 0;
    _recorderSubscription!.cancel();
    update();
    return "";
  }

  calcTimer() {
    if (recorderState.value == RecordStatus.record) {
      if (twoDigitsSeconds.value == 59) {
        twoDigitsSeconds.value = 0;
        twoDigitsMinits.value += 1;
      } else {
        twoDigitsSeconds.value++;
      }
    }
  }

  cancel() {
    if (recorderState.value != RecordStatus.start) {
      recorder.closeRecorder();
      _recorderSubscription!.cancel();
      timer!.cancel();
      twoDigitsSeconds.value = 0;
      twoDigitsMinits.value = 0;
      recorderState.value = RecordStatus.start;
    } else {
      recorderState.value = RecordStatus.start;
      Get.back();
    }
  }

  deleteRecordFromSwap(String filePath) {
    NoteController noteCtrl = Get.put(NoteController());
    noteCtrl.swapNote.audio!.remove(filePath);
    noteCtrl.deletedRecords.add(filePath);
    noteCtrl.update();
  }

  static Future deleteRecordFromStorge(String filePath) async {
    try {
      await File(filePath).delete();
    } catch (e) {
      throw ("----unable to delete record---- $e");
    }
  }
}
