import 'package:flutter/services.dart';

import 'package:infinity_ui/infinity_ui.dart';

class NotchUtils {
  static bool isNotched = false;
  static bool isGestureNavigation = false;

  static Future<bool> isDeviceNotched() async {
    const platform = const MethodChannel('com.simrat39.flutty_walls/wallpaper');
    try {
      return await platform.invokeMethod('isDeviceNotched').whenComplete(() {});
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> isUsingGestureNavigation() async {
    const platform = const MethodChannel('com.simrat39.flutty_walls/wallpaper');
    try {
      return await platform
          .invokeMethod('isGestureNavigation')
          .whenComplete(() {});
    } on PlatformException {
      return false;
    }
  }

  static Future initProperties() async {
    isNotched = await isDeviceNotched();
    isGestureNavigation = await isUsingGestureNavigation();
  }

  static Future<double> getNavigationBarHeight() async {
    const platform = const MethodChannel('com.simrat39.flutty_walls/wallpaper');
    try {
      return await platform
          .invokeMethod('getNavigationBarHeight')
          .whenComplete(() {});
    } on PlatformException {
      return InfinityUi.navigationBarHeight;
    }
  }
}
