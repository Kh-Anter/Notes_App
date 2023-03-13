import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note/constants.dart';

ThemeData lightMode = ThemeData(
    fontFamily: "Almarai",
    appBarTheme: const AppBarTheme(
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarColor: Color.fromARGB(80, 0, 0, 0)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: "Almarai"),
      centerTitle: true,
    ),
    //scaffoldBackgroundColor: greyBackgroundColor,
    drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(0, 191, 166, 1),
    ),
    listTileTheme: const ListTileThemeData(
        iconColor: Color.fromRGBO(0, 191, 166, 1), textColor: Colors.black),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(mySecondaryColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            side: MaterialStateProperty.all(
                const BorderSide(color: mySecondaryColor)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            )))),
    //   sliderTheme:  SliderTheme(data: SliderThemeData(thumbColor: Colors.grey),child: Text("")),

    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
    // backgroundColor: Colors.red,
    scaffoldBackgroundColor: Colors.white);
