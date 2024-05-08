import 'dart:ui';
import 'package:flutter/material.dart';

import 'base.dart';
import 'menu_item.dart';

class ResizeBar extends StatefulWidget {
  const ResizeBar({
    super.key,
    required this.onDragUpdate,
    required this.onDragStart,
    required this.onDragEnd,
    required this.controller,
    required this.direction,
    required this.color,
    required this.hoverColor,
    required this.hoverSize,
    required this.size,
  });
  final void Function(DragUpdateDetails size) onDragUpdate;
  final void Function(DragStartDetails details) onDragStart;
  final void Function(DragEndDetails details) onDragEnd;
  final SMenuController controller;
  final SMenuPosition direction;
  final Color color;
  final Color hoverColor;
  final double size;
  final double hoverSize;

  @override
  State<ResizeBar> createState() => _ResizeBarState();
}

class _ResizeBarState extends State<ResizeBar> {
  bool isHover = false;
  late bool vert;

  @override
  void initState() {
    switch (widget.direction) {
      case SMenuPosition.bottom:
      case SMenuPosition.top:
        vert = false;
        break;
      case SMenuPosition.left:
      case SMenuPosition.right:
        vert = true;
        break;
      default:
        vert = true;
    }
    super.initState();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    widget.onDragUpdate(details);
  }

  void _onDragStart(DragStartDetails details) {
    widget.onDragStart(details);
  }

  void _onDragEnd(DragEndDetails details) {
    widget.onDragEnd(details);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
          color: isHover ? widget.hoverColor : widget.color,
          borderRadius: BorderRadius.circular(widget.size / 2)),
      duration: const Duration(milliseconds: 250),
      height: vert ? null : (isHover ? widget.hoverSize : widget.size),
      width: vert ? (isHover ? widget.hoverSize : widget.size) : null,
      child: MouseRegion(
        cursor: vert
            ? SystemMouseCursors.resizeLeftRight
            : SystemMouseCursors.resizeUpDown,
        onEnter: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: GestureDetector(
          onVerticalDragUpdate: (details) => _onDragUpdate(details),
          onVerticalDragStart: (details) => _onDragStart(details),
          onVerticalDragEnd: (details) => _onDragEnd(details),
          onHorizontalDragUpdate: (details) => _onDragUpdate(details),
          onHorizontalDragStart: (details) => _onDragStart(details),
          onHorizontalDragEnd: (details) => _onDragEnd(details),
          onTap: () {
            widget.controller.toggle();
          },
        ),
      ),
    );
  }
}

class SDropdownMenuPopup<T> extends StatelessWidget {
  final Object tag;
  final List<SMenuItem<T>> items;
  final SDropdownMenuStyle style;
  final SMenuController? controller;
  final Widget? header;
  final Widget? footer;
  final Offset position;
  final double? width; // TODO: implement width and height
  final double? height;

  const SDropdownMenuPopup({
    super.key,
    required this.tag,
    required this.items,
    required this.position,
    this.controller,
    this.header,
    this.footer,
    required this.style,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          width: width ?? 250,
          child: CustomHero(
            tag: tag,
            child: Container(
              decoration: BoxDecoration(
                  border: style.border,
                  borderRadius: style.borderRadius,
                  color: style.color ?? Colors.transparent),
              constraints: style.constraints ??
                  BoxConstraints(
                      maxHeight: height ?? 350,
                      maxWidth: width ?? 250,
                      minHeight: height ?? 10),
              child: SizedBox(
                height: height ?? 350,
                child: ListView(
                  // padding: style?.padding ?? EdgeInsets.zero,
                  // shrinkWrap: true,
                  children: items.asMap().entries.map((element) {
                    final SMenuItem item = element.value;
                    // Add a button effect is this item has a value
                    if (item.value == null) {
                      return item;
                    }
                    if (item.onPressed != null) {
                      return item;
                    }

                    return Material(
                      shape: item.style.shape ??
                          RoundedRectangleBorder(
                              borderRadius: item.style.borderRadius),
                      // borderRadius: item.style.borderRadius ??
                      //     BorderRadius.circular(15),
                      color: item.style.bgColor ??
                          Theme.of(context).colorScheme.onPrimary,
                      child: InkWell(
                        borderRadius: item.style.borderRadius,
                        onTap: () {
                          if (item.value != null) {
                            Navigator.pop(context, MapEntry(element.key, item));
                          }
                        },
                        child: item,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
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

// TODO: what is this tween and can it be changed to a curve?
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
