import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note/constants.dart';

ThemeData darkMode = ThemeData(
    fontFamily: "Almarai",
    appBarTheme: const AppBarTheme(
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarColor: Color.fromARGB(80, 0, 0, 0)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black54),
      titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: "Almarai"),
      centerTitle: true,
    ),
    //scaffoldBackgroundColor: greyBackgroundColor,
    drawerTheme: const DrawerThemeData(backgroundColor: Colors.black54),
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(0, 191, 166, 1),
    ),
    listTileTheme: const ListTileThemeData(
        iconColor: Color.fromRGBO(0, 191, 166, 1), textColor: Colors.white),
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
    // bottomNavigationBarTheme:
    //     BottomNavigationBarThemeData(backgroundColor: Colors.grey),
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black54),
    // backgroundColor: Colors.red,
    scaffoldBackgroundColor: Colors.grey);
  



/*
ThemeData(
  fontFamily: "Almarai",
  appBarTheme: const AppBarTheme(
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(80, 0, 0, 0),
        //  statusBarIconBrightness: Brightness.dark,
      ),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: "Almarai",
      ),
      centerTitle: true,
      backgroundColor: dartBackgroundColor),
  //scaffoldBackgroundColor: dartBackgroundColor,

  drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
  // primaryColor: const Color.fromRGBO(110, 11, 11, 1),
  iconTheme: const IconThemeData(
    color: Color.fromRGBO(0, 191, 166, 1),
  ),
  listTileTheme: const ListTileThemeData(
      iconColor: Color.fromRGBO(0, 191, 166, 1), textColor: Colors.black),
);
*/