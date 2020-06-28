import 'package:flutter/material.dart';

import 'package:simple_animations/simple_animations.dart';

import 'package:supercharged/supercharged.dart';

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeIn(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = (0.0).tweenTo(1.0);

    return PlayAnimation(
      duration: Duration(milliseconds: (125 * delay).round()),
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value,
        child: child,
      ),
    );
  }
}
