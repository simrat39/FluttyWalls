import 'package:flutter/material.dart';

import '../utils/WallpaperUtils.dart';

import '../widgets/SucklessGridViewPage.dart';
import '../widgets/FadeIn.dart';

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pop(
        SucklessGridViewPage(WallpaperUtils.wallsWidgetList),
      ),
    );
  }
}
