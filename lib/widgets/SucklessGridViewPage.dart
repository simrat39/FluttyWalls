import 'package:flutter/material.dart';
import 'package:infinity_ui/infinity_ui.dart';

import 'colored_scrollbar.dart';

class SucklessGridViewPage extends StatelessWidget {
  final List<Widget> widgets;
  final String headerText;
  final PageStorageKey key;
  final bool shouldAddBottomPadding;
  final bool shouldHeaderHero;
  final String headerHeroTag;

  SucklessGridViewPage({
    @required this.widgets,
    @required this.headerText,
    this.key,
    this.shouldAddBottomPadding = false,
    this.shouldHeaderHero = false,
    this.headerHeroTag,
  });

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
          bottom: shouldAddBottomPadding ? InfinityUi.navigationBarHeight : 0,
        ),
        child: AccentedScrollbar(
          highlightColor: Theme.of(context).accentColor,
          child: Container(
            padding: EdgeInsets.only(right: width * 0.015),
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: InfinityUi.statusBarHeight - (height * 0.02),
                      bottom: height * 0.02,
                    ),
                    child: Hero(
                      tag: shouldHeaderHero
                          ? headerHeroTag
                          : "WeDontWantHeroIn" + headerText,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          headerText,
                          style: TextStyle(
                            fontSize: height / width * 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (width * 0.003).ceil(),
                    childAspectRatio: 0.634,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return widgets[index];
                    },
                    childCount: widgets.length,
                  ),
                ),
                // shrinkWrap: true,
              ],
            ),
          ),
        ),
      );
    else
      return Container();
  }
}
