import 'package:flutter/material.dart';

class FavouriteIcon extends StatelessWidget {
  final String url;
  final IconData icon;
  final Function press;
  final double size;

  FavouriteIcon({this.url, this.icon, this.press, this.size});

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Icon(
        icon,
        color: Colors.white,
        size: size,
      ),
    );
  }
}
