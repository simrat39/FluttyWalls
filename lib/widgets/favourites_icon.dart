import 'package:flutter/material.dart';
import '../widgets/FadeIn.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class FavouriteIcon extends StatefulWidget {
  final String url;
  final IconData icon;
  final Function press;
  final double size;

  FavouriteIcon({this.url, this.icon, this.press, this.size});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FavouriteIconState();
  }
}

class _FavouriteIconState extends State<FavouriteIcon> with AnimationMixin {
  AnimationController scaleController;
  Animation<double> scale;

  @override
  void initState() {
    super.initState();
    scaleController = createController();
    scale = Tween(
      begin: 1.0,
      end: 1.3,
    ).animate(
      CurvedAnimation(
        parent: scaleController,
        curve: Curves.elasticIn,
      ),
    );
  }

  void heartBeat() {
    scaleController
        .play(
      duration: 100.milliseconds,
    )
        .whenComplete(() {
      scaleController.reverse().whenComplete(() {
        scaleController.reverse();
      });
    });
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.press();
        heartBeat();
      },
      child: Transform.scale(
        scale: scale.value,
        child: Icon(
          widget.icon,
          color: Colors.white,
          size: widget.size,
        ),
      ),
    );
  }
}
