import 'package:flutter/material.dart';
import 'package:infinity_ui/infinity_ui.dart';

import 'colored_scrollbar.dart';

class SucklessGridViewPage extends StatelessWidget {
  final List<Widget> widgets;
  final String headerText;
  final PageStorageKey key;

  SucklessGridViewPage(
      {@required this.widgets, @required this.headerText, this.key});

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (widgets.isNotEmpty)
      return Container(
        margin: EdgeInsets.only(
          top: InfinityUi.statusBarHeight,
        ),
        padding: EdgeInsets.only(
          left: width * 0.019,
        ),
        child: AccentedScrollbar(
          highlightColor: Theme.of(context).accentColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.02,
                    bottom: height * 0.02,
                  ),
                  child: Text(
                    headerText,
                    style: TextStyle(
                      fontSize: height / width * 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: width * 0.019),
                  child: GridView.builder(
                    key: key,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (width * 0.003).ceil(),
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 6.0,
                      mainAxisSpacing: 6.0,
                    ),
                    itemBuilder: (context, index) {
                      return widgets[index];
                    },
                    itemCount: widgets.length,
                    shrinkWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    else
      return Container();
  }
}
