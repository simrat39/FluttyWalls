import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'widgets/bottom_bar.dart';
import 'widgets/fade_indexed_stack_widget.dart';

import 'pages/homepage.dart';
import 'pages/favourites_page.dart';
import 'pages/carousel_page.dart';
import 'pages/collections_page.dart';

import 'package:provider/provider.dart';

import 'package:infinity_ui/infinity_ui.dart';

import 'utils/WallpaperUtils.dart';
import 'utils/FavouriteUtils.dart';
import 'utils/NotchUtils.dart';

import 'models/NavigationModel.dart';

class CustomImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    ImageCache imageCache = super.createImageCache();
    // Set your image cache size
    imageCache.maximumSizeBytes = 1024 * 1024 * 1024; // 1 GB
    imageCache.maximumSize = 1000; // 1000 Items
    return imageCache;
  }
}

void main() async {
  CustomImageCache();
  await FavouriteUtils.init();
  await InfinityUi.enable();
  await NotchUtils.initProperties();
  runApp(RootWindow());
}

class RootWindow extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.blueAccent,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xff121217), // scaffoldBackgroundColor
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Color(0xff121217),
        dialogBackgroundColor: Color(0xff1a1a1f),
        scaffoldBackgroundColor: Color(0xff121217),
        accentColor: Colors.blue,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xff121217), // scaffoldBackgroundColor
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: ChangeNotifierProvider.value(
        value: NavigationModel.model,
        child: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Future _wallpapersInit;

  @override
  void initState() {
    _wallpapersInit = WallpaperUtils.init();
    super.initState();
  }

  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    }

    return FutureBuilder(
        future: _wallpapersInit,
        builder: (context, snapshot) {
          if (!(snapshot.connectionState == ConnectionState.done)) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            bottomNavigationBar: BottomBar(),
            body: Consumer<NavigationModel>(
              builder: (context, nav, child) {
                return FadeIndexedStack(
                  duration: Duration(
                    milliseconds: 400,
                  ),
                  children: <Widget>[
                    HomePage(),
                    CollectionsPage(),
                    CarouselPage(),
                    FavouritesPage(),
                  ],
                  index: nav.index,
                );
              },
            ),
          );
        });
  }
}
