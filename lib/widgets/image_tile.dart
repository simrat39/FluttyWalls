import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import '../models/FavouriteModel.dart';

import '../pages/setter.dart';

import '../widgets/favourites_icon.dart';

import 'dart:ui';

class ImageTile extends StatefulWidget {
  final String url;
  final String name;
  final String author;
  final int index;
  final String heroTagName;
  final String heroTagHeart;
  final String heroTagImage;

  ImageTile(
      {this.url,
      this.name,
      this.author,
      this.index,
      this.heroTagName,
      this.heroTagHeart,
      this.heroTagImage});
  @override
  State<StatefulWidget> createState() {
    return _ImageTileState();
  }
}

class _ImageTileState extends State<ImageTile> {
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      var temp = width;
      width = height;
      height = temp;
    }

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Hero(
            tag: widget.heroTagImage,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              child: Container(
                width: double.infinity,
                child: Image(
                  image: NetworkImage(widget.url),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
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
                        value: FavouriteModel.providerList[widget.index],
                        child: SetterPage(
                          url: widget.url,
                          name: widget.name,
                          author: widget.author,
                          index: widget.index,
                          heroTagName: widget.heroTagName,
                          heroTagHeart: widget.heroTagHeart,
                          heroTagImage: widget.heroTagImage,
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
              ),
            ),
          ),
          ClipRect(
            child: Container(
              // color: Color(0xff121217).withOpacity(0.7),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xff121217).withOpacity(0.7),
                    Color(0xff121217).withOpacity(0.35),
                    Color(0xff121217).withOpacity(0.0),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              width: double.infinity,
              height: height * 0.07,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Hero(
                          tag: widget.heroTagName,
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              widget.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.02,
                        ),
                        child: Consumer<FavouriteModel>(
                          builder: (context, fav, child) => Hero(
                            tag: widget.heroTagHeart,
                            child: FavouriteIcon(
                              url: widget.url,
                              icon: fav.icon,
                              press: fav.toggleFavourite,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
