import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'menu_item.dart';
import 'resize_bar.dart';
import 'routes.dart';

class SMenuSize {
  static const double menuWidthClosed = 50;
  static const double menuWidthOpen = 250;
}

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

enum SMenuState { open, closed }

enum SSideMenuPosition { top, bottom, left, right }

class SSideMenuStyle {
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final SSideMenuPosition? position;
  final Color? barColor;
  final Color? backgroundColor;

  const SSideMenuStyle({
    this.barColor,
    this.backgroundColor,
    this.constraints,
    this.position = SSideMenuPosition.left,
    this.padding = const EdgeInsets.all(5),
    this.borderRadius,
  });
}

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

class SMenuController {
  SMenuController({required double startSize})
      : size = ValueNotifier<double>(startSize);
  late void Function() open;
  late void Function() close;
  late void Function() toggle;
  final ValueNotifier<SMenuState> state =
      ValueNotifier<SMenuState>(SMenuState.closed);
  final ValueNotifier<double> size;
}

class SSideMenu extends StatefulWidget {
  const SSideMenu({
    Key? key,
    required this.items,
    this.header,
    this.footer,
    this.controller,
    this.enableSelector = true,
    this.style = const SSideMenuStyle(),
  }) : super(key: key);
  final SSideMenuStyle? style;
  final SMenuController? controller;
  final List<SMenuItem> items;
  final Widget? header;
  final Widget? footer;
  final bool enableSelector;

  @override
  State<SSideMenu> createState() => _SSideMenuState();
}

class _SSideMenuState extends State<SSideMenu> {
  int selectedIndex = 0;
  SMenuController controller = SMenuController(startSize: 50);

  void _openMenu() {
    setState(() {
      if (widget.style?.position == SSideMenuPosition.top ||
          widget.style?.position == SSideMenuPosition.bottom) {
        controller.size.value =
            widget.style?.constraints?.maxHeight ?? SMenuSize.menuWidthOpen;
        controller.state.value = SMenuState.open;
      } else {
        controller.size.value =
            widget.style?.constraints?.maxWidth ?? SMenuSize.menuWidthOpen;
        controller.state.value = SMenuState.open;
      }
    });
  }

  void _closeMenu() {
    setState(() {
      if (widget.style?.position == SSideMenuPosition.top ||
          widget.style?.position == SSideMenuPosition.bottom) {
        controller.size.value =
            widget.style?.constraints?.minHeight ?? SMenuSize.menuWidthClosed;
        controller.state.value = SMenuState.closed;
      } else {
        controller.size.value =
            widget.style?.constraints?.minWidth ?? SMenuSize.menuWidthClosed;
        controller.state.value = SMenuState.closed;
      }
    });
  }

  void _toggleMenu() {
    double compare;
    if (widget.style?.position == SSideMenuPosition.top ||
        widget.style?.position == SSideMenuPosition.bottom) {
      compare =
          widget.style?.constraints?.minHeight ?? SMenuSize.menuWidthClosed;
    } else {
      compare =
          widget.style?.constraints?.minWidth ?? SMenuSize.menuWidthClosed;
    }
    if (controller.size.value > compare) {
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

    controller.size.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (var item in widget.items) {
      if (item is SMenuItemButton && item.isSelected == true) {
        selectedIndex = widget.items.indexOf(item);
      }
    }
    var align;
    if (widget.style?.position == SSideMenuPosition.top) {
      align = AlignmentDirectional.bottomCenter;
    } else if (widget.style?.position == SSideMenuPosition.right) {
      align = AlignmentDirectional.centerStart;
    } else if (widget.style?.position == SSideMenuPosition.bottom) {
      align = AlignmentDirectional.topCenter;
    } else {
      align = AlignmentDirectional.centerEnd;
    }

    return Stack(
      alignment: align,
      children: [
        AnimatedContainer(
          decoration: BoxDecoration(
              color: widget.style?.backgroundColor ??
                  Theme.of(context).colorScheme.background,
              borderRadius: widget.style?.borderRadius),
          padding: widget.style?.padding ?? EdgeInsets.symmetric(horizontal: 5),
          duration: Duration(milliseconds: 250),
          constraints: widget.style?.constraints ??
              (((widget.style?.position == SSideMenuPosition.top) ||
                      (widget.style?.position == SSideMenuPosition.bottom))
                  ? BoxConstraints(minHeight: 50, maxHeight: 250)
                  : BoxConstraints(minWidth: 50, maxWidth: 250)),
          width: (widget.style?.position == SSideMenuPosition.left ||
                  widget.style?.position == SSideMenuPosition.right)
              ? controller.size.value
              : null,
          height: (widget.style?.position == SSideMenuPosition.top ||
                  widget.style?.position == SSideMenuPosition.bottom)
              ? controller.size.value
              : null,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    widget.header ?? Container(),
                    Stack(
                      children: [
                        Column(
                          children: widget.items,
                        ),
                        // Moving bar to indicate page number
                        if (widget.enableSelector && widget.items.isNotEmpty)
                          AnimatedContainer(
                            duration: Duration(milliseconds: 250),
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
                  ],
                ),
                widget.footer ??
                    Container(
                      child: TextButton(
                        child: Text('T'),
                        onPressed: () {
                          _toggleMenu();
                        },
                      ),
                    )
              ]),
        ),
        if (widget.style?.position != null &&
            widget.style?.position is SSideMenuPosition)
          ResizeBar(
            position: widget.style!.position!,
            menuController: controller,
          ),
      ],
    );
  }
}

abstract class SDropdownMenu<T> extends StatefulWidget {
  /// the child widget for the button, this will be ignored if text is supplied
  final Widget? child;
  final SMenuController? controller;
  final List<SMenuItem<T>> items;
  final Widget? header;
  final Widget? footer;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(T value, int index)? onChange;

  /// list of DropdownItems
  final SDropdownMenuStyle? style;

  /// dropdown button icon defaults to caret
  final Icon? icon;
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
  SMenuController controller = SMenuController(startSize: 50);
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
      case SDropdownMenuAlignment.bottomCenter:
        answer = bottomCenterPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuAlignment.bottomRight:

      default:
        // default is bottom right
        answer = bottomRightPositionCalculation(buttonSize, popupSize, offset);
        break;
    }
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
    return answer;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class SDropdownMenuCascade<T> extends SDropdownMenu<T> {
  const SDropdownMenuCascade({
    final Key? key,
    final bool? hideIcon = false,
    final Widget? child,
    required List<SMenuItem<T>> items,
    final SDropdownMenuStyle? style = const SDropdownMenuStyle(),
    final Icon? icon,
    final bool? leadingIcon = false,
    final void Function(dynamic, int)? onChange,
    final SMenuController? controller,
    final Widget? header,
    final Widget? footer,
    final bool? showSelected,
    final bool? isSmall,
    final bool? autoIsSmall,
    this.buttonStyle = const SMenuItemStyle(),
  }) : super(
            key: key,
            hideIcon: hideIcon,
            child: child,
            items: items,
            style: style,
            icon: icon,
            leadingIcon: leadingIcon,
            onChange: onChange,
            controller: controller,
            header: header,
            footer: footer,
            showSelected: showSelected,
            autoIsSmall: autoIsSmall,
            isSmall: isSmall);
  final SMenuItemStyle? buttonStyle;
  @override
  State<SDropdownMenuCascade<T>> createState() =>
      _SDropdownMenuCascadeState<T>();
}

class _SDropdownMenuCascadeState<T>
    extends SDropdownMenuState<SDropdownMenuCascade<T>>
    with TickerProviderStateMixin {
  bool? _isSmall;
  OverlayEntry? _overlayEntry;
  int _currentIndex = -1;
  GlobalKey renderKey = GlobalKey();
  AnimationController? _animationController;
  Animation<double>? _expandAnimation;
  Animation<double>? _rotateAnimation;

  void _openMenu() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    print('Pushed');
    setState(() => controller.state.value = SMenuState.open);
    _animationController!.forward();
  }

  void _closeMenu() async {
    await _animationController?.reverse();
    _overlayEntry?.remove();
    setState(() {
      controller.state.value = SMenuState.closed;
    });
  }

  void _toggleMenu({bool close = false}) async {
    if (controller.state.value == SMenuState.open || close) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _updateIsSmall(double newWidth) {
    setState(() {
      controller.size.value = newWidth;
      if (newWidth < 60 && (widget.autoIsSmall ?? false)) {
        _isSmall = true;
      }
    });
  }

  @override
  void initState() {
    if (widget.controller != null) {
      controller = widget.controller!;
    }

    controller.open = _openMenu;
    controller.close = _closeMenu;
    controller.toggle = _toggleMenu;

    controller.size.addListener(() {
      setState(() {});
    });

    _isSmall = widget.isSmall;

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.buttonStyle;
    // must change this class so width is reflected in controller size
    controller.size.value = 50;

    // link the overlay to the button
    return SizedBox(
      width: style?.width,
      height: style?.height,
      child: OutlinedButton(
        key: renderKey,
        style: OutlinedButton.styleFrom(
          padding: style?.padding ?? EdgeInsets.all(0),
          backgroundColor:
              style?.bgColor ?? Theme.of(context).colorScheme.background,
          elevation: style?.elevation,
          foregroundColor: style?.accentColor,
          shape: style?.shape ??
              RoundedRectangleBorder(
                  borderRadius:
                      widget.style?.borderRadius ?? BorderRadius.circular(15)),
        ),
        onPressed: _toggleMenu,
        child: Row(
          mainAxisAlignment:
              style?.mainAxisAlignment ?? MainAxisAlignment.center,
          textDirection:
              widget.leadingIcon != null && widget.leadingIcon == true
                  ? TextDirection.rtl
                  : TextDirection.ltr,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!(_isSmall ?? true))
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
                  turns: _rotateAnimation!,
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

    var topOffset = position.dy;
    var leftOffset = position.dx;
    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) => GestureDetector(
        onTap: () => _toggleMenu(close: true),
        behavior: HitTestBehavior.translucent,
        // full screen container to register taps anywhere and close drop down
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: leftOffset,
                top: topOffset,
                width: widget.style?.width ?? 250,
                child: Material(
                  elevation: widget.style?.elevation ?? 0,
                  borderRadius:
                      widget.style?.borderRadius ?? BorderRadius.circular(15),
                  color: widget.style?.color ??
                      Theme.of(context).colorScheme.background,
                  child: SizeTransition(
                    axisAlignment: 1,
                    sizeFactor: _expandAnimation!,
                    child: ConstrainedBox(
                      constraints: widget.style?.constraints ??
                          BoxConstraints(
                            maxHeight: widget.style?.height ?? 350,
                          ),
                      child: ListView(
                        padding: widget.style?.padding ?? EdgeInsets.zero,
                        shrinkWrap: true,
                        children: widget.items.asMap().entries.map((item) {
                          return GestureDetector(
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
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SDropdownMenuMorph<T> extends SDropdownMenu<T> {
  const SDropdownMenuMorph({
    this.itemStyle,
    final Key? key,
    final bool? hideIcon = false,
    required Widget child,
    required List<SMenuItem<T>> items,
    final SDropdownMenuStyle? style = const SDropdownMenuStyle(),
    final Icon? icon,
    final bool? leadingIcon = false,
    final void Function(dynamic, int)? onChange,
    final SMenuController? controller,
    final Widget? header,
    final Widget? footer,
    final bool? showSelected,
    final bool? isSmall,
    final bool? autoIsSmall,
  }) : super(
            key: key,
            hideIcon: hideIcon,
            child: child,
            items: items,
            style: style,
            icon: icon,
            leadingIcon: leadingIcon,
            onChange: onChange,
            controller: controller,
            header: header,
            footer: footer,
            showSelected: showSelected,
            autoIsSmall: autoIsSmall,
            isSmall: isSmall);
  final SMenuItemStyle? itemStyle;
  @override
  State<SDropdownMenuMorph<T>> createState() => _SDropdownMenuMorphState<T>();
}

class _SDropdownMenuMorphState<T>
    extends SDropdownMenuState<SDropdownMenuMorph<T>>
    with TickerProviderStateMixin {
  int selectedIndex = 0;
  int _currentIndex = -1;
  SMenuController controller = SMenuController(startSize: 50);
  GlobalKey renderKey = GlobalKey();
  Animation<double>? _rotateAnimation;
  AnimationController? _animationController;

  void _openMenu() async {
    var result = await Navigator.push(
        context,
        SPopupMenuRoute(
          animDuration: Duration(milliseconds: 500),
          bgColor: Colors.black12,
          dismissable: true,
          fullscreenDialog: false,
          builder: (context) {
            return _SDropdownMenuPopup(
              position: calcPopupPosition(renderKey.currentContext!),
              tag: 0,
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

    controller.size.addListener(() {
      setState(() {});
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
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
        tag: 0,
        child: Container(
          color: Colors.transparent,
          key: renderKey,
          width: widget.itemStyle?.width,
          height: widget.itemStyle?.height,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: widget.itemStyle?.padding ?? EdgeInsets.all(0),
              backgroundColor: widget.itemStyle?.bgColor ??
                  Theme.of(context).colorScheme.background,
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
                ] else ...[
                  Flexible(child: widget.items[_currentIndex]),
                ],
                if (widget.hideIcon != null && !widget.hideIcon!)
                  Flexible(
                    child: RotationTransition(
                      turns: _rotateAnimation!,
                      child: widget.icon ?? Icon(Icons.abc),
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
  final SMenuController? controller;
  final Widget? header;
  final Widget? footer;
  final Offset position;
  const _SDropdownMenuPopup(
      {Key? key,
      required this.tag,
      required this.items,
      this.controller,
      this.header,
      this.footer,
      this.style = const SDropdownMenuStyle(),
      required this.position})
      : super(key: key);

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
                    return GestureDetector(
                      onTap: () {
                        if (item.value.value != null) {
                          Navigator.pop(context,
                              {'index': item.key, 'value': item.value.value});
                        }
                      },
                      child: item.value,
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
