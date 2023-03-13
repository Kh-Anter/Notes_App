import 'package:flutter/material.dart';
import 'package:note/constants.dart';

class BuildDot extends StatelessWidget {
  int length;
  int currentIndex;
  BuildDot({required this.length, required this.currentIndex, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(length, (index) {
          return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 3),
              width: currentIndex == index ? 32 : 15,
              height: currentIndex == index ? 8 : 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: mySecondaryColor),
                color: currentIndex == index ? mySecondaryColor : Colors.white,
              ));
        }));
  }
}
