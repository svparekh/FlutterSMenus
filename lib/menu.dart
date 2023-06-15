import 'package:flutter/material.dart';

import 'menu_item.dart';
import 'routes.dart';

// Default open and closed size if not given

// Size of menu works based on constraints. Here is an overview:
// BoxConstraints(
// // If position is left or right, this is the smallest (closed) menu size
// // Otherwise, this is
//  minWidth: ,
// // If position is left or right, this is the largest (open) menu size
// // Otherwise, this is
//  maxWidth: ,
// // If position is top or bottom, this is the smallest (closed) menu size
// // Otherwise, this is
//  minHeight: ,
// // If position is top or bottom, this is the largest (open) menu size
// // Otherwise, this is
//  maxHeight: ,
// )
class _SMenuSize {
  static const double menuClosedSize = 50;
  static const double menuOpenSize = 250;
}

// Current state of the menu
enum SMenuState { open, closed, opening, closing }

// Position of the menu, so the resize bar and open direction can be known
enum SMenuPosition {
  top,
  bottom,
  left,
  right;

  bool get isVertical =>
      this == SMenuPosition.top || this == SMenuPosition.bottom;
  bool get isHorizontal =>
      this == SMenuPosition.left || this == SMenuPosition.right;
}

// Style of the side menu
class SMenuStyle {
  final BorderRadius? borderRadius;
  final MainAxisAlignment? headerAlignment;
  final EdgeInsets? padding;
  final BoxConstraints? size;

  /// width/height: min = closed, max = open
  final MainAxisAlignment? footerAlignment;
  final MainAxisAlignment? alignment;
  final Color? barColor;
  final Color? backgroundColor;

  const SMenuStyle({
    this.barColor,
    this.backgroundColor,
    this.size,
    this.padding,
    this.borderRadius,
    this.headerAlignment,
    this.footerAlignment,
    this.alignment,
  });
}

// Style of an item inside a menu
class SMenuItemStyle {
  final MainAxisAlignment? mainAxisAlignment;
  final BorderRadius? borderRadius;
  final OutlinedBorder? shape;
  final double? elevation;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? accentColor;
  final Color? selectedAccentColor;
  final Color? bgColor;
  final Color? selectedBgColor;

  const SMenuItemStyle({
    this.borderRadius,
    this.selectedAccentColor,
    this.selectedBgColor,
    this.accentColor,
    this.bgColor,
    this.mainAxisAlignment,
    this.constraints,
    this.height,
    this.width,
    this.elevation,
    this.padding,
    this.shape,
  });
}

class SMenuController {
  late void Function() open;
  late void Function() close;
  late void Function() toggle;
  final ValueNotifier<SMenuState> state =
      ValueNotifier<SMenuState>(SMenuState.closed);
}

abstract class SBaseMenu extends StatefulWidget {
  const SBaseMenu(
      {super.key,
      this.items,
      this.header,
      this.footer,
      this.controller,
      this.style = const SMenuStyle(),
      this.scrollPhysics,
      this.duration = const Duration(milliseconds: 250),
      this.direction = Axis.vertical,
      this.builder,
      this.position = SMenuPosition.left})
      : assert(
          !(builder == null && items == null),
          "FAILED ASSERT - builder | items != null: The menu requires either builder or items arguments to be populated.",
        );
  final SMenuStyle? style;
  final SMenuController? controller;
  final List<SMenuItem>? items;
  final Widget Function(BuildContext context)? builder;
  final Widget? header;
  final Widget? footer;
  final ScrollPhysics? scrollPhysics;
  final Axis? direction;
  final Duration? duration;
  final SMenuPosition? position;

  @override
  State<SBaseMenu> createState() => SBaseMenuState();
}

class SBaseMenuState<T extends SBaseMenu> extends State<T>
    with TickerProviderStateMixin {
  SMenuController controller = SMenuController();
  late final AnimationController _animationController;
  late final Animation _animation;

  void _openMenu() {
    _animationController.forward();
  }

  void _closeMenu() {
    _animationController.reverse();
  }

  void _toggleMenu() {
    if (_animationController.isCompleted) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  @override
  void initState() {
    super.initState();
    // Setup controller
    if (widget.controller != null) {
      controller = widget.controller!;
    }
    controller.open = _openMenu;
    controller.close = _closeMenu;
    controller.toggle = _toggleMenu;

    // Setup animation
    _animationController = AnimationController(
        vsync: this,
        duration: widget.duration ?? const Duration(milliseconds: 250));
    _animation = Tween<double>(
            begin: ((widget.position == SMenuPosition.top ||
                        widget.position == SMenuPosition.bottom)
                    ? widget.style?.size?.minHeight
                    : widget.style?.size?.minWidth) ??
                _SMenuSize.menuClosedSize,
            end: ((widget.position == SMenuPosition.top ||
                        widget.position == SMenuPosition.bottom)
                    ? widget.style?.size?.maxHeight
                    : widget.style?.size?.maxWidth) ??
                _SMenuSize.menuOpenSize)
        .animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.fastOutSlowIn,
            reverseCurve: Curves.fastOutSlowIn));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.state.value = SMenuState.open;
      } else if (status == AnimationStatus.dismissed) {
        controller.state.value = SMenuState.closed;
      } else if (status == AnimationStatus.forward) {
        controller.state.value = SMenuState.opening;
      } else if (status == AnimationStatus.reverse) {
        controller.state.value = SMenuState.closing;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildChild() {
    if (widget.items == null) {
      return widget.builder!(context);
    } else {
      return SingleChildScrollView(
        scrollDirection: widget.direction ?? Axis.vertical,
        child: Flex(
          mainAxisSize: MainAxisSize.min,
          direction: widget.direction ?? Axis.vertical,
          children: widget.items!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class SSlideMenu extends SBaseMenu {
  const SSlideMenu(
      {super.key,
      super.style,
      super.controller,
      super.items,
      super.builder,
      super.header,
      super.footer,
      super.scrollPhysics,
      super.direction,
      super.duration,
      super.position,
      this.body,
      this.enableSelector = false,
      this.barrierColor,
      this.enableGestures,
      this.isBodyMovable = true,
      this.isMenuMovable = true});
  final Widget? body;
  final bool? enableSelector;
  final bool? isMenuMovable;
  final bool? isBodyMovable;

  final bool? enableGestures;
  final Color? barrierColor;

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
          barrierColor = widget.barrierColor ?? Colors.black38;
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

    if (widget.isMenuMovable ?? true) {
      if (widget.position == SMenuPosition.right) {
        dx = MediaQuery.of(context).size.width - _animation.value;
        dy = 0.0;
      } else if (widget.position == SMenuPosition.top) {
        dx = 0.0;
        dy = _animation.value - mSize;
      } else if (widget.position == SMenuPosition.bottom) {
        dx = 0.0;
        dy = MediaQuery.of(context).size.height - _animation.value;
      } else {
        dx = _animation.value - mSize;
        dy = 0.0;
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

    if (widget.isBodyMovable ?? true) {
      if (widget.position == SMenuPosition.right) {
        dx = -_animation.value;
        dy = 0.0;
      } else if (widget.position == SMenuPosition.top) {
        dx = 0.0;
        dy = _animation.value;
      } else if (widget.position == SMenuPosition.bottom) {
        dx = 0.0;
        dy = -_animation.value;
      } else {
        dx = _animation.value;
        dy = 0.0;
      }
    } else {
      dx = 0.0;
      dy = 0.0;
    }

    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    Widget stackChild_1_menu = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: _translateMenu(),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: widget.style?.backgroundColor ??
                Theme.of(context).colorScheme.onPrimary,
            borderRadius: widget.style?.borderRadius),
        padding:
            widget.style?.padding ?? const EdgeInsets.symmetric(horizontal: 5),
        constraints: widget.style?.size ??
            (((widget.position == SMenuPosition.top) ||
                    (widget.position == SMenuPosition.bottom))
                ? const BoxConstraints(minHeight: 0, maxHeight: 250)
                : const BoxConstraints(minWidth: 0, maxWidth: 250)),
        width: (widget.position == SMenuPosition.left ||
                widget.position == SMenuPosition.right)
            ? (widget.style?.size?.maxWidth ?? 250)
            : null,
        height: (widget.position == SMenuPosition.top ||
                widget.position == SMenuPosition.bottom)
            ? (widget.style?.size?.maxHeight ?? 250)
            : null,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          //direction: widget.direction ?? Axis.vertical,
          children: [
            // Header
            if (widget.header != null) widget.header!,
            // Content
            Expanded(
              child: _buildChild(),
            ),
            // Footer
            if (widget.footer != null) widget.footer!,
          ],
        ),
      ),
    );
    Widget stackChild_2_barrier = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: ((widget.isBodyMovable ?? true) &&
                  !(widget.isMenuMovable ?? true))
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
          _toggleMenu();
        },
        child: IgnorePointer(
          ignoring: true,
          child: AnimatedContainer(
            color: barrierColor,
            duration: widget.duration ?? const Duration(milliseconds: 250),
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
    Widget stackChild_3_body = AnimatedBuilder(
      animation: _animationController,
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
    if ((widget.isBodyMovable ?? true) && !(widget.isMenuMovable ?? true)) {
      stackChildren = [
        stackChild_1_menu,
        stackChild_3_body,
        stackChild_2_barrier,
      ];
    } else {
      stackChildren = [
        stackChild_3_body,
        stackChild_2_barrier,
        stackChild_1_menu,
      ];
    }
    return Stack(
      children: stackChildren,
    );
  }
}

class SResizableMenu extends StatelessWidget {
  const SResizableMenu({
    super.key,
    this.menuKey,
    this.style,
    this.controller,
    this.items,
    this.builder,
    this.body,
    this.header,
    this.footer,
    this.scrollPhysics,
    this.direction,
    this.duration,
    this.position,
    this.enableSelector = false,
    this.resizable = true,
    this.barColor,
    this.barHoverColor,
    this.barSize,
    this.barHoverSize,
  });
  final Key? menuKey;
  final SMenuStyle? style;
  final SMenuController? controller;
  final List<SMenuItem>? items;
  final Widget Function(BuildContext context)? builder;
  final Widget? body;
  final Widget? header;
  final Widget? footer;
  final ScrollPhysics? scrollPhysics;
  final Axis? direction;
  final Duration? duration;
  final SMenuPosition? position;
  final bool? enableSelector;
  final bool? resizable;
  final Color? barColor;
  final Color? barHoverColor;
  final double? barSize;
  final double? barHoverSize;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      SResizableMenuNoWrapper(
        enableSelector: enableSelector,
        barHoverColor: barHoverColor,
        scrollPhysics: scrollPhysics,
        barHoverSize: barHoverSize,
        controller: controller,
        direction: direction,
        resizable: resizable,
        duration: duration,
        position: position,
        barColor: barColor,
        barSize: barSize,
        builder: builder,
        footer: footer,
        header: header,
        items: items,
        style: style,
        key: menuKey,
      ),
      Expanded(child: body ?? Container()),
    ];
    return Flex(
      direction:
          (position?.isVertical ?? true) ? Axis.vertical : Axis.horizontal,
      children:
          (position == SMenuPosition.right || position == SMenuPosition.bottom)
              ? children.reversed.toList()
              : children,
    );
  }
}

class SResizableMenuNoWrapper extends SBaseMenu {
  const SResizableMenuNoWrapper({
    super.key,
    super.style,
    super.controller,
    super.items,
    super.builder,
    super.header,
    super.footer,
    super.scrollPhysics,
    super.direction,
    super.duration,
    super.position,
    this.enableSelector = false,
    this.resizable = true,
    this.barColor,
    this.barHoverColor,
    this.barSize,
    this.barHoverSize,
  });
  final bool? enableSelector;
  final bool? resizable;
  final Color? barColor;
  final Color? barHoverColor;
  final double? barSize;
  final double? barHoverSize;

  @override
  State<SResizableMenuNoWrapper> createState() =>
      _SResizableMenuNoWrapperState();
}

class _SResizableMenuNoWrapperState
    extends SBaseMenuState<SResizableMenuNoWrapper> {
  int selectedIndex = 0;
  double? resizedSize;

  // @override
  // void _openMenu() {
  //   _animationController.forward(from: resizedSize);
  // }

  // @override
  // void _closeMenu() {
  //   _animationController.reverse(from: resizedSize);
  // }

  @override
  Widget build(BuildContext context) {
    // For selection bar
    if (widget.items != null) {
      for (var item in widget.items!) {
        if (item is SMenuItemButton && item.isSelected == true) {
          selectedIndex = widget.items!.indexOf(item);
          break;
        }
      }
    }

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

    return Stack(
      alignment: align,
      children: [
        Padding(
          // Add 3 padding for resize bar
          padding: (widget.resizable ?? true)
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
            animation: _animationController,
            builder: (context, child) {
              return SizedBox(
                width: (widget.position == SMenuPosition.left ||
                        widget.position == SMenuPosition.right)
                    ? (resizedSize ?? _animation.value)
                    : null,
                height: (widget.position == SMenuPosition.top ||
                        widget.position == SMenuPosition.bottom)
                    ? (resizedSize ?? _animation.value)
                    : null,
                child: child,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: widget.style?.backgroundColor ??
                      Theme.of(context).colorScheme.onPrimary,
                  borderRadius: widget.style?.borderRadius),
              padding: widget.style?.padding ??
                  const EdgeInsets.symmetric(horizontal: 5),
              constraints: widget.style?.size ??
                  (((widget.position == SMenuPosition.top) ||
                          (widget.position == SMenuPosition.bottom))
                      ? const BoxConstraints(minHeight: 50, maxHeight: 250)
                      : const BoxConstraints(minWidth: 50, maxWidth: 250)),
              child: Column(
                children: [
                  // Header
                  if (widget.header != null) widget.header!,
                  // Menu
                  Expanded(
                    child: Stack(
                      children: [
                        _buildChild(),
                        // Moving bar to indicate page number
                        if (widget.items != null &&
                            widget.items!.isNotEmpty &&
                            (widget.enableSelector ?? false))
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: EdgeInsets.only(
                                left: 1, top: 15 + (selectedIndex * 50)),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: widget.style?.barColor ??
                                      Theme.of(context).colorScheme.onPrimary),
                              height: 25,
                              width: 5,
                            ),
                          )
                      ],
                    ),
                  ),
                  // Footer
                  if (widget.footer != null) widget.footer!,
                ],
              ),
            ),
          ),
        ),
        if (widget.position != null && (widget.resizable ?? true))
          _ResizeBar(
            onDragStart: (details) {},
            onDragEnd: (details) {
              resizedSize = null;
            },
            onDragUpdate: (details) {
              double normalizedSize;

              double closedSize = ((widget.position == SMenuPosition.top ||
                          widget.position == SMenuPosition.bottom)
                      ? widget.style?.size?.minHeight
                      : widget.style?.size?.minWidth) ??
                  _SMenuSize.menuClosedSize;
              double openSize = ((widget.position == SMenuPosition.top ||
                          widget.position == SMenuPosition.bottom)
                      ? widget.style?.size?.maxHeight
                      : widget.style?.size?.maxWidth) ??
                  _SMenuSize.menuOpenSize;

              // Set normalized size to current size (from 0 to 1)
              normalizedSize =
                  (((resizedSize == null) ? null : (resizedSize! / openSize)) ??
                      _animationController.value);
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
                _animationController.value = normalizedSize;
              });
            },
            position: widget.position!,
            controller: controller,
            color: widget.barColor ?? const Color.fromARGB(255, 211, 211, 211),
            hoverColor:
                widget.barHoverColor ?? const Color.fromARGB(134, 33, 149, 243),
            hoverSize: widget.barHoverSize ?? 5,
            size: widget.barHoverSize ?? 3,
          ),
      ],
    );
  }
}

class _ResizeBar extends StatefulWidget {
  const _ResizeBar({
    required this.onDragUpdate,
    required this.onDragStart,
    required this.onDragEnd,
    required this.controller,
    required this.position,
    required this.color,
    required this.hoverColor,
    required this.hoverSize,
    required this.size,
  });
  final void Function(DragUpdateDetails size) onDragUpdate;
  final void Function(DragStartDetails details) onDragStart;
  final void Function(DragEndDetails details) onDragEnd;
  final SMenuController controller;
  final SMenuPosition position;
  final Color color;
  final Color hoverColor;
  final double size;
  final double hoverSize;

  @override
  State<_ResizeBar> createState() => _ResizeBarState();
}

class _ResizeBarState extends State<_ResizeBar> {
  bool isHover = false;
  late bool vert;

  @override
  void initState() {
    switch (widget.position) {
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
