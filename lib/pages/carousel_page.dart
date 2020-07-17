import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:provider/provider.dart';

import 'package:infinity_ui/infinity_ui.dart';

import '../models/FavouriteModel.dart';
import '../models/WallpaperModel.dart';

import '../pages/setter.dart';

import 'dart:ui';
import 'dart:math';

class CarouselImageTile extends StatelessWidget {
  final String url;
  final String name;
  final String author;
  final int index;

  CarouselImageTile({this.url, this.name, this.author, this.index});

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      var temp = width;
      width = height;
      height = temp;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Hero(
          tag: index.toString() + "WeDontWantThisDoWe",
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                fontSize: height / width * 13,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, anim, secondAnim) =>
                    ChangeNotifierProvider<FavouriteModel>.value(
                  value: FavouriteModel.providerList[index],
                  child: SetterPage(
                    url: url,
                    name: name,
                    author: author,
                    index: index,
                    heroTagName: index.toString() + "FromCarouselName",
                    heroTagHeart: index.toString() + "FromCarouselHeart",
                    heroTagImage: index.toString() + "FromCarouselImage",
                  ),
                ),
                transitionsBuilder: (context, anim, secondAnim, child) {
                  var tween = Tween(begin: 0.0, end: 1.0);
                  var animation = anim.drive(tween);
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Hero(
            tag: index.toString() + "FromCarouselImage",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                height: orientation == Orientation.portrait
                    ? height * 0.75
                    : height * 0.3,
                width: double.infinity,
                fit: BoxFit.cover,
                image: NetworkImage(url),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: height * 0.7,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).accentColor),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CarouselItems {
  static List<Widget> carouselItemsList = [];

  static Future<void> makeCarouselItemsList() async {
    if (carouselItemsList.isEmpty) {
      for (int i = 0; i < WallpaperModel.wallpapers.length; i++) {
        carouselItemsList.add(CarouselImageTile(
          url: WallpaperModel.wallpapers[i].url,
          name: WallpaperModel.wallpapers[i].name,
          author: WallpaperModel.wallpapers[i].author,
          index: WallpaperModel.wallpapers[i].index,
        ));
      }
    }
  }
}

class CarouselPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselPageState();
  }
}

class _CarouselPageState extends State<CarouselPage> {
  Future _carouelItemsInit;

  @override
  void initState() {
    _carouelItemsInit = CarouselItems.makeCarouselItemsList();
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder(
        future: _carouelItemsInit,
        builder: (context, snapshot) {
          if (!(snapshot.connectionState == ConnectionState.done))
            return Center(
              child: CircularProgressIndicator(),
            );
          return Container(
            padding: EdgeInsets.only(top: InfinityUi.statusBarHeight),
            child: CarouselSlider(
              items: CarouselItems.carouselItemsList,
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  scrollPhysics: BouncingScrollPhysics(),
                  height: height,
                  initialPage: 0,
                  onPageChanged: (index, reason) {}),
            ),
          );
        },
      ),
    );
  }
}
