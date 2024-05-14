import 'package:flutter/material.dart';

import 'base.dart';
import 'helper.dart';

/// This file contains the classes that implement menus.
/// The menus include [SSlideMenu] and [SResizableMenu].
///
/// Abstract classes from which the menus are derived and custom classes
/// that the menus use can be found in the base.dart file:
/// [SBaseMenu] w/ [SBaseMenuState]
/// [SMenuState]
/// [SMenuStyle]
/// [SMenuController]
///
/// Private classes include
/// [_SSlideMenuState] (for [SSlideMenu])
/// [_SResizableMenuState] (for [SResizableMenu])

// TODO: Add builder to menus
class SSlideMenu extends SBaseMenu {
  const SSlideMenu({
    super.key,
    super.style,
    super.controller,
    required super.items,
    super.builder,
    super.header,
    super.footer,
    super.scrollPhysics,
    super.scrollDirection,
    super.duration,
    super.position,
    super.closedSize,
    super.openSize,
    this.offset = Offset.zero,
    this.isBodyMovable = true,
    this.isMenuMovable = true,
    this.body,
    this.enableGestures,
  });
  final bool isMenuMovable;
  final bool isBodyMovable;
  final Offset offset;
  final Widget? body; // TODO: move this to BaseMenu or even Base?
  final bool? enableGestures;

  @override
  State<SSlideMenu> createState() => _SSlideMenuState();
}

class _SSlideMenuState extends SBaseMenuState<SSlideMenu> {
  Color barrierColor = Colors.transparent;
  HitTestBehavior barrierBehavior = HitTestBehavior.deferToChild;

  @override
  void initState() {
    super.initState();

    controller.state.addListener(() {
      if (controller.state.value == SMenuState.opening) {
        setState(() {
          barrierColor = widget.style.barrierColor;
          barrierBehavior = HitTestBehavior.translucent;
        });
      } else if (controller.state.value == SMenuState.closing) {
        setState(() {
          barrierColor = Colors.transparent;
          barrierBehavior = HitTestBehavior.deferToChild;
        });
      }
    });
  }

  Offset _translateMenu() {
    double dx = 0.0;
    double dy = 0.0;
    double mSize = 250.0;

    if (widget.isMenuMovable) {
      if (widget.position == SMenuPosition.right) {
        dx = MediaQuery.of(context).size.width - animation.value;
        dy = widget.offset.dy;
      } else if (widget.position == SMenuPosition.top) {
        dx = widget.offset.dx;
        dy = animation.value - mSize;
      } else if (widget.position == SMenuPosition.bottom) {
        dx = widget.offset.dx;
        dy = MediaQuery.of(context).size.height - animation.value;
      } else {
        dx = animation.value - mSize;
        dy = widget.offset.dy;
      }
    } else {
      dx = 0.0;
      dy = 0.0;
    }
    return Offset(dx, dy);
  }

  Offset _translateChild() {
    double dx = 0.0;
    double dy = 0.0;

    if (widget.isBodyMovable) {
      if (widget.position == SMenuPosition.right) {
        dx = -animation.value;
        dy = widget.offset.dy;
      } else if (widget.position == SMenuPosition.top) {
        dx = widget.offset.dx;
        dy = animation.value;
      } else if (widget.position == SMenuPosition.bottom) {
        dx = widget.offset.dx;
        dy = -animation.value;
      } else {
        dx = animation.value;
        dy = widget.offset.dy;
      }
    } else {
      dx = 0.0;
      dy = 0.0;
    }

    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    Widget stackChild_menu = AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: _translateMenu(),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: widget.style.backgroundColor ??
                Theme.of(context).colorScheme.background,
            borderRadius: widget.style.borderRadius,
            border: widget.style.border),
        padding:
            widget.style.padding ?? const EdgeInsets.symmetric(horizontal: 5),
        constraints: (widget.position.isVertical
            ? BoxConstraints(
                minHeight: widget.closedSize, maxHeight: widget.openSize)
            : BoxConstraints(
                minWidth: widget.closedSize, maxWidth: widget.openSize)),
        width: (widget.position == SMenuPosition.left ||
                widget.position == SMenuPosition.right)
            ? widget.openSize
            : null,
        height: (widget.position == SMenuPosition.top ||
                widget.position == SMenuPosition.bottom)
            ? widget.openSize
            : null,
        child: buildMenu(),
      ),
    );
    // ignore: non_constant_identifier_names
    Widget stackChild_barrier = AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: (widget.isBodyMovable && !widget.isMenuMovable)
              ? _translateChild()
              : const Offset(0, 0),
          child: child,
        );
      },
      child: GestureDetector(
        behavior: barrierBehavior,
        onHorizontalDragUpdate: (details) {},
        onHorizontalDragStart: (details) {},
        onHorizontalDragDown: (details) {},
        onVerticalDragUpdate: (details) {},
        onVerticalDragStart: (details) {},
        onVerticalDragDown: (details) {},
        onTap: () {
          toggleMenu();
        },
        child: IgnorePointer(
          ignoring: true,
          child: AnimatedContainer(
            color: barrierColor,
            duration: widget.duration,
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
    // ignore: non_constant_identifier_names
    Widget stackChild_body = AnimatedBuilder(
      animation: animationController,
      builder: (_, child) {
        return Transform.translate(
          offset: _translateChild(),
          child: child,
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(child: widget.body ?? Container()),
          ],
        ),
      ),
    );

    List<Widget> stackChildren = <Widget>[];
    if (widget.isBodyMovable && !widget.isMenuMovable) {
      stackChildren = [
        stackChild_menu,
        stackChild_body,
        stackChild_barrier,
      ];
    } else {
      stackChildren = [
        stackChild_body,
        stackChild_barrier,
        stackChild_menu,
      ];
    }
    return Stack(
      children: stackChildren,
    );
  }
}

class SResizableMenu extends SBaseMenu {
  const SResizableMenu({
    super.key,
    super.style,
    super.controller,
    required super.items,
    super.builder,
    super.header,
    super.footer,
    super.scrollPhysics,
    super.scrollDirection,
    super.duration,
    super.position,
    super.closedSize,
    super.openSize,
    this.resizable = true,
    this.barColor,
    this.barHoverColor,
    this.barSize,
    this.barHoverSize,
    this.enableWrapper = true,
    this.body,
  });
  final bool resizable;

  final Color? barColor; // Move to style
  final Color? barHoverColor;
  final double? barSize;
  final double? barHoverSize;
  final Widget? body;

  /// If true, uses a Flex widget and Expanded widget to create a wrapper
  /// for the menu, this enables out-the-box usage of the menu. For more specific
  /// tasks, disable this setting and create your own wrapper around this widget.
  final bool enableWrapper;

  @override
  State<SResizableMenu> createState() => _SResizableMenuState();
}

class _SResizableMenuState extends SBaseMenuState<SResizableMenu> {
  double? resizedSize;

  @override
  Widget build(BuildContext context) {
    // Align the resize bar to left right top bottom based on position
    // The alignment of the resize bar is opposite that of the position
    AlignmentDirectional align;
    if (widget.position == SMenuPosition.top) {
      align = AlignmentDirectional.bottomCenter;
    } else if (widget.position == SMenuPosition.right) {
      align = AlignmentDirectional.centerStart;
    } else if (widget.position == SMenuPosition.bottom) {
      align = AlignmentDirectional.topCenter;
    } else {
      align = AlignmentDirectional.centerEnd;
    }

    // Create the menu
    final Widget menuWidget = Stack(
      alignment: align,
      children: [
        Padding(
          // Add 3 padding for resize bar
          padding: widget.resizable
              ? EdgeInsets.only(
                  right: widget.position == SMenuPosition.left
                      ? (widget.barSize ?? 3)
                      : 0,
                  left: widget.position == SMenuPosition.right
                      ? (widget.barSize ?? 3)
                      : 0,
                  top: widget.position == SMenuPosition.bottom
                      ? (widget.barSize ?? 3)
                      : 0,
                  bottom: widget.position == SMenuPosition.top
                      ? (widget.barSize ?? 3)
                      : 0)
              : EdgeInsets.zero,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return SizedBox(
                width: (widget.position == SMenuPosition.left ||
                        widget.position == SMenuPosition.right)
                    ? (resizedSize ?? animation.value)
                    : null,
                height: (widget.position == SMenuPosition.top ||
                        widget.position == SMenuPosition.bottom)
                    ? (resizedSize ?? animation.value)
                    : null,
                child: child,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: widget.style.backgroundColor ??
                      Theme.of(context).colorScheme.background,
                  borderRadius: widget.style.borderRadius,
                  border: widget.style.border),
              padding: widget.style.padding ??
                  const EdgeInsets.symmetric(horizontal: 5),
              constraints: (widget.position.isVertical
                  ? BoxConstraints(
                      minHeight: widget.closedSize, maxHeight: widget.openSize)
                  : BoxConstraints(
                      minWidth: widget.closedSize, maxWidth: widget.openSize)),
              child: buildMenu(),
            ),
          ),
        ),
        if (widget.resizable)
          ResizeBar(
            onDragStart: (details) {},
            onDragEnd: (details) {
              resizedSize = null;
            },
            onDragUpdate: (details) {
              double normalizedSize;

              double closedSize = widget.closedSize;
              double openSize = widget.openSize;

              // Set normalized size to current size (from 0 to 1)
              normalizedSize =
                  (((resizedSize == null) ? null : (resizedSize! / openSize)) ??
                      animationController.value);
              // Add the normalized delta in mouse movement to the size (from 0 to 1)
              // Change to negative (flipped) if right or bottom position
              // This is so mouse movement reflects movement of the menu
              switch (widget.position) {
                case SMenuPosition.top:
                  normalizedSize += (details.delta.dy / openSize);
                  break;
                case SMenuPosition.bottom:
                  normalizedSize += -(details.delta.dy / openSize);
                  break;
                case SMenuPosition.right:
                  normalizedSize += -(details.delta.dx / openSize);
                  break;
                case SMenuPosition.left:
                default:
                  normalizedSize += (details.delta.dx / openSize);
              }

              // Clamp size to min size and max size
              normalizedSize = normalizedSize.clamp(closedSize / openSize, 1.0);

              setState(() {
                resizedSize = normalizedSize * openSize;
                animationController.value = normalizedSize;
              });
            },
            direction: widget.position,
            controller: controller,
            color: widget.barColor ?? const Color.fromARGB(255, 211, 211, 211),
            hoverColor:
                widget.barHoverColor ?? const Color.fromARGB(134, 33, 149, 243),
            hoverSize: widget.barHoverSize ?? 5,
            size: widget.barHoverSize ?? 3,
          ),
      ],
    );

    // If wrapper is enabled
    if (widget.enableWrapper) {
      final List<Widget> children = [
        menuWidget,
        Expanded(child: widget.body ?? Container()),
      ];
      return Flex(
        direction: widget.position.isVertical ? Axis.vertical : Axis.horizontal,
        children: (widget.position == SMenuPosition.right ||
                widget.position == SMenuPosition.bottom)
            ? children.reversed.toList()
            : children,
      );
    }
    // Otherwise just return the menu
    return menuWidget;
  }
}
