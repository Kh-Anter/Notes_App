import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note/constants.dart';
import 'package:note/controller/note/note_controller.dart';
import 'package:note/models/pick_image.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);
  static const routeName = "/camera_screen";

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final noteCtrl = Get.put(NoteController());
  var theImage;

  @override
  Widget build(BuildContext context) {
    print(theImage != null ? theImage.path : "");
    return Scaffold(
        appBar: _myAppBar(),
        body: SafeArea(
            child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: theImage == null
                    ? const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: mySecondTextColor,
                        size: 200,
                      )
                    : Image.file(theImage)),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            backgroundColor:
                                MaterialStateProperty.all(myPrimaryColor)),
                        onPressed: () async {
                          var result =
                              await PickImage.pickImage(ImageSource.gallery);
                          if (result != null) {
                            setState(() {
                              theImage = result;
                            });
                          }
                        },
                        child: Text("Pick gallery".tr)),
                  ),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            backgroundColor:
                                MaterialStateProperty.all(myPrimaryColor)),
                        onPressed: () async {
                          var result =
                              await PickImage.pickImage(ImageSource.camera);
                          if (result != null) {
                            setState(() {
                              theImage = result;
                            });
                          }
                        },
                        child: Text("Pick camera".tr)),
                  )
                ],
              ),
            )
          ],
        )));
  }

  _myAppBar() {
    return AppBar(
      toolbarHeight: 35,
      title: Text("Pick image".tr),
      leading: InkWell(
        onTap: (() => Get.back()),
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
        ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                backgroundColor: MaterialStateProperty.all(myPrimaryColor)),
            onPressed: theImage != null
                ? () {
                    Get.back();
                    noteCtrl.swapNote.img!.add(theImage.path.toString());
                    noteCtrl.newImags.add(theImage.path.toString());
                    noteCtrl.update();
                  }
                : null,
            child: Text("save".tr))
      ],
    );
  }
}
