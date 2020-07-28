import '../widgets/CollectionCard.dart';

import 'package:flutter/material.dart';
import 'package:infinity_ui/infinity_ui.dart';

import '../utils/CollectionUtils.dart';
import '../models/WallpaperModel.dart';
import '../models/FavouriteModel.dart';
import '../models/FavouritesProvider.dart';
import '../widgets/SucklessGridViewPage.dart';
import '../widgets/image_tile.dart';
import 'package:provider/provider.dart';

import 'dart:math';

class CollectionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectionsPageState();
  }
}

class _CollectionsPageState extends State<CollectionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: InfinityUi.statusBarHeight),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            List<Widget> holder = [];
            for (int y = 0;
                y < CollectionUtils.collections.values.elementAt(index).length;
                y++) {
              for (int j = 0; j < WallpaperModel.wallpapers.length; j++) {
                if (CollectionUtils.collections.values
                        .elementAt(index)[y]
                        .toString() ==
                    WallpaperModel.wallpapers[j].url.toString()) {
                  holder.add(
                    ChangeNotifierProvider<FavouriteModel>.value(
                      value: FavouriteModel.providerList[j],
                      child: ImageTile(
                        url: WallpaperModel.wallpapers[j].url,
                        name: WallpaperModel.wallpapers[j].name,
                        author: WallpaperModel.wallpapers[j].author,
                        index: WallpaperModel.wallpapers[j].index,
                      ),
                    ),
                  );
                }
              }
            }
            Random r = Random();
            return CollectionCard(
              name: CollectionUtils.collections.keys.elementAt(index),
              thumbUrl: CollectionUtils.collections.values.elementAt(
                  index)[r.nextInt(CollectionUtils.collections.values.length)],
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: Duration(
                      milliseconds: 400,
                    ),
                    pageBuilder: (context, anim, anim2) => Scaffold(
                      body: SucklessGridViewPage(
                        widgets: holder,
                        headerText: CollectionUtils.collections.keys
                            .elementAt(index)
                            .toString(),
                        key: PageStorageKey(
                            CollectionUtils.collections.keys.elementAt(index)),
                        shouldAddBottomPadding: true,
                        shouldHeaderHero: true,
                        headerHeroTag:
                            CollectionUtils.collections.keys.elementAt(index) +
                                "nameHero",
                      ),
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(-1.0, 0.0);
                      var end = Offset.zero;
                      var tween = Tween(begin: begin, end: end);
                      var curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: Curves.ease,
                      );
                      return SlideTransition(
                        position: tween.animate(curvedAnimation),
                        textDirection: TextDirection.rtl,
                        child: child,
                      );
                    },
                  ),
                );
              },
            );
          },
          itemCount: CollectionUtils.collections.keys.length,
        ),
      ),
    );
  }
}
