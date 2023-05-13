import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum SlideDirection { left, right, up, down }

class SlidePageRoute<T> extends PageRoute<T> {
  /// {@macro hero_dialog_route}
  SlidePageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    super.fullscreenDialog,
    this.direction,
  })  : _builder = builder,
        super(settings: settings);

  final WidgetBuilder _builder;
  final SlideDirection? direction;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Offset begin = const Offset(1.0, 0.0);
    Offset end = Offset.zero;
    switch (direction) {
      case SlideDirection.up:
        begin = const Offset(0.0, 1.0);
        end = Offset.zero;
        break;
      case SlideDirection.down:
        begin = const Offset(0.0, -1.0);
        end = Offset.zero;
        break;
      case SlideDirection.left:
        begin = const Offset(1.0, 0.0);
        end = Offset.zero;
        break;
      case SlideDirection.right:
        begin = const Offset(-1.0, 0.0);
        end = Offset.zero;
        break;
      default:
        begin = const Offset(1.0, 0.0);
        end = Offset.zero;
    }

    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
    // return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}

class BottomUpPageRoute<T> extends PageRoute<T> {
  /// {@macro hero_dialog_route}
  BottomUpPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = true,
  })  : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
    // return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}

class CustomHero extends StatelessWidget {
  const CustomHero(
      {Key? key, this.child = const Material(), this.tag = 0, this.color})
      : super(key: key);
  final Widget child;
  final Color? color;
  final Object tag;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Colors.transparent,
      child: Hero(
        tag: tag,
        child: child,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin, end: end);
        },
      ),
    );
  }
}

class CustomRectTween extends RectTween {
  /// {@macro custom_rect_tween}
  CustomRectTween({
    @required Rect? begin,
    @required Rect? end,
  }) : super(begin: begin, end: end);

  @override
  Rect? lerp(double t) {
    final double elasticCurveValue = Curves.easeInOutCubic.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin!.left, end!.left, elasticCurveValue)!,
      lerpDouble(begin!.top, end!.top, elasticCurveValue)!,
      lerpDouble(begin!.right, end!.right, elasticCurveValue)!,
      lerpDouble(begin!.bottom, end!.bottom, elasticCurveValue)!,
    );
  }
}

class SPopupMenuRoute<T> extends PageRoute<T> {
  /// {@macro hero_dialog_route}
  SPopupMenuRoute(
      {required WidgetBuilder builder,
      RouteSettings? settings,
      bool fullscreenDialog = false,
      this.animDuration,
      this.bgColor,
      this.dismissable})
      : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;
  final Duration? animDuration;
  final Color? bgColor;
  final bool? dismissable;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => dismissable ?? true;

  @override
  Duration get transitionDuration =>
      animDuration ?? const Duration(milliseconds: 500);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => bgColor ?? Colors.black12;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}
