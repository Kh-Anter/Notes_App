import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';

Future<bool?> showDeleteWarning(context, String title, String body) async {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title.tr),
          content: Text(body.tr),
          actions: <Widget>[
            OutlinedButton(
                style: ButtonStyle(
                    side: MaterialStateProperty.all(
                        const BorderSide(color: myPrimaryColor)),
                    foregroundColor: MaterialStateProperty.all(myPrimaryColor)),
                onPressed: () {
                  Get.back(result: false);
                },
                child: Text(
                  "cancel".tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(myPrimaryColor)),
                onPressed: () {
                  Get.back(result: true);
                },
                child: Text("delete".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        );
      });
}
