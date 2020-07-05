import 'package:flutter/material.dart';

import 'package:simple_animations/simple_animations.dart';

import 'package:supercharged/supercharged.dart';

enum Properties { opacity, offset }

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeIn(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<Properties>()
      ..add(Properties.opacity, (0.8).tweenTo(1.0),
          (100 * delay).round().milliseconds)
      ..add(Properties.offset, (50.0).tweenTo(0.0), 200.milliseconds);

    return PlayAnimation<MultiTweenValues<Properties>>(
      duration: Duration(milliseconds: (125 * delay).round()),
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(Properties.opacity),
        child: Transform.translate(
          offset: Offset(
            0,
            value.get(Properties.offset),
          ),
          child: child,
        ),
      ),
    );
  }
}

class Pop extends StatelessWidget {
  final Widget child;

  Pop(this.child);

  @override
  Widget build(BuildContext context) {
    final tween = (0.8).tweenTo(1.0);

    return PlayAnimation(
      duration: 200.milliseconds,
      tween: tween,
      curve: Curves.ease,
      child: child,
      builder: (context, child, value) => Transform.scale(
        scale: value,
        child: child,
      ),
    );
  }
}
