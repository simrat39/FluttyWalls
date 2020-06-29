import 'package:flutter/material.dart';

import '../utils/WallpaperUtils.dart';

import '../widgets/SucklessGridViewPage.dart';

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: SucklessGridViewPage(WallpaperUtils.wallsWidgetList),
    );
  }
}
