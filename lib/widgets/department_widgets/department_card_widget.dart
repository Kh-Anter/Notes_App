import 'package:flutter/material.dart';
import 'package:note/constants.dart';

// ignore: must_be_immutable
class DepartmentCardWidget extends StatelessWidget {
  String title;
  int color = 1;
  DepartmentCardWidget({Key? key, required this.title, this.color = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Expanded(
              child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: departmentCardColors[color],
                      begin: Alignment.bottomCenter),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0)),
                  color: mySecondaryColor,
                ),
              ),
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 15,
                  child: Container(
                    width: 10,
                    height: 150,
                    color: Colors.white,
                  )),
              Positioned(
                  bottom: 15,
                  right: 10,
                  child: Row(
                    children: [
                      Container(
                        width: 7,
                        height: 2,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 3),
                      Container(
                        width: 7,
                        height: 2,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 3),
                      Container(
                        width: 7,
                        height: 2,
                        color: Colors.white,
                      )
                    ],
                  )),
            ],
          )),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: mySecondaryColor),
            ),
          )
        ],
      ),
    );
  }
}
