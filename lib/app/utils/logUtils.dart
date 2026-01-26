
import 'package:flutter/foundation.dart';

const kLOG_TAG = "[Pregnancy]";
const bool kLOG_ENABLE = true;

printLog(dynamic data) {
  // if (kLOG_ENABLE) {
    if (kDebugMode) {
      print("$kLOG_TAG: ${data.toString()}");
    }
  // }
}