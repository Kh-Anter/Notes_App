import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/favorite_controller.dart';
import 'package:note/widgets/home_widgets/notes_shape/thirdShap.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({Key? key}) : super(key: key);
  static const routeName = "/Favorites";
  final favCtrl = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    favCtrl.initAllFav();
    return Scaffold(
      appBar: _myAppBar(),
      body: SafeArea(
          child: Column(
        children: [
          ThirdShap(ParentWidget.fav),
        ],
      )),
    );
  }

  _myAppBar() {
    return AppBar(
      toolbarHeight: 35,
      title: Text("Favorites".tr),
      leading: InkWell(
        onTap: (() => Get.back()),
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
    );
  }
}
