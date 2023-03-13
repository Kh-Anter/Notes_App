import 'package:flutter/material.dart';

extension ds on TimeOfDay {
  bool operator >(TimeOfDay otherTime) {
    if (hour == otherTime.hour && minute > otherTime.minute) {
      return true;
    } else if (hour > otherTime.hour) {
      return true;
    } else {
      return false;
    }
  }
}
