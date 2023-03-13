import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/add_alert_controller.dart';
import 'package:note/controller/departmentDetails_controller.dart';
import 'package:note/controller/department_controller.dart';
import 'package:note/controller/note/note_controller.dart';
import 'package:note/controller/note/recordController.dart';
import 'package:note/controller/sqllite_ctrl.dart';
import 'package:note/models/alert.dart';
import 'package:note/models/note.dart';
import 'package:note/screens/add_alert_screen.dart';
import 'package:note/screens/camera_screen.dart';
import 'package:note/screens/departments_screen.dart';
import 'package:note/screens/hero_view_screen.dart';
import 'package:note/screens/record_screen.dart';
import 'package:note/widgets/audio_widget.dart';
import 'package:undo/undo.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);
  static const routeName = "/AddNote";

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextStyle ts = const TextStyle(color: Colors.black);
  bool emojiOpened = false;
  bool bgShapesOpend = false;
  bool addButton = false;
  var commingNote = Get.arguments ?? "";
  bool loadingSave = false;
  NoteController controller = Get.put(NoteController());
  SqlliteHelper sqlliteCtrl = Get.put(SqlliteHelper());
  DepartmentController departmentCtrl = Get.put(DepartmentController());
  DepartmentDetailsController departmentDetailsCtrl =
      Get.put(DepartmentDetailsController());
  AddAlertController alertCtrl = Get.put(AddAlertController());
  List<IconData> addNoteFooter = [
    Icons.mic,
    Icons.photo_camera,
    // Icons.gesture_outlined,
    Icons.text_increase,
    Icons.text_decrease,
    Icons.format_underline,
    Icons.format_bold,
    Icons.text_format,
  ];
  var changes = ChangeStack();
  late SimpleStack _controller;

  @override
  void initState() {
    _controller = SimpleStack<String>("");
    super.initState();
    emojiOpened = false;
    bgShapesOpend = false;
    addButton = false;
    controller.init(commingNote);
    controller.noteDate();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.swapNote.noteBody.text != _controller.state.toString() &&
        _controller.state != "") {
      controller.swapNote.noteBody.text = _controller.state.toString();
      controller.swapNote.noteBody.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.swapNote.noteBody.text.length));
    }
    return Container(
      decoration: BoxDecoration(
          backgroundBlendMode: BlendMode.lighten,
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: bgcolor[controller.swapNote.bgColor])),
      child: WillPopScope(
        onWillPop: () async => await chechBeforGoBack(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _myAppBar(),
            ),
          ),
          body: GetBuilder<NoteController>(
            builder: (controller) => SafeArea(
                child: Column(children: [
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child:
                          // Stack(
                          //   children: [
                          Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _datePicker(),
                                _emojiButton(),
                              ],
                            ),
                          ),
                          _title(),
                          _body(),
                          if (controller.swapNote.img!.isNotEmpty) _images(),
                          ..._alerts(),
                          ...List.generate(
                              controller.swapNote.audio!.length,
                              (index) => AudioWidget(
                                  url: controller.swapNote.audio![index])),
                        ],
                      ),

                      // Spacer(),

                      //    ],
                      //  ),
                    ),
                    if (emojiOpened) _showEmojins(),
                    if (bgShapesOpend) _showBgShapes(),
                    if (addButton) _addButton(),
                  ],
                ),
              ),
              _footer(context)
            ])),
          ),
        ),
      ),
    );
  }

  chechBeforGoBack() async {
    if (commingNote == "" && Note.isNoteEmpty(controller.swapNote)) {
      return true;
    } else if (commingNote != "" &&
        controller.swapNote.isEquel(commingNote) &&
        controller.newDepartments.isEmpty &&
        controller.deletedDepartments.isEmpty &&
        controller.newRecords.isEmpty &&
        controller.deletedRecords.isEmpty &&
        controller.newAlerts.isEmpty &&
        controller.deletedAlerts.isEmpty) {
      return true;
    } else {
      FocusNode().unfocus();
      FocusManager.instance.primaryFocus?.unfocus();
      var result = await showWarning(context) ?? true;

      return result;
    }
  }

  _myAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: (() async {
              var result = await chechBeforGoBack();
              if (result) Get.back();
            }),
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
          IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                controller.swapNote.isFav = !controller.swapNote.isFav;
                _closeMenu();
              },
              icon: Icon(
                  controller.swapNote.isFav
                      ? Icons.favorite
                      : Icons.favorite_border_rounded,
                  size: 27)),

          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: !_controller.canUndo
                ? null
                : () {
                    if (mounted) {
                      _controller.undo();
                      _closeMenu();
                    }
                  },
            icon: SvgPicture.asset(
              "assets/icon/undo.svg",
              color: _controller.canUndo
                  ? mySecondaryColor
                  : mySecondaryColor.withOpacity(0.3),
              height: 16,
              width: 16,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: !_controller.canRedo
                ? null
                : () {
                    if (mounted) {
                      _controller.redo();
                      _closeMenu();
                    }
                  },
            icon: SvgPicture.asset(
              "assets/icon/redo.svg",
              color: _controller.canRedo
                  ? mySecondaryColor
                  : mySecondaryColor.withOpacity(0.3),
              height: 16,
              width: 16,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              if (bgShapesOpend) {
                _closeMenu();
              } else {
                _closeMenu(currentMenu: Menus.shape);
              }
            },
            icon: SvgPicture.asset(
              "assets/icon/backgroundColor.svg",
              height: 16,
              width: 16,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              if (addButton) {
                _closeMenu();
              } else {
                _closeMenu(currentMenu: Menus.addbtn);
              }
            },
            icon: const Icon(Icons.add, size: 27),
          ),
          //save button
          StatefulBuilder(
            builder: (context, saveSetState) => SizedBox(
              height: 35,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                      backgroundColor:
                          MaterialStateProperty.all(myPrimaryColor)),
                  onPressed: () {
                    saveSetState(() => loadingSave = true);
                    controller.saveNote().then((value) {
                      saveSetState(() => loadingSave = false);
                      departmentDetailsCtrl.update();
                      Get.back();
                    });
                  },
                  child: loadingSave
                      ? const Center(
                          child: SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Text("save".tr)),
            ),
          ),
        ],
      ),
    );
  }

  _title() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Directionality(
        textDirection:
            controller.swapNote.isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: TextField(
            controller: controller.swapNote.noteTitle,
            style: _myTextFieldStyle(),
            onTap: () {
              if (controller.swapNote.noteTitle.selection ==
                  TextSelection.fromPosition(TextPosition(
                      offset: controller.swapNote.noteTitle.text.length - 1))) {
                setState(() {
                  controller.swapNote.noteTitle.selection =
                      TextSelection.fromPosition(TextPosition(
                          offset: controller.swapNote.noteTitle.text.length));
                });
              }
            },
            decoration: InputDecoration(
                hintText: "  ${"title".tr}", hintStyle: _myTextFieldStyle())),
      ),
    );
  }

  _body() {
    return GetBuilder<NoteController>(builder: (controller) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Directionality(
              textDirection: controller.swapNote.isRTL
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: TextFormField(
                controller: controller.swapNote.noteBody,
                onTap: () {
                  if (controller.swapNote.noteBody.selection ==
                      TextSelection.fromPosition(TextPosition(
                          offset:
                              controller.swapNote.noteBody.text.length - 1))) {
                    setState(() {
                      controller.swapNote.noteBody.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset:
                                  controller.swapNote.noteBody.text.length));
                    });
                  }
                },
                onChanged: (value) => setState(() {
                  _controller.modify(controller.swapNote.noteBody.value.text);
                }),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: _myTextFieldStyle(),
                decoration: InputDecoration(
                    hintText: "  ${"write note".tr}",
                    border: InputBorder.none,
                    hintStyle: _myTextFieldStyle()),
              ),
            ),
          ),
        ],
      );
    });
  }

  _myTextFieldStyle() {
    return TextStyle(
      color: Colors.transparent,
      decorationColor: textColors[controller.swapNote.selectedColor],
      shadows: [
        Shadow(
            color: textColors[controller.swapNote.selectedColor],
            offset: const Offset(0, -5))
      ],
      decoration:
          controller.swapNote.isUderline ? TextDecoration.underline : null,
      decorationThickness: 1.5,
      height: 2,
      fontSize: controller.swapNote.fSize,
      fontFamily: controller.swapNote.fFamily,
      fontWeight: controller.swapNote.isBold ? FontWeight.bold : null,
    );
  }

  _datePicker() {
    return StatefulBuilder(
      builder: (datePickerCtx, dateSetState) {
        return ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromRGBO(242, 234, 255, 1))),
            onPressed: () async {
              DateTime? picked = await showDatePicker(
                  currentDate: controller.selectedDate ?? DateTime.now(),
                  context: context,
                  initialDate: controller.selectedDate ?? DateTime.now(),
                  firstDate: DateTime(1990),
                  lastDate: DateTime.now(),
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
                });
                //currentFocus.unfocus();
              }
            },
            child: Row(
              children: [
                Text("${controller.day!} ", style: ts),
                Text("${controller.month!} ", style: ts),
                Text(controller.year!, style: ts),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                )
              ],
            ));
      },
    );
  }

  _emojiButton() {
    return InkWell(
      onTap: () {
        if (emojiOpened) {
          _closeMenu();
        } else {
          _closeMenu(currentMenu: Menus.emoji);
        }
      },
      child: controller.swapNote.emoji == null
          ? Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Image.asset(
                "assets/icon/emoji.png",
                width: 35,
                height: 35,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                emoji[controller.swapNote.emoji!],
                style: const TextStyle(fontSize: 28),
              ),
            ),
    );
  }

  _footer(context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
          color: myPrimaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      width: double.infinity,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...List.generate(
              addNoteFooter.length,
              (index) => GetBuilder<NoteController>(
                    builder: (controller) => InkWell(
                      onTap: () async {
                        switch (index) {
                          case 0:
                            Get.toNamed(RecordScreen.routeName);
                            break;
                          case 1:
                            Get.toNamed(CameraScreen.routeName);
                            break;
                          case 2:
                            controller.swapNote.fSize++;
                            controller.update();
                            break;
                          case 3:
                            controller.swapNote.fSize--;
                            controller.update();
                            break;
                          case 4:
                            controller.swapNote.isUderline =
                                !controller.swapNote.isUderline;
                            controller.update();
                            break;
                          case 5:
                            controller.swapNote.isBold =
                                !controller.swapNote.isBold;
                            controller.update();
                            break;
                          case 6:
                            _showLetterA();
                            controller.letterA = !controller.letterA;
                            controller.update();
                            break;
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(addNoteFooter[index],
                              color: Colors.white, size: 25),
                          if ((index == 4 && controller.swapNote.isUderline) ||
                              (index == 5 && controller.swapNote.isBold))
                            const Icon(
                                weight: 100,
                                Icons.maximize,
                                color: mySecondaryColor,
                                size: 25)
                        ],
                      ),
                    ),
                  ))
        ],
      ),
    );
  }

  _showLetterA() async {
    return await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        builder: (context) => Container(
            height: 300.0,
            color: Colors.transparent,
            child: StatefulBuilder(
              builder: (context, childSetState) => Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))),
                  child: Column(children: [
                    Stack(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text("font property".tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)))),
                        Positioned(
                            child: IconButton(
                                onPressed: () => Get.back(),
                                icon:
                                    const Icon(Icons.close, color: Colors.red)))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 250,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(5, (index) {
                              if (index == 0) {
                                return InkWell(
                                    onTap: () => childSetState(() {
                                          controller.swapNote.isRTL = true;
                                          controller.update();
                                        }),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.format_align_right,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                        if (controller.swapNote.isRTL)
                                          const Icon(Icons.maximize,
                                              color: mySecondaryColor, size: 25)
                                      ],
                                    ));
                              }
                              if (index == 1) {
                                return InkWell(
                                    onTap: () => childSetState(() {
                                          controller.swapNote.isRTL = false;
                                          controller.update();
                                        }),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.format_align_left,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                        if (!controller.swapNote.isRTL)
                                          const Icon(Icons.maximize,
                                              color: mySecondaryColor, size: 25)
                                      ],
                                    ));
                              } else {
                                return InkWell(
                                    onTap: () {
                                      childSetState(() {
                                        if (index == 2) {
                                          controller.swapNote.fSize = 22;
                                        } else if (index == 3) {
                                          controller.swapNote.fSize = 26;
                                        } else {
                                          controller.swapNote.fSize = 32;
                                        }
                                        controller.update();
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          "H${5 - index}",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        if ((controller.swapNote.fSize == 22 &&
                                                index == 2) ||
                                            (controller.swapNote.fSize == 26 &&
                                                index == 3) ||
                                            (controller.swapNote.fSize == 32 &&
                                                index == 4))
                                          const Icon(Icons.maximize,
                                              color: mySecondaryColor, size: 25)
                                      ],
                                    ));
                              }
                            }),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: textColors.length,
                          itemBuilder: (context, index) => InkWell(
                                onTap: () => childSetState(() {
                                  controller.swapNote.selectedColor = index;
                                  controller.update();
                                }),
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  decoration:
                                      controller.swapNote.selectedColor == index
                                          ? BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: mySecondaryColor))
                                          : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: textColors[index]),
                                    margin: const EdgeInsets.all(2),
                                  ),
                                ),
                              )),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 350,
                      height: 150,
                      child: GridView.count(crossAxisCount: 3, children: [
                        ...List.generate(
                            controller.allFonts.length,
                            (index) => InkWell(
                                  child: Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    margin: const EdgeInsets.all(10),
                                    child: Center(
                                        child: Text(
                                      controller.allFonts[index],
                                      style: TextStyle(
                                          textBaseline:
                                              TextBaseline.ideographic,
                                          decoration: (controller
                                                      .swapNote.fFamily ==
                                                  controller.allFonts[index])
                                              ? TextDecoration.underline
                                              : null,
                                          decorationColor: mySecondaryColor,
                                          decorationThickness: 2,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                  onTap: () {
                                    controller.swapNote.fFamily =
                                        controller.allFonts[index];
                                    controller.update();
                                    childSetState(() {});
                                  },
                                ))
                      ]),
                    )
                  ])),
            )));
  }

  _showEmojins() {
    return Positioned(
        top: 40,
        left: Get.locale.toString() == "ar" ? 10 : null,
        right: Get.locale.toString() == "en" ? 10 : null,
        child: Container(
          //   clipBehavior: Clip.antiAliasWithSaveLayer,
          width: 210,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
            border: Border.all(color: mySecondaryColor),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "how was your day ??".tr,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 110,
                width: 250,
                child: GridView.count(crossAxisCount: 7, children: [
                  ...List.generate(
                      emoji.length,
                      (index) => GestureDetector(
                            onTap: () {
                              controller.swapNote.emoji = index;
                              _closeMenu();
                            },
                            child: Text(
                              emoji[index],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ))
                ]),
              ),
            ],
          ),
        ));
  }

  _showBgShapes() {
    return Positioned(
        top: 0,
        left: 120,
        child: SizedBox(
          width: 240,
          height: 160,
          child: Stack(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  border: Border.all(color: mySecondaryColor),
                  color: Colors.white,
                ),
                child: Text(
                  "chooseBG".tr,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                top: 39,
                child: Container(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  height: 120,
                  width: 240,
                  color: greyBackgroundColor,
                  child: GridView.count(
                      crossAxisCount: 6,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 0.7,
                      children: [
                        ...List.generate(
                            bgcolor.length,
                            (index) => SizedBox(
                                  height: 100,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        controller.swapNote.bgColor = index;
                                        bgShapesOpend = false;
                                      });
                                    },
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: bgcolor[index])),
                                    ),
                                  ),
                                ))
                      ]),
                ),
              ),
            ],
          ),
        ));
  }

  _addButton() {
    return Positioned(
        top: 0,
        left: Get.locale.toString() == "ar" ? 60 : null,
        right: Get.locale.toString() == "en" ? 60 : null,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: mySecondaryColor)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
                onTap: commingNote == ""
                    ? null
                    : () {
                        setState(() {
                          addButton = false;
                          Get.toNamed(AddAlert.routeName,
                              arguments: commingNote);
                        });
                      },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 3),
                      child: SvgPicture.asset("assets/icon/alert.svg"),
                    ),
                    Text(
                      "alertMe".tr,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: commingNote == ""
                              ? myTextFieldBorderColor
                              : Colors.black),
                    )
                  ],
                )),
            const SizedBox(height: 5),
            InkWell(
                onTap: () {
                  setState(() {
                    addButton = false;
                    Get.toNamed(DepartmentsScreen.routeName,
                        arguments: ["addNote", true, controller.swapNote]);
                  });
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.save_outlined,
                      color: mySecondaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      "saveInDepartment".tr,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    )
                  ],
                ))
          ]),
        ));
  }

  _alerts() {
    return List.generate(
        controller.swapNote.alerts!.length,
        (index) => Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: myTextFieldBackgroundColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      // alertCtrl
                      // .removeAlert(controller.swapNote.alerts![index].id);
                      controller.deletedAlerts
                          .add(controller.swapNote.alerts![index]);
                      controller.swapNote.alerts!.removeWhere((element) =>
                          element.id == controller.swapNote.alerts![index].id);
                    }),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  ),
                  Text(controller.swapNote.alerts![index].date
                      .toString()
                      .toString()),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 3),
                    child: SvgPicture.asset(
                      "assets/icon/alert.svg",
                    ),
                  ),
                ],
              ),
            ));
  }

  _images() {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: GridView.builder(
          itemCount: controller.swapNote.img!.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) => Stack(
                children: [
                  InkWell(
                    onTap: () => Get.toNamed(HeroViewScreen.routeName,
                        arguments: File(controller.swapNote.img![index])),
                    child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          image: DecorationImage(
                              image: Image.file(
                                      File(controller.swapNote.img![index]))
                                  .image,
                              fit: BoxFit.fill),
                        )),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () => setState(() {
                          controller.deletedImags
                              .add(controller.swapNote.img![index]);
                          controller.swapNote.img!.removeAt(index);
                        }),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      ))
                ],
              )),
    );
  }

  _closeMenu({Menus? currentMenu}) {
    if (currentMenu == null) {
      emojiOpened = false;
      bgShapesOpend = false;
      addButton = false;
    } else if (currentMenu == Menus.addbtn) {
      addButton = true;
      emojiOpened = false;
      bgShapesOpend = false;
    } else if (currentMenu == Menus.emoji) {
      emojiOpened = true;
      bgShapesOpend = false;
      addButton = false;
    } else {
      bgShapesOpend = true;
      emojiOpened = false;
      addButton = false;
    }
    setState(() {});
  }

  Future<bool?> showWarning(context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Discard changes?".tr),
          content: Text("go back without save".tr),
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
                  Note.clearData(controller.swapNote);
                  for (String url in controller.newRecords) {
                    RecordController.deleteRecordFromStorge(url);
                  }
                  for (Alert alert in controller.newAlerts) {
                    alertCtrl.removeAlertFromStorage(alert.id);
                    AddAlertController.cancelAlert(alert.id);
                  }
                  Get.back(result: true);
                },
                child: Text("ignore".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(myPrimaryColor)),
                onPressed: () => controller.saveNote().then((value) {
                      Get.back();
                    }),
                child: Text("save".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        );
      },
    );
  }
}
