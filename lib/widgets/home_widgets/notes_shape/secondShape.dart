import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/home_controller.dart';
import 'package:note/controller/settings_controller.dart';
import 'package:note/screens/add_note_screen.dart';
import 'package:note/widgets/home_widgets/notes_shape/delete_dialoge.dart';
import 'package:share_plus/share_plus.dart';

class SecondShap extends StatelessWidget {
  SecondShap({Key? key}) : super(key: key);
  final HomeController homeCtrl = Get.put(HomeController());
  final SettingController settingCtrl = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(
          () {
            bool isSearchList = homeCtrl.searchCtr.value.text.trim() != "";
            bool isNotesInASCOrder = settingCtrl.isNotesInASCOrder.value;
            return GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 0.5,
                crossAxisSpacing: 0.5,
                childAspectRatio: 1 / 0.75,
                children: List.generate(
                  isSearchList
                      ? homeCtrl.searchResult.length
                      : homeCtrl.allNotes.length,
                  (index) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      color: Colors.transparent,
                      child: ClipPath(
                        clipper: _ResultOfTriangle(),
                        child: Container(
                          height: 100,
                          color: noteCardBGColor,
                          child: InkWell(
                            onTap: () => Get.toNamed(AddNoteScreen.routeName,
                                arguments: isSearchList
                                    ? homeCtrl.searchResult[isNotesInASCOrder
                                        ? index
                                        : (homeCtrl.searchResult.length -
                                            (index + 1))]
                                    : homeCtrl.allNotes[isNotesInASCOrder
                                        ? index
                                        : (homeCtrl.allNotes.length -
                                            (index + 1))]),
                            child: ListTile(
                              dense: true,
                              minVerticalPadding: 0,
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: 0),
                              contentPadding: const EdgeInsets.only(left: 0),
                              title: Padding(
                                padding: EdgeInsets.only(
                                    bottom: 4,
                                    right:
                                        Get.locale.toString() == "ar" ? 12 : 0,
                                    left:
                                        Get.locale.toString() == "en" ? 12 : 0),
                                child: Stack(
                                  children: [
                                    Positioned(
                                        top: 0,
                                        left: Get.locale.toString() == "ar"
                                            ? 0
                                            : null,
                                        right: Get.locale.toString() == "en"
                                            ? 0
                                            : null,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              color: myPrimaryColor,
                                            ),
                                          ],
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 8, bottom: 0),
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                myPrimaryColor,
                                                            width: 6.0))),
                                                child: Text(
                                                  getDateNumber(isSearchList,
                                                      isNotesInASCOrder, index),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    decorationColor:
                                                        myPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                getDateWithMonth(isSearchList,
                                                    isNotesInASCOrder, index),
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  getTitle(isSearchList,
                                                      isNotesInASCOrder, index),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(width: 40)
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  getBody(isSearchList,
                                                      isNotesInASCOrder, index),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: mySecondTextColor),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 40,
                                                height: 30,
                                                child: Text(
                                                    getImoji(
                                                        isSearchList,
                                                        isNotesInASCOrder,
                                                        index),
                                                    style: const TextStyle(
                                                        fontSize: 20)),
                                              ),
                                              const SizedBox(),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Spacer(),
                                              InkWell(
                                                  onTap: () async {
                                                    var result =
                                                        await showDeleteWarning(
                                                            context,
                                                            "deleteNote",
                                                            "are You Sure you want to delete note");
                                                    result!
                                                        ? deleteAction(
                                                            isSearchList,
                                                            isNotesInASCOrder,
                                                            index)
                                                        : null;
                                                  },
                                                  child: const Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                    color: noteCardIconsColor,
                                                  )),
                                              const SizedBox(width: 5),
                                              InkWell(
                                                  onTap: () => shareBtnAction(
                                                      isSearchList,
                                                      isNotesInASCOrder,
                                                      index),
                                                  child: const Icon(
                                                    Icons.share,
                                                    size: 20,
                                                    color: noteCardIconsColor,
                                                  )),
                                              const SizedBox(
                                                width: 5,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ));
          },
        ),
      ),
      if (homeCtrl.allNotes.isEmpty)
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
    ]));
  }

  getDateWithMonth(bool isSearchList, bool isNotesInASCOrder, int index) {
    if (isSearchList) {
      return Get.locale.toString() == 'en'
          ? "   ${EngMONTHS[homeCtrl.searchResult[isNotesInASCOrder ? index : (homeCtrl.searchResult.length - (index + 1))].date!.month - 1]}"
          : "   ${ArMONTHS[homeCtrl.searchResult[isNotesInASCOrder ? index : (homeCtrl.searchResult.length - (index + 1))].date!.month - 1]}";
    } else {
      return Get.locale.toString() == 'en'
          ? "   ${EngMONTHS[homeCtrl.allNotes[isNotesInASCOrder ? index : (homeCtrl.allNotes.length - (index + 1))].date!.month - 1]}"
          : "   ${ArMONTHS[homeCtrl.allNotes[isNotesInASCOrder ? index : (homeCtrl.allNotes.length - (index + 1))].date!.month - 1]}";
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
    return emojiIndex == null ? "        " : emoji[emojiIndex];
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
      return homeCtrl.searchResult[isNotesInASCOrder
          ? index
          : (homeCtrl.searchResult.length - (index + 1))];
    } else {
      return homeCtrl.allNotes[
          isNotesInASCOrder ? index : (homeCtrl.allNotes.length - (index + 1))];
    }
  }

  deleteAction(bool isSearchList, bool isNotesInASCOrder, int index) {
    if (isSearchList) {
      homeCtrl.deleteNote(
          homeCtrl.searchResult[isNotesInASCOrder
              ? index
              : (homeCtrl.searchResult.length - (index + 1))],
          isSearch: true);
    } else {
      homeCtrl.deleteNote(homeCtrl.allNotes[isNotesInASCOrder
          ? index
          : (homeCtrl.allNotes.length - (index + 1))]);
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
}

class _ResultOfTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo((size.width - (size.width - 40)), 0);
    path.lineTo(0, (size.height - (size.height - 40)));
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    final path2 = Path();
    path2.lineTo(0, 0);
    path2.lineTo(size.width - 40, 0);
    path2.lineTo(size.width, 40);
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
