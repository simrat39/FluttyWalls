import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/FadeIn.dart';
import '../widgets/SucklessGridViewPage.dart';

import '../models/FavouritesProvider.dart';
import '../models/WallpaperModel.dart';

import '../utils/FavouriteUtils.dart';
import '../utils/WallpaperUtils.dart';

class FavouritesPage extends StatelessWidget {
  Widget wallsGridView(BuildContext context) {
    List<String> favsOld = [];
    return FutureBuilder(
        future: FavouriteUtils.getFavourites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Widget> favourtiesWidgetList = [];

            List<String> favs = snapshot.data;

            if (favs.isEmpty || (favs[0] == null && favs.length == 1)) {
              return Center(
                child: Icon(
                  Icons.favorite_border,
                  size: 60.0,
                ),
              );
            }

            if (favsOld != favs) {
              for (int i = 0; i < favs.length; i++) {
                for (int j = 0; j < WallpaperModel.wallpapers.length; j++) {
                  if (favs[i] == WallpaperModel.wallpapers[j].url) {
                    favourtiesWidgetList.add(
                      FadeIn(
                        2,
                        WallpaperUtils.wallsWidgetList[j],
                      ),
                    );
                  }
                }
              }
              favsOld = favs;
            }
            return SucklessGridViewPage(favourtiesWidgetList);
          } else {
            return Container();
          }
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: FavouritesProvider.provider,
        child: Consumer<FavouritesProvider>(
          builder: (__, _, child) => wallsGridView(context),
        ),
      ),
    );
  }
}
