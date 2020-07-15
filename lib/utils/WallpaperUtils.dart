import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'package:gallery_saver/gallery_saver.dart';

import 'package:provider/provider.dart';

import 'package:retry/retry.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../models/WallpaperModel.dart';
import '../models/FavouriteModel.dart';
import '../models/FavouritesProvider.dart';

import '../widgets/image_tile.dart';
import '../widgets/suckless_snackbar.dart';

import 'SnackbarUtils.dart';
import 'CollectionUtils.dart';

import '../pages/carousel_page.dart';

import 'dart:convert';

class WallpaperUtils {
  static List<Widget> wallsWidgetList = [];

  static Future<void> init() async {
    var response = await retry(
      () => http.get("http://shishuwalls.bootleggersrom.xyz/wallpapers.json"),
    );

    List<dynamic> jsonData = jsonDecode(response.body);

    jsonData.forEach((element) {
      WallpaperModel.wallpapers.add(WallpaperModel(
          url: element["url"],
          name: element["name"],
          author: element["author"],
          collections: element["collections"],
          index: jsonData.indexOf(element)));
    });

    CollectionUtils.makeCollections();
    createWallsWidgets();
    CarouselItems.makeCarouselItemsList();
  }

  static void createWallsWidgets() {
    wallsWidgetList = [];
    // wallpapers.shuffle();
    for (int i = 0; i < WallpaperModel.wallpapers.length; i++) {
      FavouriteModel.providerList
          .add(FavouriteModel(WallpaperModel.wallpapers[i].url));
      wallsWidgetList.add(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<FavouriteModel>.value(
              value: FavouriteModel.providerList[i],
            ),
            ChangeNotifierProvider<FavouritesProvider>.value(
              value: FavouritesProvider.provider,
            ),
          ],
          child: ImageTile(
            url: WallpaperModel.wallpapers[i].url,
            name: WallpaperModel.wallpapers[i].name,
            author: WallpaperModel.wallpapers[i].author,
            index: WallpaperModel.wallpapers[i].index,
            heroTag:
                WallpaperModel.wallpapers[i].index.toString() + "FromWallsName",
            heroTagOther: WallpaperModel.wallpapers[i].index.toString() +
                "FromWallsHeart",
          ),
        ),
      );
    }
  }

  // Delay for n milliseconds
  static Future sleepN(int n) {
    return new Future.delayed(Duration(milliseconds: n), () => "1");
  }

  // Save image to gallery using gallery_saver
  static Future saveImage(String url) {
    return GallerySaver.saveImage(url);
  }

  static Future<void> setWallpaper(String url, int type, BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey) async {
    var snackBar = SucklessSnackbar(context, 'Setting wallpaper');
    SnackbarUtils.showSnackBar(scaffoldKey, snackBar);

    await sleepN(1000);

    const platform = const MethodChannel('com.simrat39.flutty_walls/wallpaper');
    var file = await DefaultCacheManager().getSingleFile(url);
    try {
      await platform
          .invokeMethod('setWallpaper', [file.path, type]).whenComplete(() {
        SnackbarUtils.hideSnackbar(scaffoldKey);
        snackBar = SucklessSnackbar(context, 'Wallpaper set!');
        SnackbarUtils.showSnackBar(scaffoldKey, snackBar);
      });
    } on PlatformException {
      snackBar = SucklessSnackbar(context, 'Error setting wallpaper :(');
      SnackbarUtils.showSnackBar(scaffoldKey, snackBar);
    }
  }
}
