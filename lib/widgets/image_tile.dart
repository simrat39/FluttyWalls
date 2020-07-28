import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import '../models/FavouriteModel.dart';

import '../pages/SetterPage.dart';

import '../widgets/favourites_icon.dart';

import 'dart:ui';

class ImageTile extends StatelessWidget {
  final String url;
  final String name;
  final String author;
  final int index;

  ImageTile({
    this.url,
    this.name,
    this.author,
    this.index,
  });

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
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            child: Container(
              width: double.infinity,
              child: Image.network(
                url,
                cacheWidth: 630,
                cacheHeight: 1120,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: Transform.scale(
                      scale: 0.6,
                      child: CircularProgressIndicator(
                        strokeWidth: 6.0,
                        value: progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes,
                      ),
                    ),
                  );
                },
                fit: BoxFit.cover,
                alignment: Alignment.center,
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
                        value: FavouriteModel.providerList[index],
                        child: SetterPage(
                          url: url,
                          name: name,
                          author: author,
                          index: index,
                          heroTagImage: "we dont want to hero",
                        ),
                      ),
                      transitionsBuilder: (context, anim, secondAnim, child) {
                        var tween = Tween(
                          begin: Offset(1.0, 0.0),
                          end: Offset.zero,
                        );
                        var curvedAnimation = CurvedAnimation(
                          parent: anim,
                          curve: Curves.ease,
                        );
                        return SlideTransition(
                          position: tween.animate(curvedAnimation),
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
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.02,
                        ),
                        child: Consumer<FavouriteModel>(
                          builder: (context, fav, child) => FavouriteIcon(
                            url: url,
                            icon: fav.icon,
                            press: fav.toggleFavourite,
                            size: 20,
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
