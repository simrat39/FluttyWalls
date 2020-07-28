import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/SucklessGridViewPage.dart';
import '../widgets/FadeIn.dart';
import '../widgets/image_tile.dart';

import '../models/FavouritesProvider.dart';
import '../models/WallpaperModel.dart';
import '../models/FavouriteModel.dart';

import '../utils/FavouriteUtils.dart';

class FavouritesPage extends StatelessWidget {
  static List<Widget> oldFavourtiesWidgetList = [];

  Widget wallsGridView(BuildContext context) {
    final PageStorageKey key = PageStorageKey('key');

    return FutureBuilder(
      future: FavouriteUtils.getFavourites(),
      builder: (context, snapshot) {
        if (!(snapshot.connectionState == ConnectionState.done)) {
          return SucklessGridViewPage(
            widgets: oldFavourtiesWidgetList,
            headerText: "Favourites",
            key: key,
          );
        } else {
          List<Widget> favourtiesWidgetList = [];

          List<String> favs = snapshot.data;

          if (favs.isEmpty || (favs[0] == null && favs.length == 1)) {
            return FadeIn(
              2.0,
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.favorite_border,
                      size: 60.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "No Favourites",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          for (int i = 0; i < favs.length; i++) {
            for (int j = 0; j < WallpaperModel.wallpapers.length; j++) {
              if (favs[i] == WallpaperModel.wallpapers[j].url) {
                favourtiesWidgetList.add(
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
          oldFavourtiesWidgetList = favourtiesWidgetList;

          if (favourtiesWidgetList.isEmpty) {
            return FadeIn(
              2.0,
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.favorite_border,
                      size: 60.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "No Favourites",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return SucklessGridViewPage(
            widgets: favourtiesWidgetList,
            headerText: "Favourites",
            key: key,
          );
        }
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: FavouritesProvider.provider,
        child: Consumer<FavouritesProvider>(
          builder: (context, fav, child) => wallsGridView(context),
        ),
      ),
    );
  }
}
