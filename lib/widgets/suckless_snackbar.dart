import 'package:flutter/material.dart';

Widget SucklessSnackbar(BuildContext context, String text) {
  return SnackBar(
    content: Text(
      text,
      style: TextStyle(color: Theme.of(context).textTheme.headline6.color),
    ),
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    behavior: SnackBarBehavior.floating,
  );
}
