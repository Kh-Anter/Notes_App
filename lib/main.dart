import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:note/controller/settings_controller.dart';
import 'package:note/controller/sqllite_ctrl.dart';
import 'package:note/screens/about_us_screen.dart';
import 'package:note/screens/add_alert_screen.dart';
import 'package:note/screens/add_note_screen.dart';
import 'package:note/screens/alerts_screen.dart';
import 'package:note/screens/app_shape_screen.dart';
import 'package:note/screens/camera_screen.dart';
import 'package:note/screens/departmentDetails_screen.dart';
import 'package:note/screens/departments_screen.dart';
import 'package:note/screens/favorite_screen.dart';
import 'package:note/screens/hero_view_screen.dart';
import 'package:note/screens/home_screen.dart';
import 'package:note/screens/lock_app_screen.dart';
import 'package:note/screens/pin_screen.dart';
import 'package:note/screens/record_screen.dart';
import 'package:note/screens/security_question_screen.dart';
import 'package:note/screens/setting_screen.dart';
import 'package:note/utils/themes/darkmode.dart';
import 'package:note/utils/themes/lightmode.dart';
import '../models/translation.dart';
import './screens/onbording_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SettingController controller = Get.put(SettingController(), permanent: true);
  final sqlliteCtl = Get.put(SqlliteHelper(), permanent: true);
  await sqlliteCtl.createDatabase();
  await controller.init();
  // SettingController().init();
  runApp(MyApp(controller: controller));
}

class MyApp extends StatelessWidget {
  SettingController? controller;
  MyApp({super.key, this.controller});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    controller!.mode == "dark"
        ? Get.changeTheme(darkMode)
        : Get.changeTheme(lightMode);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      // builder: FToastBuilder(),
      navigatorKey: controller!.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      translations: Translation(),
      locale: Locale(controller?.language == "ar" ? "ar" : "en"),
      fallbackLocale: const Locale("ar"),
      title: 'مفكرة',
      initialRoute: controller!.isFirstTime
          ? OnBoardingScreen.routeName
          : controller!.isAppLock
              ? PinScreen.routeName
              : HomeScreen.routeName,
      getPages: [
        // GetPage(name: SplashScreen.routeName, page: () => SplashScreen()),
        GetPage(name: HomeScreen.routeName, page: () => const HomeScreen()),
        GetPage(
            name: OnBoardingScreen.routeName,
            page: () => const OnBoardingScreen()),
        GetPage(
            name: AppShapeScreen.routeName, page: () => const AppShapeScreen()),
        GetPage(name: SettingScreen.routeName, page: () => SettingScreen()),
        GetPage(
            name: AddNoteScreen.routeName, page: () => const AddNoteScreen()),
        GetPage(name: RecordScreen.routeName, page: () => const RecordScreen()),
        GetPage(
            name: DepartmentsScreen.routeName,
            page: () => const DepartmentsScreen()),
        GetPage(name: AlertsScreen.routeName, page: () => AlertsScreen()),
        GetPage(name: FavoritesScreen.routeName, page: () => FavoritesScreen()),
        GetPage(
            name: DepartmentDetailsScreen.routeName,
            page: () => const DepartmentDetailsScreen()),
        GetPage(name: AddAlert.routeName, page: () => const AddAlert()),
        GetPage(name: CameraScreen.routeName, page: () => const CameraScreen()),
        GetPage(name: HeroViewScreen.routeName, page: () => HeroViewScreen()),
        GetPage(
            name: AboutUsScreen.routeName, page: () => const AboutUsScreen()),
        GetPage(name: LockAppScreen.routeName, page: () => LockAppScreen()),
        GetPage(name: PinScreen.routeName, page: () => const PinScreen()),
        GetPage(
            name: SecurityQuestionScreen.routeName,
            page: () => SecurityQuestionScreen()),
      ],
    );
  }
}
