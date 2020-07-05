import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:photo_view/photo_view.dart';

import 'package:provider/provider.dart';

import 'package:infinity_ui/infinity_ui.dart';

import '../widgets/suckless_snackbar.dart';
import '../widgets/favourites_icon.dart';

import '../models/FavouriteModel.dart';

import '../utils/WallpaperUtils.dart';
import '../utils/SnackbarUtils.dart';
import '../utils/NotchUtils.dart';

import 'dart:ui';

class SetterPage extends StatefulWidget {
  final String url;
  final String name;
  final String author;
  final int index;

  SetterPage({this.url, this.name, this.author, this.index});
  @override
  State<StatefulWidget> createState() {
    return _SetterPageState(url: url, name: name, author: author, index: index);
  }
}

class _SetterPageState extends State<SetterPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  bool areItemsVisible = true;

  final String url;
  final String name;
  final String author;
  final int index;

  Brightness brightness;

  _SetterPageState({this.url, this.name, this.author, this.index});

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    if (brightness == Brightness.light) {
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
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  }

  void toggleSystemUIOverlays() {
    if (!areItemsVisible) {
      SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    } else {
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
    Future.delayed(Duration(milliseconds: 100));
  }

  void toggleVisibility() {
    toggleSystemUIOverlays();
    setState(() {
      areItemsVisible = !areItemsVisible;
    });
  }

  Widget wallpaperSetDialog() {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      contentPadding: EdgeInsets.all(15.0),
      title: const Text(
        'Select wallpaper type',
        style: TextStyle(
          fontSize: 25,
        ),
      ),
      children: <Widget>[
        SimpleDialogOption(
          padding: EdgeInsets.all(20.0),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            await WallpaperUtils.sleepN(200);
            WallpaperUtils.setWallpaper(url, 1, context, _scaffoldkey);
          },
          child: const Text(
            'Only Home Screen',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        SimpleDialogOption(
          padding: EdgeInsets.all(20.0),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            await WallpaperUtils.sleepN(200);
            WallpaperUtils.setWallpaper(url, 2, context, _scaffoldkey);
          },
          child: const Text(
            'Only Lock Screen',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        SimpleDialogOption(
          padding: EdgeInsets.all(20.0),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            await WallpaperUtils.sleepN(200);
            WallpaperUtils.setWallpaper(url, 3, context, _scaffoldkey);
          },
          child: const Text(
            'Both',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var fav = Provider.of<FavouriteModel>(context);

    brightness = Theme.of(context).brightness;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      var temp = width;
      width = height;
      height = temp;
    }

    var awfullyComplicatedPadding =
        InfinityUi.navigationBarHeight - (InfinityUi.navigationBarHeight * 0.4);

    return Scaffold(
      key: _scaffoldkey,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: toggleVisibility,
            child: PhotoView(
              imageProvider: NetworkImage(url),
              initialScale: PhotoViewComputedScale.covered,
              minScale: PhotoViewComputedScale.covered * 0.99,
            ),
          ),
          GestureDetector(
            onTap: () => toggleVisibility(),
            child: AnimatedOpacity(
              opacity: areItemsVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: InfinityUi.statusBarHeight,
                    ),
                    width: double.infinity,
                    height: height * 0.125,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: AlignmentDirectional.topCenter,
                          end: AlignmentDirectional.bottomCenter,
                          colors: <Color>[
                            Colors.black54,
                            Colors.black26,
                            Colors.transparent,
                          ]),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  width * 0.03, height * 0.015, 0, 0),
                              child: Icon(
                                CupertinoIcons.back,
                                size: height / width * 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onTap: areItemsVisible
                              ? () => Navigator.pop(context)
                              : () {
                                  toggleVisibility();
                                },
                          behavior: HitTestBehavior.translucent,
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                width * 0.03, height * 0.015, width * 0.03, 0),
                            alignment: Alignment.topRight,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    name,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                      fontSize: height / width * 12,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    author,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                      fontSize: height / width * 9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: height * 0.1,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? awfullyComplicatedPadding
                            : !NotchUtils.isGestureNavigation
                                ? 0
                                : awfullyComplicatedPadding),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: AlignmentDirectional.topCenter,
                          end: AlignmentDirectional.bottomCenter,
                          colors: <Color>[
                            Colors.transparent,
                            Colors.black26,
                            Colors.black38,
                            Colors.black54,
                          ]),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(
                            Icons.file_download,
                            size: height / width * 15,
                            color: Colors.white,
                          ),
                          onTap: areItemsVisible
                              ? () async {
                                  var snackBar = SucklessSnackbar(context,
                                      'Saving wallpaper to gallery...');
                                  SnackbarUtils.showSnackBar(
                                      _scaffoldkey, snackBar);
                                  await WallpaperUtils.saveImage(url);
                                  SnackbarUtils.hideSnackbar(_scaffoldkey);
                                  snackBar = SucklessSnackbar(
                                      context, 'Wallpaper saved!');
                                  SnackbarUtils.showSnackBar(
                                      _scaffoldkey, snackBar);
                                }
                              : () {
                                  toggleVisibility();
                                },
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.wallpaper,
                            size: height / width * 15,
                            color: Colors.white,
                          ),
                          onTap: areItemsVisible
                              ? () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return wallpaperSetDialog();
                                      });
                                }
                              : () {
                                  toggleVisibility();
                                },
                        ),
                        FavouriteIcon(
                          url: url,
                          icon: fav.icon,
                          press: fav.toggleFavourite,
                          size: height / width * 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
