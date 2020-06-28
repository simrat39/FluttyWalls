import 'package:flutter/material.dart';

class SnackbarUtils {
  // Show a SnackBar using a GlobalKey
  static void showSnackBar(GlobalKey<ScaffoldState> key, SnackBar snackBar) {
    key.currentState.showSnackBar(snackBar);
  }

  // Hide snackbar on scaffold with GlobalKey
  static void hideSnackbar(GlobalKey<ScaffoldState> key) {
    key.currentState.hideCurrentSnackBar();
  }
}
