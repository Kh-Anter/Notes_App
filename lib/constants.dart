import 'package:flutter/material.dart';

const myPrimaryColor = Color.fromRGBO(255, 207, 84, 1);
const mySecondaryColor = Color.fromRGBO(0, 191, 166, 1);
const myPrimaryLightColor = Color.fromRGBO(227, 52, 52, 0.10);

const mySecondTextColor = Color.fromRGBO(0, 0, 0, 0.30);
const myTextFieldBorderColor = Color.fromRGBO(185, 185, 185, 1);
const myTextFieldBackgroundColor = Color.fromRGBO(232, 232, 232, 1);
const elevatedBtnColor = Color.fromRGBO(208, 208, 208, 1);

const unselectedNavigationBar = Color.fromRGBO(0, 0, 0, 0.20);

const switchBorder = Color.fromRGBO(205, 212, 217, 1);

const greyBackgroundColor = Color.fromRGBO(255, 78, 81, 0.298);
const dartBackgroundColor = Color.fromRGBO(255, 78, 81, 0.298);
const recordTime = Color.fromRGBO(203, 201, 217, 1);

const searchBGColor = Color.fromRGBO(243, 243, 243, 0.8);

// department card colors
const depCardBtnColor = Color.fromRGBO(249, 178, 72, 1);
const depCardBorderColor = Color.fromRGBO(112, 112, 112, 1);

// note card colors
const noteCardBGColor = Color.fromRGBO(243, 243, 243, 0.8);
const noteCardSubTitleColor = Color.fromRGBO(181, 181, 181, 0.7);
const noteCardIconsColor = Color.fromRGBO(115, 220, 206, 0.7);

// keyboard btn color
const keyboardBtb = Color.fromRGBO(240, 240, 240, 1);

// durations
const myAnimationDuration = Duration(milliseconds: 400);
const mySwitchDuration = Duration(milliseconds: 200);

var departmentCardColors = const [
  [Color.fromRGBO(247, 107, 28, 1), Color.fromRGBO(250, 217, 97, 1)],
  [Color.fromRGBO(30, 123, 120, 1), Color.fromRGBO(108, 212, 223, 1)]
];

enum HomeShape { firstShape, secondShape, thirdShape, fourthShape }

enum AppShape { firstShape, secondShape, thirdShape, fourthShape }

enum ParentWidget { addNote, fourthShape, departmentDetails, fav, alerts }

enum Menus { emoji, addbtn, shape }

var EngMONTHS = const [
  " Jan ",
  " Feb ",
  " Apr ",
  " May ",
  " Mar ",
  " Jun ",
  " Jul ",
  " Aug ",
  " Sep ",
  " Oct ",
  " Nov ",
  " Dec "
];
var ArMONTHS = [
  " يناير ",
  " فبراير ",
  " مارس ",
  " ابريل ",
  " مايو ",
  " يونيو ",
  " يوليو ",
  " اغسطس ",
  " سبتمبر ",
  " اكتوبر ",
  " نوفمبر ",
  " ديسمبر "
];

List emoji = [
  "😀",
  "😃",
  "😄",
  "😁",
  "😆",
  "😅",
  "😂",
  "🤣",
  "😔",
  "😊",
  "😇",
  "🙂",
  "🙃",
  "😉",
  "😌",
  "😍",
  "🥰",
  "😘",
  "😗",
  "😙",
  "😚",
  "😋",
  "😛",
  "😝",
  "😜",
  "🤪",
  "🤨",
  "❤️"
];

enum RecordStatus {
  start,
  pause,
  record,
}

List<Color> textColors = const [
  Color.fromRGBO(1, 1, 1, 1),
  Color.fromRGBO(48, 35, 174, 1),
  Color.fromRGBO(245, 81, 95, 1),
  Color.fromRGBO(180, 235, 81, 1),
  Color.fromRGBO(200, 109, 215, 1),
  Color.fromRGBO(174, 35, 105, 1),
  Color.fromRGBO(52, 63, 63, 1),
  Color.fromRGBO(124, 149, 252, 1),
  Color.fromRGBO(250, 217, 97, 1),
  Color.fromRGBO(93, 63, 208, 1),
  Color.fromRGBO(159, 4, 27, 1),
];

List<List<Color>> bgcolor = const [
  [Colors.white, Colors.white],
  [
    Color.fromRGBO(254, 233, 180, 1),
    Color.fromRGBO(255, 66, 141, 1),
  ],
  [
    Color.fromRGBO(255, 215, 70, 1),
    Color.fromRGBO(255, 152, 76, 1),
  ],
  [
    Color.fromRGBO(239, 239, 169, 1),
    Color.fromRGBO(135, 182, 156, 1),
  ],
  [
    Color.fromRGBO(88, 160, 255, 0.6),
    Color.fromRGBO(89, 103, 255, 0.469),
  ],
  [
    Color.fromRGBO(198, 198, 198, 1),
    Color.fromRGBO(158, 158, 158, 1),
  ],
  [
    Color.fromRGBO(45, 228, 191, 1),
    Color.fromRGBO(51, 151, 144, 1),
  ],
  [
    Color.fromRGBO(246, 44, 132, 1),
    Color.fromRGBO(224, 47, 156, 1),
    Color.fromRGBO(171, 56, 217, 1),
    Color.fromRGBO(138, 62, 255, 1),
  ],
  [
    Color.fromRGBO(255, 218, 80, 1),
    Color.fromRGBO(255, 155, 138, 1),
    Color.fromRGBO(255, 94, 195, 1),
    Color.fromRGBO(255, 70, 218, 1),
  ],
  [
    Color.fromRGBO(93, 245, 255, 1),
    Color.fromRGBO(85, 207, 255, 1),
    Color.fromRGBO(78, 174, 255, 1),
  ],
  [
    Color.fromRGBO(255, 69, 147, 1),
    Color.fromRGBO(228, 54, 131, 1),
  ],
  [
    Color.fromRGBO(175, 221, 255, 1),
    Color.fromRGBO(111, 156, 255, 1),
    Color.fromRGBO(88, 133, 255, 1),
  ],
];

List<String> fonts = const [
  "cairo",
  "almiri",
  "sf",
  "cairo",
  "almiri",
  "sf",
  "cairo",
  "almiri",
  "sf"
];
