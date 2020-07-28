import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:provider/provider.dart';

import 'package:infinity_ui/infinity_ui.dart';

import '../models/FavouriteModel.dart';
import '../models/WallpaperModel.dart';

import '../pages/SetterPage.dart';

import 'dart:ui';

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
        Text(
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
        Hero(
          tag: index.toString() + "FromCarouselImage",
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image(
                  height: orientation == Orientation.portrait
                      ? height * 0.75
                      : height * 0.3,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  image: NetworkImage(url),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: height * 0.75,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).accentColor),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: double.infinity,
                  height: orientation == Orientation.portrait
                      ? height * 0.75
                      : height * 0.3,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 400),
                            pageBuilder: (context, anim, secondAnim) =>
                                ChangeNotifierProvider<FavouriteModel>.value(
                              value: FavouriteModel.providerList[index],
                              child: SetterPage(
                                url: url,
                                name: name,
                                author: author,
                                index: index,
                                heroTagImage:
                                    index.toString() + "FromCarouselImage",
                              ),
                            ),
                            transitionsBuilder:
                                (context, anim, secondAnim, child) {
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
                    ),
                  ),
                ),
              ],
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
        carouselItemsList.add(
          CarouselImageTile(
            url: WallpaperModel.wallpapers[i].url,
            name: WallpaperModel.wallpapers[i].name,
            author: WallpaperModel.wallpapers[i].author,
            index: WallpaperModel.wallpapers[i].index,
          ),
        );
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
                onPageChanged: (index, reason) {},
              ),
            ),
          );
        },
      ),
    );
  }
}
