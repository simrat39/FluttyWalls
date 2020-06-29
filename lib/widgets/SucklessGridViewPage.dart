import 'package:flutter/material.dart';
import 'package:infinity_ui/infinity_ui.dart';

import 'colored_scrollbar.dart';

class SucklessGridViewPage extends StatelessWidget {
  final List<Widget> widgets;

  SucklessGridViewPage(this.widgets);

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(
        top: InfinityUi.statusBarHeight + (height * 0.01),
      ),
      padding: EdgeInsets.only(
        left: width * 0.019,
      ),
      child: AccentedScrollbar(
        highlightColor: Theme.of(context).accentColor,
        child: Container(
          padding: EdgeInsets.only(right: width * 0.019),
          child: GridView.count(
            physics: BouncingScrollPhysics(),
            crossAxisCount: (width * 0.003).ceil(),
            childAspectRatio: 0.6,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 6.0,
            children: widgets,
          ),
        ),
      ),
    );
  }
}
