import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/add_alert_controller.dart';
import 'package:note/controller/note/note_controller.dart';
import 'package:note/extentions/extentions.dart';
import 'package:note/models/notification.dart';

class AddAlert extends StatefulWidget {
  const AddAlert({Key? key}) : super(key: key);
  static const routeName = "/AddAlert";

  @override
  State<AddAlert> createState() => _AddAlertState();
}

class _AddAlertState extends State<AddAlert> {
  TextStyle ts = const TextStyle(color: mySecondTextColor, fontSize: 16);
  static const TextStyle txtStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final controller = Get.put(AddAlertController(), permanent: true);
  int? note_id;

  @override
  void initState() {
    super.initState();
    controller.selectedDate = null;
    controller.selectedTime = null;
    print("---------init state run----------${Get.arguments}");
    note_id = Get.arguments.note_id;
    print("---------note_id---------=$note_id");
    MyNotification.init();
    listenNotifications();
  }

  listenNotifications() {
    MyNotification.onNotification.stream.listen(onNotificationClicked);
    // (event) {
    //   print("fffffffffffffffffffffffffffffffffffff---");
    // },
    // onDone: () {
    //   print(
    //       "Hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh---------");
    // },
    // );
  }

  onNotificationClicked(Payload) {
    print("hhhhhhhhhhhh---- $Payload");
  }

  final noteCtrl = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    note_id = Get.arguments.note_id;
    controller.selectedDate;
    return Scaffold(
      appBar: _myAppBar(),
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(height: 20),
          _datePicker(),
          _timePicker(),
          const Spacer(flex: 8),
          _save(),
          const Spacer(flex: 1)
        ],
      )),
    );
  }

  _myAppBar() {
    return AppBar(
      toolbarHeight: 35,
      title: Row(
        children: [
          const Spacer(flex: 4),
          const Icon(
            Icons.alarm,
            size: 30,
            color: mySecondaryColor,
          ),
          const SizedBox(width: 7),
          Text(
            "Alertme".tr,
            style: txtStyle,
          ),
          const Spacer(flex: 6)
        ],
      ),
      leading: InkWell(
        onTap: (() => Get.back()),
        child: Container(
          height: 35,
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          decoration: BoxDecoration(
            borderRadius: Get.locale.toString() == "ar"
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30))
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            color: myPrimaryColor,
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _datePicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StatefulBuilder(
        builder: (datePickerCtx, dateSetState) {
          return Column(
            children: [
              InkWell(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                      currentDate: controller.selectedDate ?? DateTime.now(),
                      context: context,
                      initialDate: controller.selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2050),
                      builder: (context, Widget? child) {
                        return Theme(
                          data: ThemeData.dark(),
                          child: child!,
                        ); //selection color
                      });
                  if (picked != null && controller.selectedDate != picked) {
                    dateSetState(() {
                      controller.selectedDate = picked;
                      controller.noteDate();
                      setState(() {});
                    });
                  }
                },
                child: Row(children: [
                  const Icon(
                    Icons.edit_calendar,
                    color: myPrimaryColor,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      "select date".tr,
                      style: txtStyle,
                    ),
                  )
                ]),
              ),
              if (controller.selectedDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 50),
                  child: Row(children: [
                    Text("${controller.day!} ", style: ts),
                    Text("${controller.month!} ", style: ts),
                    Text(controller.year!, style: ts),
                  ]),
                )
            ],
          );
        },
      ),
    );
  }

  _timePicker() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatefulBuilder(builder: (datePickerCtx, timeSetState) {
          return Column(
            children: [
              InkWell(
                onTap: () async {
                  controller.selectedTime = null;
                  TimeOfDay? picked = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (controller.selectedDate != picked &&
                      picked != null &&
                      picked > TimeOfDay.now()) {
                    timeSetState(() {
                      controller.selectedTime = picked;
                      controller.noteDate();
                      setState(() {});
                    });
                  }
                },
                child: Row(children: [
                  const Icon(
                    Icons.access_time,
                    color: myPrimaryColor,
                    size: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      "select time".tr,
                      style: txtStyle,
                    ),
                  )
                ]),
              ),
              if (controller.selectedTime != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 50),
                  child: Row(children: [
                    Text("${controller.selectedTime!.format(context)} ",
                        style: ts),
                  ]),
                )
            ],
          );
        }));
  }

  _save() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: controller.selectedDate == null ||
                    controller.selectedTime == null
                ? null
                : () async {
                    await controller.saveAlert(note_id!);
                  },
            child: Text("save".tr,
                style: const TextStyle(fontWeight: FontWeight.bold))),
        OutlinedButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: mySecondaryColor)))
      ],
    );
  }
}
