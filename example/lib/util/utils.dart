import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

bool isLight(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light;
}

bool isMobilePlatform() {
  if(kIsWeb){
    return false;
  }
  return Platform.isAndroid || Platform.isIOS;
}
