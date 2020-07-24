import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:infinity_ui/infinity_ui.dart';

import '../models/NavigationModel.dart';

import '../utils/NotchUtils.dart';

class BottomBar extends StatelessWidget {
  // TODO: Clean this up, looks like infinity ui fixed notch handeling
  EdgeInsets complicatedMargin(BuildContext context) {
    return EdgeInsets.only(
      bottom: !NotchUtils.isGestureNavigation &&
              (Orientation.landscape == MediaQuery.of(context).orientation)
          ? 0
          : InfinityUi.navigationBarHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    var nav = Provider.of<NavigationModel>(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      var temp = width;
      width = height;
      height = temp;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(0.0),
      child: Container(
        // height: height * 0.09,
        margin: complicatedMargin(context),
        child: BottomNavigationBar(
          elevation: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_on),
              title: Text("Wallpapers"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.collections),
              title: Text("Collections"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_carousel),
              title: Text("Carousel"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              title: Text("Favourites"),
            ),
          ],
          currentIndex: nav.index,
          selectedItemColor: Theme.of(context).accentColor,
          onTap: nav.setIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          iconSize: height / width * 15,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}
