import 'package:flutter/material.dart';

import 'menu.dart';
import 'menu_item.dart';
import 'routes.dart';

class SMenuItemDropdown<T> extends SMenuItem {
  const SMenuItemDropdown({
    Key? key,
    required T value,
    SMenuItemStyle? style,
    this.leading,
    this.title,
    this.trailing,
    this.onPressed,
  }) : super(
          key: key,
          value: value,
          style: style,
        );
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final void Function()?
      onPressed; // Leave null if this item is to be used in onChange of dropdown menu

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: style?.width,
      height: style?.height,
      child: Padding(
        padding: style?.padding ?? const EdgeInsets.all(5.0),
        child: Row(
          children: [
            leading ?? const SizedBox.square(dimension: 10),
            Expanded(child: title ?? Container()),
            trailing ?? const SizedBox.square(dimension: 10)
          ],
        ),
      ),
    );
  }
}

class SMenuItemDropdownSelectable extends SMenuItem {
  const SMenuItemDropdownSelectable({
    super.key,
    super.value,
    this.onPressed,
    this.leading,
    this.title,
    this.trailing,
  });
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 40,
      margin: const EdgeInsets.only(top: 5),
      duration: const Duration(milliseconds: 250),
      child: ListTile(
        onTap: onPressed,
        leading: leading,
        title: title,
        trailing: trailing,
      ),
    );
  }
}

// Position of the dropdown menu relative to the dropdown menu button
enum SDropdownMenuAlignment {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight
}

// Style of the dropdown menu
class SDropdownMenuStyle {
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final SDropdownMenuAlignment? alignment;

  /// position of the top left of the dropdown relative to the top left of the button
  final Offset? offset;

  ///button width must be set for this to take effect
  final double width;
  final double? height;

  const SDropdownMenuStyle({
    this.alignment = SDropdownMenuAlignment.bottomCenter,
    this.constraints,
    this.offset,
    this.width = 250,
    this.height,
    this.elevation,
    this.color,
    this.padding,
    this.borderRadius,
  });
}

abstract class SDropdownMenu<T> extends StatefulWidget {
  /// the child widget for the button, this will be ignored if text is supplied
  final Widget? child;
  final SMenuController? controller;
  final List<SMenuItem<T>> items;
  final Widget? header;
  final Widget? footer;
  final Duration? duration;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(T value, int index)? onChange;

  /// list of DropdownItems
  final SDropdownMenuStyle? style;

  /// dropdown button icon defaults to caret
  final Widget? icon;
  final bool? hideIcon;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool? leadingIcon;

  //
  final bool? showSelected;
  final bool? isSmall;
  final bool? autoIsSmall;

  const SDropdownMenu({
    Key? key,
    this.hideIcon = false,
    this.duration,
    this.child,
    required this.items,
    this.style = const SDropdownMenuStyle(),
    this.icon,
    this.leadingIcon = false,
    this.onChange,
    this.controller,
    this.header,
    this.footer,
    this.showSelected,
    this.isSmall,
    this.autoIsSmall,
  }) : super(key: key);

  @override
  State<SDropdownMenu<T>> createState() => SDropdownMenuState();
}

class SDropdownMenuState<T extends SDropdownMenu> extends State<T> {
  int selectedIndex = 0;
  SMenuController controller = SMenuController();

  Offset topLeftPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(
      offset.dx - popupSize.width,
      offset.dy - popupSize.height,
    );
  }

  Offset topCenterPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(
      offset.dx + (buttonSize.width / 2) - (popupSize.width / 2),
      offset.dy - popupSize.height,
    );
  }

  Offset topRightPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(
      offset.dx + buttonSize.width,
      offset.dy - popupSize.height,
    );
  }

  Offset centerLeftPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(
      offset.dx - popupSize.width,
      offset.dy + (buttonSize.height / 2) - (popupSize.height / 2),
    );
  }

  Offset centerPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(
      offset.dx + (buttonSize.width / 2) - (popupSize.width / 2),
      offset.dy + (buttonSize.height / 2) - (popupSize.height / 2),
    );
  }

  Offset centerRightPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(offset.dx + buttonSize.width,
        offset.dy + (buttonSize.height / 2) - (popupSize.height / 2));
  }

  Offset bottomLeftPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(offset.dx - popupSize.width, offset.dy + buttonSize.height);
  }

  Offset bottomCenterPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(offset.dx - (popupSize.width / 2) + (buttonSize.width / 2),
        offset.dy + buttonSize.height);
  }

  Offset bottomRightPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(offset.dx + buttonSize.width, offset.dy + buttonSize.height);
  }

  Offset calcPopupPosition(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size buttonSize = renderBox.size;
    Offset styleOffset = widget.style?.offset ?? Offset.zero;
    Size windowSize = MediaQuery.of(context).size;
    Size popupSize =
        Size(widget.style?.width ?? 250, widget.style?.height ?? 350);
    Offset offset = renderBox.localToGlobal(Offset.zero);

    Offset answer;

    switch (widget.style?.alignment) {
      case SDropdownMenuAlignment.topLeft:
        answer = topLeftPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuAlignment.topCenter:
        answer = topCenterPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuAlignment.topRight:
        answer = topRightPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuAlignment.centerLeft:
        answer = centerLeftPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuAlignment.center:
        answer = centerPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuAlignment.centerRight:
        answer = centerRightPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuAlignment.bottomLeft:
        answer = bottomLeftPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuAlignment.bottomRight:
        answer = bottomRightPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuAlignment.bottomCenter:
      default:
        // default is bottom center
        answer = bottomCenterPositionCalculation(buttonSize, popupSize, offset);
        break;
    }

    // Add given offset
    answer = Offset(answer.dx + styleOffset.dx, answer.dy + styleOffset.dy);

    // // Bounds checking
    // Exceeds bounds on the right
    if (answer.dx > (windowSize.width - popupSize.width)) {
      answer = Offset(windowSize.width - popupSize.width, answer.dy);
    }
    // Exceeds bounds on the left
    if (answer.dx < 0) {
      answer = Offset(0, answer.dy);
    }
    // Exceeds bounds on the top
    if (answer.dy < 0) {
      answer = Offset(answer.dx, 0);
    }
    // Exceeds bounds on the bottom
    if (answer.dy > (windowSize.height - popupSize.height)) {
      answer = Offset(answer.dx, windowSize.height - popupSize.height);
    }

    // Return calculated position
    return answer;
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class SDropdownMenuCascade<T> extends SDropdownMenu<T> {
  const SDropdownMenuCascade({
    super.key,
    super.hideIcon = false,
    super.duration,
    super.child,
    required super.items,
    super.style = const SDropdownMenuStyle(),
    super.icon,
    super.leadingIcon = false,
    super.onChange,
    super.controller,
    super.header,
    super.footer,
    super.showSelected,
    super.isSmall,
    this.buttonStyle = const SMenuItemStyle(),
    this.barrierColor = Colors.black26,
  });
  final SMenuItemStyle? buttonStyle;
  final Color? barrierColor;
  @override
  State<SDropdownMenuCascade<T>> createState() =>
      _SDropdownMenuCascadeState<T>();
}

class _SDropdownMenuCascadeState<T>
    extends SDropdownMenuState<SDropdownMenuCascade<T>>
    with TickerProviderStateMixin {
  final GlobalKey _renderKey = GlobalKey();
  late final AnimationController _animationController;
  late final Animation<double> _expandAnimation;
  late final Animation<double> _rotateIconAnimation;
  late final Animation<double> _opacityAnimation;
  OverlayEntry? _overlayEntry;
  int _currentIndex = -1;

  void _openMenu() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  void _closeMenu() async {
    await _animationController
        .reverse()
        .then((value) => _overlayEntry?.remove());
  }

  void _toggleMenu({bool close = false}) async {
    if (controller.state.value == SMenuState.open || close) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  @override
  void initState() {
    if (widget.controller != null) {
      controller = widget.controller!;
    }

    controller.open = _openMenu;
    controller.close = _closeMenu;
    controller.toggle = _toggleMenu;

    _animationController = AnimationController(
        vsync: this,
        duration: widget.duration ?? const Duration(milliseconds: 250));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateIconAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

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

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    if (true) {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // link the overlay to the button
    return SizedBox(
      width: widget.buttonStyle?.width,
      height: widget.buttonStyle?.height,
      child: OutlinedButton(
        key: _renderKey,
        style: OutlinedButton.styleFrom(
          padding: widget.buttonStyle?.padding ?? const EdgeInsets.all(0),
          backgroundColor: widget.buttonStyle?.bgColor ??
              Theme.of(context).colorScheme.onPrimary,
          elevation: widget.buttonStyle?.elevation,
          foregroundColor: widget.buttonStyle?.accentColor,
          shape: widget.buttonStyle?.shape ??
              RoundedRectangleBorder(
                  borderRadius:
                      widget.style?.borderRadius ?? BorderRadius.circular(15)),
        ),
        onPressed: _toggleMenu,
        child: Row(
          mainAxisAlignment:
              widget.buttonStyle?.mainAxisAlignment ?? MainAxisAlignment.center,
          textDirection:
              widget.leadingIcon != null && widget.leadingIcon == true
                  ? TextDirection.rtl
                  : TextDirection.ltr,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!(widget.isSmall ?? true))
              if ((!(widget.showSelected ?? false) || (_currentIndex == -1)) &&
                  (widget.child != null)) ...[
                Flexible(child: widget.child!),
              ] else ...[
                if (widget.showSelected ?? false)
                  Flexible(child: widget.items[_currentIndex]),
              ],
            if (widget.hideIcon != null && !widget.hideIcon!)
              Flexible(
                child: RotationTransition(
                  turns: _rotateIconAnimation,
                  child: widget.icon ?? const Icon(Icons.expand_less_rounded),
                ),
              ),
          ],
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    // find the size and position of the current widget
    Offset position = calcPopupPosition(context);

// missing local position?
    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) => GestureDetector(
        onTap: () => _toggleMenu(close: true),
        behavior: HitTestBehavior.translucent,
        // full screen container to register taps anywhere and close drop down
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            color: widget.barrierColor ?? Colors.black26,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  left: position.dx,
                  top: position.dy,
                  // width: widget.style?.width ?? widget.style?.constraints?.maxWidth ?? 250,
                  child: Material(
                    elevation: widget.style?.elevation ?? 0,
                    borderRadius:
                        widget.style?.borderRadius ?? BorderRadius.circular(15),
                    color: widget.style?.color ??
                        Theme.of(context).colorScheme.onPrimary,
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: _expandAnimation,
                      child: ConstrainedBox(
                        constraints: widget.style?.constraints ??
                            BoxConstraints(
                              maxWidth: widget.style?.width ?? 250,
                              maxHeight: widget.style?.height ?? 350,
                            ),
                        child: SizedBox(
                          height: widget.style?.height ?? 350,
                          child: ListView(
                            padding: widget.style?.padding ?? EdgeInsets.zero,
                            shrinkWrap: true,
                            children: widget.items.asMap().entries.map((item) {
                              return Material(
                                borderRadius:
                                    widget.buttonStyle?.borderRadius ??
                                        BorderRadius.circular(15),
                                color: widget.buttonStyle?.bgColor ??
                                    Theme.of(context).colorScheme.onPrimary,
                                child: InkWell(
                                  borderRadius:
                                      widget.buttonStyle?.borderRadius ??
                                          BorderRadius.circular(15),
                                  onTap: () {
                                    if (item.value.value != null) {
                                      setState(() => _currentIndex = item.key);
                                      if (widget.onChange != null) {
                                        widget.onChange!(
                                            item.value.value as T, item.key);
                                      }
                                      _toggleMenu(close: true);
                                    }
                                  },
                                  child: item.value,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SDropdownMenuMorph<T> extends SDropdownMenu<T> {
  const SDropdownMenuMorph({
    this.itemStyle,
    super.key,
    super.hideIcon = false,
    super.child,
    required super.items,
    super.style = const SDropdownMenuStyle(),
    super.icon,
    super.leadingIcon = false,
    super.onChange,
    super.controller,
    super.header,
    super.footer,
    super.showSelected,
    super.isSmall,
  });
  final SMenuItemStyle? itemStyle;
  @override
  State<SDropdownMenuMorph<T>> createState() => _SDropdownMenuMorphState<T>();
}

class _SDropdownMenuMorphState<T>
    extends SDropdownMenuState<SDropdownMenuMorph<T>>
    with TickerProviderStateMixin {
  int _currentIndex = -1;
  GlobalKey key = GlobalKey();
  GlobalKey renderKey = GlobalKey();
  Animation<double>? _rotateAnimation;
  AnimationController? _animationController;

  void _openMenu() async {
    var result = await Navigator.push(
        context,
        SPopupMenuRoute(
          animDuration: const Duration(milliseconds: 250),
          bgColor: Colors.black12,
          dismissable: true,
          fullscreenDialog: false,
          builder: (context) {
            return _SDropdownMenuPopup(
              position: calcPopupPosition(renderKey.currentContext!),
              tag: key,
              items: widget.items,
              style: widget.style,
              controller: widget.controller,
              header: widget.header,
              footer: widget.footer,
            );
          },
        ));
    if (result != null) {
      setState(
        () => _currentIndex = result['index'],
      );
      if (widget.onChange != null) {
        widget.onChange!(result['value'] as T, result['index']);
      }
    }
  }

  void _closeMenu() {
    // Implement close menu
    throw (UnimplementedError);
  }

  void _toggleMenu() {
    // Implement toggle menu
    // if (true) {
    //   _closeMenu();
    // } else {
    //   _openMenu();
    // }
    throw (UnimplementedError);
  }

  @override
  void initState() {
    if (widget.controller != null) {
      controller = widget.controller!;
    }

    controller.open = _openMenu;
    controller.close = _closeMenu;
    controller.toggle = _toggleMenu;

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHero(
        tag: key,
        child: Container(
          color: Colors.transparent,
          key: renderKey,
          width: widget.itemStyle?.width,
          height: widget.itemStyle?.height,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: widget.itemStyle?.padding ?? const EdgeInsets.all(0),
              backgroundColor: widget.itemStyle?.bgColor ??
                  Theme.of(context).colorScheme.onPrimary,
              elevation: widget.itemStyle?.elevation,
              foregroundColor: widget.itemStyle?.accentColor,
              shape: widget.itemStyle?.shape ??
                  RoundedRectangleBorder(
                      borderRadius: widget.itemStyle?.borderRadius ??
                          BorderRadius.circular(15)),
            ),
            onPressed: () async {
              _openMenu();
            },
            child: Row(
              mainAxisAlignment: widget.itemStyle?.mainAxisAlignment ??
                  MainAxisAlignment.center,
              textDirection:
                  widget.leadingIcon != null && widget.leadingIcon == true
                      ? TextDirection.rtl
                      : TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              children: [
                if ((_currentIndex == -1) && (widget.child != null)) ...[
                  Flexible(child: widget.child!),
                ] else if (_currentIndex > -1) ...[
                  Flexible(child: widget.items[_currentIndex]),
                ],
                if (widget.hideIcon != null && !widget.hideIcon!)
                  Flexible(
                    child: RotationTransition(
                      turns: _rotateAnimation!,
                      child: widget.icon ?? const Icon(Icons.arrow_drop_down),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}

class _SDropdownMenuPopup<T> extends StatelessWidget {
  final Object tag;
  final List<SMenuItem<T>> items;
  final SDropdownMenuStyle? style;
  final SMenuItemStyle? buttonStyle;
  final SMenuController? controller;
  final Widget? header;
  final Widget? footer;
  final Offset position;
  const _SDropdownMenuPopup(
      {super.key,
      required this.tag,
      required this.items,
      this.buttonStyle,
      this.controller,
      this.header,
      this.footer,
      this.style = const SDropdownMenuStyle(),
      required this.position});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          width: style?.width ?? 250,
          child: CustomHero(
            tag: tag,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius:
                      style?.borderRadius ?? BorderRadius.circular(15),
                  color: style?.color ?? Colors.white),
              constraints: style?.constraints ??
                  BoxConstraints(
                      maxHeight: style?.height ?? 350,
                      maxWidth: 250,
                      minHeight: style?.height ?? 10),
              child: SizedBox(
                height: style?.height ?? 350,
                child: ListView(
                  // padding: style?.padding ?? EdgeInsets.zero,
                  // shrinkWrap: true,
                  children: items.asMap().entries.map((item) {
                    return Material(
                      borderRadius: buttonStyle?.borderRadius ??
                          BorderRadius.circular(15),
                      color: buttonStyle?.bgColor ??
                          Theme.of(context).colorScheme.onPrimary,
                      child: InkWell(
                        borderRadius: buttonStyle?.borderRadius ??
                            BorderRadius.circular(15),
                        onTap: () {
                          if (item.value.value != null) {
                            Navigator.pop(context,
                                {'index': item.key, 'value': item.value.value});
                          }
                        },
                        child: item.value,
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
