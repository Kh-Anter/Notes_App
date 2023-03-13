import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/widgets/department_widgets/add_department_dialoge.dart';

class AddDepartmentWidget extends StatelessWidget {
  const AddDepartmentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: 100,
            margin: const EdgeInsets.only(left: 10),
            child: DottedBorder(
              padding: const EdgeInsets.all(10),
              color: depCardBorderColor,
              strokeWidth: 2,
              borderType: BorderType.RRect,
              radius: const Radius.circular(7),
              dashPattern: const [12, 6],
              child: Center(
                child: InkWell(
                  onTap: () => AddDepartmentDialog.addNewDep(context),
                  child: const Icon(
                    Icons.add_circle,
                    color: depCardBtnColor,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: Text(
            "addDep".tr,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: mySecondaryColor),
          ),
        )
      ],
    );
  }
}
