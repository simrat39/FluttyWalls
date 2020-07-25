import 'package:flutter/material.dart';
import 'dart:ui';

class CollectionCard extends StatefulWidget {
  final String name;
  final String thumbUrl;
  final Function onTap;

  CollectionCard({this.name, this.thumbUrl, this.onTap});
  @override
  State<StatefulWidget> createState() {
    return _CollectionCardState();
  }
}

class _CollectionCardState extends State<CollectionCard> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: height * 0.005,
        horizontal: height * 0.01,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.network(
              widget.thumbUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: height * 0.3,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: height * 0.3,
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
            Container(
              color: Colors.black.withOpacity(0.6),
              height: height * 0.3,
            ),
            Hero(
              tag: widget.name + "nameHeroT",
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 60.0,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: height * 0.3,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
