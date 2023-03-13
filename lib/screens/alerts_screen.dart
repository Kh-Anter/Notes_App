import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/add_alert_controller.dart';
import 'package:note/widgets/home_widgets/notes_shape/thirdShap.dart';

class AlertsScreen extends StatelessWidget {
  AlertsScreen({Key? key}) : super(key: key);
  static const routeName = "/Alerts";
  final alertCtrl = Get.put(AddAlertController());
  @override
  Widget build(BuildContext context) {
    alertCtrl.initAllAlerts();
    return Scaffold(
      appBar: _myAppBar(),
      body: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            ThirdShap(ParentWidget.alerts),
          ],
        )),
      ),
    );
  }

  _myAppBar() {
    return AppBar(
      toolbarHeight: 35,
      title: Text("Alerts".tr),
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
}
