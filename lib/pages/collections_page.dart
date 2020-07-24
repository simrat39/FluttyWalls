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
  static List<Widget> collectionCards = [];
  static List<List<Widget>> holder = [];

  void makeCards() {
    for (int i = 0; i < CollectionUtils.collections.keys.length; i++) {
      holder.add([]);
      for (int y = 0;
          y < CollectionUtils.collections.values.elementAt(i).length;
          y++) {
        for (int j = 0; j < WallpaperModel.wallpapers.length; j++) {
          if (CollectionUtils.collections.values.elementAt(i)[y].toString() ==
              WallpaperModel.wallpapers[j].url.toString()) {
            holder[i].add(
              MultiProvider(
                providers: [
                  ChangeNotifierProvider<FavouriteModel>.value(
                    value: FavouriteModel.providerList[j],
                  ),
                  ChangeNotifierProvider<FavouritesProvider>.value(
                    value: FavouritesProvider.provider,
                  ),
                ],
                child: ImageTile(
                  url: WallpaperModel.wallpapers[j].url,
                  name: WallpaperModel.wallpapers[j].name,
                  author: WallpaperModel.wallpapers[j].author,
                  index: WallpaperModel.wallpapers[j].index,
                  heroTagName: WallpaperModel.wallpapers[j].index.toString() +
                      "FromCollection" +
                      CollectionUtils.collections.keys.elementAt(i).toString() +
                      "Name",
                  heroTagHeart: WallpaperModel.wallpapers[j].index.toString() +
                      "FromCollection" +
                      CollectionUtils.collections.keys.elementAt(i).toString() +
                      "Heart",
                  heroTagImage: WallpaperModel.wallpapers[j].index.toString() +
                      "FromCollection" +
                      CollectionUtils.collections.keys.elementAt(i).toString() +
                      "Image",
                ),
              ),
            );
          }
        }
      }

      Random r = Random();
      collectionCards.add(
        CollectionCard(
          name: CollectionUtils.collections.keys.elementAt(i),
          thumbUrl: CollectionUtils.collections.values.elementAt(
              i)[r.nextInt(CollectionUtils.collections.values.length)],
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: SucklessGridViewPage(
                    widgets: holder[i],
                    headerText: CollectionUtils.collections.keys
                        .elementAt(i)
                        .toString(),
                    key: PageStorageKey(
                        CollectionUtils.collections.keys.elementAt(i)),
                    shouldAddBottomPadding: true,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    if (collectionCards.isEmpty)
      setState(() {
        makeCards();
      });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(
            top: InfinityUi.statusBarHeight,
          ),
          child: Column(
            children: collectionCards,
          ),
        ),
      ),
    );
  }
}
