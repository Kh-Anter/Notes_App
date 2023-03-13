import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/note/recordController.dart';
import '../controller/note/note_controller.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);
  static const routeName = "/record";

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final RecordController controller = Get.put(RecordController());
  final NoteController noteCtrl = Get.put(NoteController());
  @override
  void initState() {
    super.initState();
    controller.initRecorder();
  }

  @override
  void dispose() {
    controller.recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.recorderState == RecordStatus.start) {
          return true;
        } else {
          return await showWarning(context) ?? false;
        }
      },
      child: Scaffold(
          appBar: _myAppBar(),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                micImage(),
                SizedBox(
                  width: double.infinity,
                  child: SvgPicture.asset("assets/icon/Audio.svg"),
                ),
                myTimer(),
                saveAndCancelBtns(),
              ],
            ),
          )),
    );
  }

  _myAppBar() {
    return AppBar(
      toolbarHeight: 35,
      leading: InkWell(
        onTap: () async {
          if (controller.recorderState == RecordStatus.start) {
            Get.back();
          } else {
            if (await showWarning(context) ?? false) {
              Get.back();
            }
          }
        },
        child: Container(
          height: 35,
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
            color: myPrimaryColor,
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(left: 15, bottom: 2),
          child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
                  backgroundColor: MaterialStateProperty.all(myPrimaryColor)),
              onPressed: controller.recorderState.value == RecordStatus.start
                  ? null
                  : () {
                      controller.stop().then((value) {
                        Get.back();
                      });
                    },
              child: Text("save".tr)),
        ),
      ],
    );
  }

  micImage() {
    return Expanded(child: Obx(() {
      var soundDecibls = controller.soundDecibls.value;
      return Container(
        // margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.all(45),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                blurRadius: 1.0,
                blurStyle: BlurStyle.inner,
                color: myPrimaryColor.withOpacity(0.7),
                spreadRadius: 10),
            if (soundDecibls > 20)
              BoxShadow(
                  blurRadius: 1.0,
                  blurStyle: BlurStyle.inner,
                  color: myPrimaryColor.withOpacity(0.5),
                  spreadRadius: 20),
            if (soundDecibls > 35)
              BoxShadow(
                  blurRadius: 20.0,
                  blurStyle: BlurStyle.inner,
                  color: myPrimaryColor.withOpacity(0.3),
                  spreadRadius: soundDecibls < 30
                      ? 30.0
                      : soundDecibls < 35
                          ? 35.0
                          : soundDecibls < 40
                              ? 40.0
                              : soundDecibls < 45
                                  ? 45.0
                                  : soundDecibls < 50
                                      ? 50.0
                                      : 45)
          ],
          border: Border.all(color: myPrimaryColor, width: 20),
          color: Colors.white,
        ),
        child: SvgPicture.asset("assets/icon/mic.svg"),
      );
    }));
  }

  myTimer() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(() => Text(
          "${controller.twoDigitsMinits.value.toString().padLeft(2, '0')}:${controller.twoDigitsSeconds.value.toString().padLeft(2, '0')}",
          style: const TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: recordTime))),
    );
  }

  saveAndCancelBtns() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(
            () => SizedBox(
                width: 100,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        controller.recorderState.value == RecordStatus.start
                            ? controller.record()
                            : controller.recorderState.value ==
                                    RecordStatus.record
                                ? controller.pause()
                                : controller.recorderState.value ==
                                        RecordStatus.pause
                                    ? controller.resume()
                                    : controller.stop();
                      });
                    },
                    child: Text(
                      controller.recorderState.value == RecordStatus.start
                          ? "record".tr
                          : controller.recorderState.value ==
                                  RecordStatus.record
                              ? "stopRecord".tr
                              : "resumeRecord".tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ))),
          ),
          SizedBox(
            width: 100,
            child: OutlinedButton(
                onPressed: () => setState(() {
                      controller.cancel();
                    }),
                child: Text("cancel".tr,
                    style: const TextStyle(
                        color: mySecondaryColor, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    );
  }

  Future<bool?> showWarning(context) async => showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Discard record?".tr),
            content: Text("go back and cancel record".tr),
            actions: <Widget>[
              OutlinedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          const BorderSide(color: myPrimaryColor)),
                      foregroundColor:
                          MaterialStateProperty.all(myPrimaryColor)),
                  onPressed: () {
                    Get.back(result: false);
                  },
                  child: Text(
                    "cancel".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(myPrimaryColor)),
                  onPressed: () {
                    controller.cancel();
                    Get.back(result: true);
                  },
                  child: Text("discard".tr,
                      style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          );
        },
      );
}
