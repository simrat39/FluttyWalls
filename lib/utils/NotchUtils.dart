import 'package:flutter/services.dart';

import 'dart:io' show Platform;

class NotchUtils {
  static bool isNotched = false;
  static bool isGestureNavigation = false;

  static Future<bool> isDeviceNotched() async {
    if (Platform.isAndroid) {
      const platform =
          const MethodChannel('com.simrat39.flutty_walls/wallpaper');
      try {
        return await platform
            .invokeMethod('isDeviceNotched')
            .whenComplete(() {});
      } on PlatformException {
        return false;
      }
    }
    return false;
  }

  static Future<bool> isUsingGestureNavigation() async {
    if (Platform.isAndroid) {
      const platform =
          const MethodChannel('com.simrat39.flutty_walls/wallpaper');
      try {
        return await platform
            .invokeMethod('isGestureNavigation')
            .whenComplete(() {});
      } on PlatformException {
        return false;
      }
    }
    return false;
  }

  static Future initProperties() async {
    isNotched = await isDeviceNotched();
    isGestureNavigation = await isUsingGestureNavigation();
  }
}
