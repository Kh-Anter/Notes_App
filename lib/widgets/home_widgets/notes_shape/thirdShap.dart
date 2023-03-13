import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/add_alert_controller.dart';
import 'package:note/controller/departmentDetails_controller.dart';
import 'package:note/controller/favorite_controller.dart';
import 'package:note/controller/home_controller.dart';
import 'package:note/controller/settings_controller.dart';
import 'package:note/screens/add_note_screen.dart';
import 'package:note/widgets/home_widgets/notes_shape/delete_dialoge.dart';
import 'package:share_plus/share_plus.dart';

class ThirdShap extends StatelessWidget {
  ParentWidget parentName;
  int? depId;
  ThirdShap(this.parentName, {Key? key, this.depId}) : super(key: key);
  SettingController settingCtrl = Get.put(SettingController());
  var controller;

  @override
  Widget build(BuildContext context) {
    if (parentName == ParentWidget.addNote ||
        parentName == ParentWidget.fourthShape) {
      controller = Get.put(HomeController());
    } else if (parentName == ParentWidget.departmentDetails) {
      controller = Get.put(DepartmentDetailsController());
    } else if (parentName == ParentWidget.fav) {
      controller = Get.put(FavoriteController());
    } else if (parentName == ParentWidget.alerts) {
      controller = Get.put(AddAlertController());
    }

    return Expanded(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: theBody(controller),
          ),
          if (controller.allNotes.isEmpty &&
              (parentName == ParentWidget.addNote ||
                  parentName == ParentWidget.fourthShape))
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
        ],
      ),
    );
  }

  theBody(controller) {
    bool isSearchList = controller is HomeController
        ? controller.searchCtr.value.text.trim() != "" &&
            (parentName == ParentWidget.addNote ||
                parentName == ParentWidget.fourthShape)
        : false;
    return Obx(() {
      bool isNotesInASCOrder = settingCtrl.isNotesInASCOrder.value;
      return ListView.builder(
        // shrinkWrap: parentName == ParentWidget.fourthShape ? true : false,
        // physics: parentName == ParentWidget.fourthShape
        //     ? const NeverScrollableScrollPhysics()
        //     : null,
        itemCount: isSearchList
            ? controller.searchResult.length
            : controller.allNotes.length,
        itemBuilder: (context, index) {
          return Container(
              height: 100,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: noteCardBGColor,
                  borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                onTap: () {
                  isSearchList
                      ? Get.toNamed(AddNoteScreen.routeName,
                          arguments: controller.searchResult[isNotesInASCOrder
                              ? index
                              : (controller.searchResult.length - (index + 1))])
                      : Get.toNamed(AddNoteScreen.routeName,
                          arguments: controller.allNotes[isNotesInASCOrder
                              ? index
                              : (controller.allNotes.length - (index + 1))]);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 5,
                                backgroundColor: myPrimaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                getDateNumber(
                                    isSearchList, isNotesInASCOrder, index),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decorationColor: myPrimaryColor,
                                ),
                              ),
                              Text(
                                getDateWithMonth(
                                    isSearchList, isNotesInASCOrder, index),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            getTitle(isSearchList, isNotesInASCOrder, index),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            getBody(isSearchList, isNotesInASCOrder, index),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, color: mySecondTextColor),
                          ),
                        ],
                      ),
                    ),
                    //   Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (parentName == ParentWidget.fav)
                                InkWell(
                                  onTap: () {
                                    controller.allNotes[index].isFav = false;
                                    controller.deleteNoteFromFav(
                                        controller.allNotes[index]);
                                  },
                                  child: Icon(
                                    controller.allNotes[index]!.isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border_rounded,
                                    //  size: 27,
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                    getImoji(
                                        isSearchList, isNotesInASCOrder, index),
                                    style: const TextStyle(fontSize: 20)),
                              ),
                            ]),
                        Row(
                          children: [
                            if (parentName != ParentWidget.fav)
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
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.grey,
                                  )),
                            IconButton(
                                onPressed: () => shareBtnAction(
                                    isSearchList, isNotesInASCOrder, index),
                                icon: const Icon(
                                  Icons.share,
                                  size: 20,
                                  color: Colors.grey,
                                )),
                          ],
                        )
                      ],
                    )
                  ],
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

  List<String> getAttachments(
      bool isSearchList, bool isNotesInASCOrder, int index) {
    var currentNote = getCurrentNote(isSearchList, isNotesInASCOrder, index);
    return [...currentNote.audio, ...currentNote.img];
  }

  deleteAction(bool isSearchList, bool isNotesInASCOrder, int index) {
    if (isSearchList) {
      controller.deleteNote(
          controller.searchResult[isNotesInASCOrder
              ? index
              : (controller.searchResult.length - (index + 1))],
          isSearch: true);
    } else {
      if (controller is DepartmentDetailsController) {
        controller.deleteNote(
            controller.allNotes[isNotesInASCOrder
                ? index
                : (controller.allNotes.length - (index + 1))],
            depId);
      } else {
        controller.deleteNote(controller.allNotes[isNotesInASCOrder
            ? index
            : (controller.allNotes.length - (index + 1))]);
      }
    }
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
