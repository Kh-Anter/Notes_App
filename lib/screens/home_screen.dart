import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:note/controller/home_controller.dart';
import 'package:note/controller/settings_controller.dart';
import 'package:note/controller/sqllite_ctrl.dart';
import 'package:note/models/notification.dart';
import 'package:note/screens/add_note_screen.dart';
import 'package:note/screens/alerts_screen.dart';
import 'package:note/screens/departments_screen.dart';
import 'package:note/screens/favorite_screen.dart';
import 'package:note/screens/lock_app_screen.dart';
import 'package:note/screens/setting_screen.dart';
import 'package:note/widgets/home_widgets/arr_shape_widget.dart';
import 'package:note/widgets/home_widgets/home_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:store_redirect/store_redirect.dart';

import '../constants.dart';
import '../size_config.dart';

import './app_shape_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = "/Home";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final sqlliteCtrl = Get.put(SqlliteHelper(), permanent: true);
  final homeCtrl = Get.put(HomeController(), permanent: true);
  final settingCtrl = Get.put(SettingController(), permanent: true);
  final size = SizeConfig();

  @override
  void initState() {
    super.initState();
    MyNotification.init();
    listenNotifications();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void listenNotifications() => MyNotification.onNotification.stream
      .listen((payload) => onClickedNotification(payload!));

  onClickedNotification(String payload) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const AddNoteScreen()));
  }

  @override
  Widget build(BuildContext context) {
    size.init(context);
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          appBar: myAppBar(controller),
          extendBodyBehindAppBar: true,
          drawer: homeCtrl.selectedNavBar == 1 ? myDrawer() : null,
          bottomNavigationBar: myBottomNavBar(controller),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: myFloatingActionBtn(),
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: GetBuilder<SettingController>(
                builder: (controller) => controller.appShape == 0
                    ? SafeArea(
                        child: homeCtrl.selectedNavBar == 0
                            ? ArrShapeWidget()
                            : HomeWidget())
                    : DecoratedBox(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/app_shape/bg${controller.appShape}.jpg"),
                                fit: BoxFit.cover)),
                        child: SafeArea(
                            child: homeCtrl.selectedNavBar == 0
                                ? ArrShapeWidget()
                                : HomeWidget()),
                      )),
          ));
    });
  }

  Widget myBottomNavBar(controller) {
    return SizedBox(
      height: 60,
      child: BottomAppBar(
        elevation: 35,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.file_copy_outlined,
                  color: controller.selectedNavBar == 0
                      ? mySecondaryColor
                      : myTextFieldBorderColor,
                  size: 25),
              onPressed: () {
                setState(() {
                  controller.selectedNavBar = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.home_outlined,
                  color: controller.selectedNavBar == 1
                      ? mySecondaryColor
                      : myTextFieldBorderColor,
                  size: 25),
              onPressed: () {
                setState(() {
                  controller.selectedNavBar = 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget myDrawer() {
    TextStyle ts = const TextStyle(fontWeight: FontWeight.bold);
    return Drawer(
        child: Stack(
      children: [
        Positioned(
          right: -80,
          bottom: -40,
          left: 0,
          child: SvgPicture.asset(
            "assets/images/home/drawer2.svg",
            fit: BoxFit.cover,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 190,
                height: 150,
                margin: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  "assets/images/splash_screen/note2.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListTile(
                horizontalTitleGap: 10,
                leading: const Icon(Icons.extension),
                title: Text(
                  "design".tr,
                  style: ts,
                ),
                onTap: () => Get.offAndToNamed(AppShapeScreen.routeName),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListTile(
                horizontalTitleGap: 10,
                leading: const Icon(Icons.file_copy_outlined),
                title: Text(
                  "department".tr,
                  style: ts,
                ),
                onTap: () => Get.offAndToNamed(DepartmentsScreen.routeName,
                    arguments: ["dep", false]),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListTile(
                horizontalTitleGap: 10,
                leading: const Icon(Icons.lock_outlined),
                title: Text(
                  "close note".tr,
                  style: ts,
                ),
                onTap: () => Get.offAndToNamed(LockAppScreen.routeName),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListTile(
                horizontalTitleGap: 10,
                leading: const Icon(Icons.notifications),
                title: Text(
                  "alerts".tr,
                  style: ts,
                ),
                onTap: () => Get.offAndToNamed(AlertsScreen.routeName),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListTile(
                horizontalTitleGap: 10,
                leading: const Icon(Icons.favorite_outline),
                title: Text(
                  "fav".tr,
                  style: ts,
                ),
                onTap: () => Get.offAndToNamed(FavoritesScreen.routeName),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListTile(
                horizontalTitleGap: 10,
                leading: const Icon(
                  Icons.star,
                  color: myPrimaryColor,
                ),
                title: Text(
                  "rate".tr,
                  style: ts,
                ),
                onTap: () {
                  Get.back();
                  showDialog(
                    context: context,
                    barrierDismissible:
                        true, // set to false if you want to force a rating
                    builder: (context) => _dialog(),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
              child: ListTile(
                horizontalTitleGap: 10,
                leading: const Icon(Icons.share),
                title: Text(
                  "share".tr,
                  style: ts,
                ),
                onTap: () => Share.share("com.example.note"),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListTile(
                horizontalTitleGap: 10,
                leading: const Icon(Icons.settings),
                title: Text(
                  "setting".tr,
                  style: ts,
                ),
                onTap: () => Get.offAndToNamed(SettingScreen.routeName),
              ),
            ),
          ],
        ),
      ],
    ));
  }

  myAppBar(controller) {
    return AppBar(
      actions: homeCtrl.selectedNavBar == 1 && controller.isNotesEmpty == false
          ? [
              IconButton(
                  onPressed: () {
                    homeCtrl.isArrangeNotesOpen.value =
                        !homeCtrl.isArrangeNotesOpen.value;
                  },
                  icon: const Icon(Icons.swap_vert_sharp))
            ]
          : null,
      title: homeCtrl.selectedNavBar == 0
          ? Text(
              "choose arr".tr,
            )
          : null,
    );
  }

  myFloatingActionBtn() {
    return FloatingActionButton(
        child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [mySecondaryColor, myPrimaryColor])),
            child: const Icon(Icons.add, size: 25)),
        onPressed: () => Get.toNamed(AddNoteScreen.routeName));
  }

  Widget _dialog() {
    return RatingDialog(
      starSize: 30,

      initialRating: 4.0,
      // your app's name?
      title: Text(
        'rateUs'.tr,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: Text(
        "tellothers".tr,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: Image.asset(
        "assets/images/ic_launcher.jpg",
        width: 100,
        height: 100,
      ),
      submitButtonText: "Submit".tr,
      submitButtonTextStyle: const TextStyle(color: Colors.black),
      commentHint: "Set your custom comment hint".tr,
      onSubmitted: (response) {
        if (response.rating < 3.0) {
        } else {
          StoreRedirect.redirect(
              androidAppId: "com.example.note", iOSAppId: "com.example.note");
        }
      },
    );
  }
  // show the dialog
}
