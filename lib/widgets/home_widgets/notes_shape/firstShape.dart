import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/home_controller.dart';
import 'package:note/controller/settings_controller.dart';
import 'package:note/screens/add_note_screen.dart';
import 'package:note/widgets/home_widgets/notes_shape/delete_dialoge.dart';
import 'package:share_plus/share_plus.dart';

class FirstShape extends StatelessWidget {
  FirstShape({Key? key}) : super(key: key);
  final HomeController controller = Get.put(HomeController());
  final SettingController settingCtrl = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(children: [
        theBody(),
        if (controller.allNotes.isEmpty)
          Column(
            children: [
              const Spacer(),
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Addyourfirstnote".tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 50)
            ],
          ),
      ]),
    );
  }

  Widget theBody() {
    return Obx(() {
      bool isNotesInASCOrder = settingCtrl.isNotesInASCOrder.value;
      bool isSearchList = controller.searchCtr.value.text.trim() != "";
      return ListView.builder(
        itemCount: isSearchList
            ? controller.searchResult.length
            : controller.allNotes.length,
        itemBuilder: (context, index) {
          return Container(
              height: 155,
              width: double.infinity,
              color: Colors.transparent,
              child: ClipPath(
                clipper: _ResultOfTriangle(),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  color: noteCardBGColor,
                  child: InkWell(
                    onTap: () => Get.toNamed(AddNoteScreen.routeName,
                        arguments: controller.allNotes[isNotesInASCOrder
                            ? index
                            : (controller.allNotes.length - (index + 1))]),
                    child: ListTile(
                      dense: true,
                      minVerticalPadding: 0,
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: 0),
                      contentPadding: const EdgeInsets.only(left: 0),
                      title: Padding(
                        padding: EdgeInsets.only(
                            //bottom: 4,
                            right: Get.locale.toString() == "ar" ? 12 : 0,
                            left: Get.locale.toString() == "en" ? 12 : 0),
                        child: Stack(children: [
                          Positioned(
                            top: 0,
                            left: Get.locale.toString() == "ar" ? 0 : null,
                            right: Get.locale.toString() == "en" ? -0 : null,
                            child: Container(
                              width: 60,
                              height: 60,
                              color: myPrimaryColor,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: myPrimaryColor,
                                                  width: 6.0))),
                                      child: Text(
                                        getDateNumber(isSearchList,
                                            isNotesInASCOrder, index),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          decorationColor: myPrimaryColor,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      getDateWithMonth(isSearchList,
                                          isNotesInASCOrder, index),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 70.0),
                                      child: Text(
                                          getImoji(isSearchList,
                                              isNotesInASCOrder, index),
                                          style: const TextStyle(fontSize: 20)),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: Get.locale.toString() == "ar"
                                          ? 75
                                          : 0,
                                      right: Get.locale.toString() == "en"
                                          ? 75
                                          : 0),
                                  child: Text(
                                    getTitle(
                                        isSearchList, isNotesInASCOrder, index),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: Get.locale.toString() == "ar"
                                          ? 75
                                          : 0,
                                      right: Get.locale.toString() == "en"
                                          ? 75
                                          : 0),
                                  child: Text(
                                    getBody(
                                        isSearchList, isNotesInASCOrder, index),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 12, color: mySecondTextColor),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () async {
                                        var result = await showDeleteWarning(
                                            context,
                                            "deleteNote",
                                            "are You Sure you want to delete note");
                                        result!
                                            ? deleteAction(isSearchList,
                                                isNotesInASCOrder, index)
                                            : null;
                                      },
                                      icon: const Icon(Icons.delete, size: 20)),
                                  IconButton(
                                      onPressed: () => shareBtnAction(
                                          isSearchList,
                                          isNotesInASCOrder,
                                          index),
                                      icon: const Icon(Icons.share, size: 20)),
                                ],
                              )
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ));
        },
      );
    });
  }

  getDateWithMonth(bool isSearchList, bool isNotesInASCOrder, int index) {
    if (isSearchList) {
      return Get.locale.toString() == 'en'
          ? "   ${EngMONTHS[controller.searchResult[isNotesInASCOrder ? index : (controller.searchResult.length - (index + 1))].date!.month - 1]}"
          : "   ${ArMONTHS[controller.searchResult[isNotesInASCOrder ? index : (controller.searchResult.length - (index + 1))].date!.month - 1]}";
    } else {
      return Get.locale.toString() == 'en'
          ? "   ${EngMONTHS[controller.allNotes[isNotesInASCOrder ? index : (controller.allNotes.length - (index + 1))].date!.month - 1]}"
          : "   ${ArMONTHS[controller.allNotes[isNotesInASCOrder ? index : (controller.allNotes.length - (index + 1))].date!.month - 1]}";
    }
  }

  getDateNumber(bool isSearchList, bool isNotesInASCOrder, int index) {
    return getCurrentNote(isSearchList, isNotesInASCOrder, index)
        .date!
        .day
        .toString();
  }

  getImoji(bool isSearchList, bool isNotesInASCOrder, int index) {
    var emojiIndex =
        getCurrentNote(isSearchList, isNotesInASCOrder, index).emoji;
    return emojiIndex == null ? "" : emoji[emojiIndex];
  }

  getTitle(bool isSearchList, bool isNotesInASCOrder, int index) {
    return getCurrentNote(isSearchList, isNotesInASCOrder, index)
        .noteTitle
        .text!;
  }

  getBody(bool isSearchList, bool isNotesInASCOrder, int index) {
    return getCurrentNote(isSearchList, isNotesInASCOrder, index)
        .noteBody
        .text!;
  }

  getCurrentNote(bool isSearchList, bool isNotesInASCOrder, int index) {
    if (isSearchList) {
      return controller.searchResult[isNotesInASCOrder
          ? index
          : (controller.searchResult.length - (index + 1))];
    } else {
      return controller.allNotes[isNotesInASCOrder
          ? index
          : (controller.allNotes.length - (index + 1))];
    }
  }

  List<String> getAttachments(
      bool isSearchList, bool isNotesInASCOrder, int index) {
    var currentNote = getCurrentNote(isSearchList, isNotesInASCOrder, index);
    return [...currentNote.audio, ...currentNote.img];
  }

  shareBtnAction(bool isSearchList, bool isNotesInASCOrder, int index) {
    List<String> attachments =
        getAttachments(isSearchList, isNotesInASCOrder, index);
    String title = getTitle(isSearchList, isNotesInASCOrder, index);
    String body = getBody(isSearchList, isNotesInASCOrder, index);
    if (attachments.isEmpty) {
      if (title == "" && body == "") {
        return;
      } else if (title != "" && body != "") {
        Share.share("$title \n $body");
      } else if (title == "" && body != "") {
        Share.share(body);
      } else if (title != "" && body == "") {
        Share.share(title);
      }
    } else if (attachments.isNotEmpty) {
      if (title == "" && body == "") {
        Share.shareFiles(attachments);
      } else if (title != "" && body != "") {
        Share.shareFiles(attachments, text: "$title \n $body");
      } else if (title == "" && body != "") {
        Share.shareFiles(attachments, text: body);
      } else if (title != "" && body == "") {
        Share.shareFiles(attachments, text: title);
      }
    }
  }

  deleteAction(bool isSearchList, bool isNotesInASCOrder, int index) {
    if (isSearchList) {
      controller.deleteNote(
          controller.searchResult[isNotesInASCOrder
              ? index
              : (controller.searchResult.length - (index + 1))],
          isSearch: true);
    } else {
      controller.deleteNote(controller.allNotes[isNotesInASCOrder
          ? index
          : (controller.allNotes.length - (index + 1))]);
    }
  }
}

class _ResultOfTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo((size.width - (size.width - 80)), 0);
    path.lineTo(0, (size.height - (size.height - 80)));
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    final path2 = Path();
    path2.lineTo(0, 0);
    path2.lineTo(size.width - 80, 0);
    path2.lineTo(size.width, 80);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.lineTo(0, 0);
    path2.close();
    return Get.locale.toString() == "ar" ? path : path2;
  }

  @override
  bool shouldReclip(covariant Object oldClipper) {
    // TODO: implement shouldReclip
    // throw UnimplementedError();
    return false;
  }
}
