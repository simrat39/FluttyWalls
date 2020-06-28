// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.8

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

const double _kScrollbarThickness = 4.0;
const Duration _kScrollbarFadeDuration = Duration(milliseconds: 300);
const Duration _kScrollbarTimeToFade = Duration(milliseconds: 600);

/// A material design scrollbar.
///
/// A scrollbar indicates which portion of a [Scrollable] widget is actually
/// visible.
///
/// Dynamically changes to an iOS style scrollbar that looks like
/// [CupertinoScrollbar] on the iOS platform.
///
/// To add a scrollbar to a [ScrollView], simply wrap the scroll view widget in
/// a [Scrollbar] widget.
///
/// See also:
///
///  * [ListView], which display a linear, scrollable list of children.
///  * [GridView], which display a 2 dimensional, scrollable array of children.
class AccentedScrollbar extends StatefulWidget {
  final Color highlightColor;

  /// Creates a material design scrollbar that wraps the given [child].
  ///
  /// The [child] should be a source of [ScrollNotification] notifications,
  /// typically a [Scrollable] widget.
  const AccentedScrollbar({
    Key key,
    @required this.child,
    this.controller,
    this.isAlwaysShown = false,
    this.highlightColor,
  })  : assert(!isAlwaysShown || controller != null,
            'When isAlwaysShown is true, must pass a controller that is attached to a scroll view'),
        super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// The scrollbar will be stacked on top of this child. This child (and its
  /// subtree) should include a source of [ScrollNotification] notifications.
  ///
  /// Typically a [ListView] or [CustomScrollView].
  final Widget child;

  /// {@macro flutter.cupertino.cupertinoScrollbar.controller}
  final ScrollController controller;

  /// {@macro flutter.cupertino.cupertinoScrollbar.isAlwaysShown}
  final bool isAlwaysShown;

  @override
  _AccentedScrollbarState createState() =>
      _AccentedScrollbarState(highlightColor);
}

class _AccentedScrollbarState extends State<AccentedScrollbar>
    with TickerProviderStateMixin {
  ScrollbarPainter _materialPainter;
  TextDirection _textDirection;
  Color _themeColor;
  bool _useCupertinoScrollbar;
  AnimationController _fadeoutAnimationController;
  Animation<double> _fadeoutOpacityAnimation;
  Timer _fadeoutTimer;

  final Color highlightColor;

  _AccentedScrollbarState(this.highlightColor);

  @override
  void initState() {
    super.initState();
    _fadeoutAnimationController = AnimationController(
      vsync: this,
      duration: _kScrollbarFadeDuration,
    );
    _fadeoutOpacityAnimation = CurvedAnimation(
      parent: _fadeoutAnimationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert((() {
      _useCupertinoScrollbar = null;
      return true;
    })());
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        // On iOS, stop all local animations. CupertinoScrollbar has its own
        // animations.
        _fadeoutTimer?.cancel();
        _fadeoutTimer = null;
        _fadeoutAnimationController.reset();
        _useCupertinoScrollbar = true;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        _themeColor = highlightColor.withOpacity(1.0);
        _textDirection = Directionality.of(context);
        _materialPainter = _buildMaterialScrollbarPainter();
        _useCupertinoScrollbar = false;
        _triggerScrollbar();
        break;
    }
    assert(_useCupertinoScrollbar != null);
  }

  @override
  void didUpdateWidget(AccentedScrollbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAlwaysShown != oldWidget.isAlwaysShown) {
      if (widget.isAlwaysShown == false) {
        _fadeoutAnimationController.reverse();
      } else {
        _triggerScrollbar();
        _fadeoutAnimationController.animateTo(1.0);
      }
    }
  }

  // Wait one frame and cause an empty scroll event.  This allows the thumb to
  // show immediately when isAlwaysShown is true.  A scroll event is required in
  // order to paint the thumb.
  void _triggerScrollbar() {
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      if (widget.isAlwaysShown) {
        _fadeoutTimer?.cancel();
        widget.controller.position.didUpdateScrollPositionBy(0);
      }
    });
  }

  ScrollbarPainter _buildMaterialScrollbarPainter() {
    return ScrollbarPainter(
      radius: Radius.circular(20.0),
      color: _themeColor,
      textDirection: _textDirection,
      thickness: _kScrollbarThickness,
      fadeoutOpacityAnimation: _fadeoutOpacityAnimation,
      padding: MediaQuery.of(context).padding,
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    final ScrollMetrics metrics = notification.metrics;
    if (metrics.maxScrollExtent <= metrics.minScrollExtent) {
      return false;
    }

    // iOS sub-delegates to the CupertinoScrollbar instead and doesn't handle
    // scroll notifications here.
    if (!_useCupertinoScrollbar &&
        (notification is ScrollUpdateNotification ||
            notification is OverscrollNotification)) {
      if (_fadeoutAnimationController.status != AnimationStatus.forward) {
        _fadeoutAnimationController.forward();
      }

      _materialPainter.update(
        notification.metrics,
        notification.metrics.axisDirection,
      );
      if (!widget.isAlwaysShown) {
        _fadeoutTimer?.cancel();
        _fadeoutTimer = Timer(_kScrollbarTimeToFade, () {
          _fadeoutAnimationController.reverse();
          _fadeoutTimer = null;
        });
      }
    }
    return false;
  }

  @override
  void dispose() {
    _fadeoutAnimationController.dispose();
    _fadeoutTimer?.cancel();
    _materialPainter?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_useCupertinoScrollbar) {
      return CupertinoScrollbar(
        child: widget.child,
        isAlwaysShown: widget.isAlwaysShown,
        controller: widget.controller,
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: RepaintBoundary(
        child: CustomPaint(
          foregroundPainter: _materialPainter,
          child: RepaintBoundary(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
