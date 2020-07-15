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
  final String heroTag;
  final String heroTagOther;

  ImageTile(
      {this.url,
      this.name,
      this.author,
      this.index,
      this.heroTag,
      this.heroTagOther});
  @override
  State<StatefulWidget> createState() {
    return _ImageTileState(url: url, name: name, author: author, index: index);
  }
}

class _ImageTileState extends State<ImageTile> {
  final String url;
  final String name;
  final String author;
  final int index;

  _ImageTileState({this.url, this.name, this.author, this.index});

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      var temp = width;
      width = height;
      height = temp;
    }

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: Container(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<FavouriteModel>.value(
                        value: FavouriteModel.providerList[index],
                        child: SetterPage(
                          url: url,
                          name: name,
                          author: author,
                          index: index,
                          heroTag: widget.heroTag,
                          heroTagOther: widget.heroTagOther,
                        ),
                      ),
                    ),
                  );
                },
                child: Image(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          ClipRect(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[
                      Colors.black54,
                      Colors.transparent,
                    ]),
              ),
              width: double.infinity,
              height: height * 0.07,
              child: Container(
                margin: EdgeInsets.fromLTRB(width * 0.03, 0, width * 0.03, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Hero(
                        tag: widget.heroTag,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: height / width * 9,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Consumer<FavouriteModel>(
                      builder: (context, fav, child) => Hero(
                        tag: widget.heroTagOther,
                        child: FavouriteIcon(
                          url: url,
                          icon: fav.icon,
                          press: fav.toggleFavourite,
                          size: height / width * 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
