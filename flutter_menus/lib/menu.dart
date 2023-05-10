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
    this.alignment = SDropdownMenuAlignment.bottomLeft,
    this.constraints = const BoxConstraints(),
    this.offset,
    this.width = 200,
    this.height,
    this.elevation = 0,
    this.color = Colors.white,
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Left resize bar
        if (widget.style?.position == SSideMenuPosition.right)
          ResizeBar(
            position: SSideMenuPosition.right,
            menuController: controller,
          ),

        AnimatedContainer(
          decoration: BoxDecoration(
              color: widget.style?.backgroundColor ??
                  Theme.of(context).colorScheme.background,
              borderRadius: widget.style?.borderRadius),
          padding: widget.style?.padding ?? EdgeInsets.symmetric(horizontal: 5),
          duration: Duration(milliseconds: 250),
          constraints: widget.style?.constraints ??
              BoxConstraints(minWidth: 50, maxWidth: 250),
          width: (widget.style?.position == SSideMenuPosition.left ||
                  widget.style?.position == SSideMenuPosition.right)
              ? controller.size.value
              : null,
          height: (widget.style?.position == SSideMenuPosition.top ||
                  widget.style?.position == SSideMenuPosition.bottom)
              ? controller.size.value
              : null,
          child: Column(
            children: [
              // Top resize bar
              if (widget.style?.position == SSideMenuPosition.bottom)
                ResizeBar(
                  position: SSideMenuPosition.bottom,
                  menuController: controller,
                ),
              Column(
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
                            if (widget.enableSelector &&
                                widget.items.isNotEmpty)
                              AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                padding: EdgeInsets.only(
                                    left: 1, top: 15 + (selectedIndex * 50)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: widget.style?.barColor ??
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
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
              // Bottom resize bar
              if (widget.style?.position == SSideMenuPosition.top)
                ResizeBar(
                  position: SSideMenuPosition.top,
                  menuController: controller,
                ),
            ],
          ),
        ),

        // Right resize bar
        if (widget.style?.position == SSideMenuPosition.left)
          ResizeBar(
            position: SSideMenuPosition.left,
            menuController: controller,
          ),
      ],
    );
  }
}

abstract class SDropdownMenu<T> extends StatefulWidget {
  /// the child widget for the button, this will be ignored if text is supplied
  final Widget child;
  final SMenuController? controller;
  final List<SMenuItem<T>> items;
  final Widget? header;
  final Widget? footer;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(T, int)? onChange;

  /// list of DropdownItems
  final SDropdownMenuStyle? style;

  /// dropdown button icon defaults to caret
  final Icon? icon;
  final bool? hideIcon;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool? leadingIcon;

  const SDropdownMenu({
    Key? key,
    this.hideIcon = false,
    required this.child,
    required this.items,
    this.style = const SDropdownMenuStyle(),
    this.icon,
    this.leadingIcon = false,
    this.onChange,
    this.controller,
    this.header,
    this.footer,
  }) : super(key: key);

  @override
  State<SDropdownMenu<T>> createState() => _SDropdownMenuState<T>();
}

class _SDropdownMenuState<T> extends State<SDropdownMenu<T>>
    with TickerProviderStateMixin {
  int selectedIndex = 0;
  SMenuController controller = SMenuController(startSize: 50);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class SDropdownMenuCascade<T> extends SDropdownMenu {
  const SDropdownMenuCascade({
    final Key? key,
    final bool? hideIcon = false,
    required Widget child,
    required List<SMenuItem<T>> items,
    final SDropdownMenuStyle style = const SDropdownMenuStyle(),
    this.buttonStyle = const SMenuItemStyle(),
    final Icon? icon,
    final bool? leadingIcon = false,
    final void Function(dynamic, int)? onChange,
    final SMenuController? controller,
    final Widget? header,
    final Widget? footer,
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
            footer: footer);
  final SMenuItemStyle? buttonStyle;
  @override
  State<SDropdownMenuCascade<T>> createState() =>
      _SDropdownMenuCascadeState<T>();
}

class _SDropdownMenuCascadeState<T> extends State<SDropdownMenuCascade<T>>
    with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  int _currentIndex = -1;
  AnimationController? _animationController;
  Animation<double>? _expandAnimation;
  Animation<double>? _rotateAnimation;
  int selectedIndex = 0;
  SMenuController controller = SMenuController(startSize: 50);

  void _openMenu() {
    this._overlayEntry = this._createOverlayEntry();
    Overlay.of(context).insert(this._overlayEntry!);
    print('Pushed');
    setState(() => controller.state.value = SMenuState.open);
    _animationController!.forward();
  }

  Future<void> _closeMenu() async {
    await _animationController!.reverse();
    this._overlayEntry!.remove();
    setState(() {
      controller.state.value = SMenuState.closed;
    });
  }

  void _toggleMenu({bool close = false}) async {
    if (controller.state.value == SMenuState.open || close) {
      _openMenu();
    } else {
      _closeMenu();
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
    this._overlayEntry?.remove();
    this._overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.buttonStyle;
    // link the overlay to the button
    return CompositedTransformTarget(
      link: this._layerLink,
      child: Container(
        width: style?.width,
        height: style?.height,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: style?.padding,
            backgroundColor: style?.bgColor ?? Colors.white,
            elevation: style?.elevation,
            foregroundColor: style?.accentColor,
            shape: style?.shape,
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
              if (_currentIndex == -1) ...[
                widget.child,
              ] else ...[
                widget.items[_currentIndex],
              ],
              if (widget.hideIcon != null && !widget.hideIcon!)
                RotationTransition(
                  turns: _rotateAnimation!,
                  child: widget.icon ?? Icon(Icons.abc),
                ),
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    // find the size and position of the current widget
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    var offset = renderBox.localToGlobal(Offset.zero);
    var topOffset = offset.dy + size.height + 50;
    var leftOffset = offset.dx - size.width - 5;
    print(topOffset);
    print(leftOffset);
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
                width: widget.style?.width ?? size.width,
                child: CompositedTransformFollower(
                  offset: widget.style?.offset ?? Offset(0, size.height + 5),
                  link: this._layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: widget.style?.elevation ?? 0,
                    borderRadius:
                        widget.style?.borderRadius ?? BorderRadius.zero,
                    color: widget.style?.color,
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: _expandAnimation!,
                      child: ConstrainedBox(
                        constraints: widget.style?.constraints ??
                            BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height -
                                  topOffset -
                                  15,
                            ),
                        child: ListView(
                          padding: widget.style?.padding ?? EdgeInsets.zero,
                          shrinkWrap: true,
                          children: widget.items.asMap().entries.map((item) {
                            return InkWell(
                              onTap: () {
                                setState(() => _currentIndex = item.key);
                                if (widget.onChange != null &&
                                    item.value.value != null) {
                                  widget.onChange!(
                                      item.value.value as T, item.key);
                                }

                                _toggleMenu();
                              },
                              child: item.value,
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
    );
  }
}

class SDropdownMenuMorph<T> extends SDropdownMenu {
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
            footer: footer);
  final SMenuItemStyle? itemStyle;
  @override
  State<SDropdownMenuMorph<T>> createState() => _SDropdownMenuMorphState<T>();
}

class _SDropdownMenuMorphState<T> extends State<SDropdownMenuMorph<T>>
    with TickerProviderStateMixin {
  int selectedIndex = 0;
  int _currentIndex = -1;
  SMenuController controller = SMenuController(startSize: 50);
  GlobalKey renderKey = GlobalKey();
  Animation<double>? _rotateAnimation;
  AnimationController? _animationController;

  void _openMenu() {}

  void _closeMenu() {}

  void _toggleMenu() {}

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
          key: renderKey,
          width: widget.itemStyle?.width,
          height: widget.itemStyle?.height,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: widget.itemStyle?.padding,
              backgroundColor: widget.itemStyle?.bgColor ?? Colors.white,
              elevation: widget.itemStyle?.elevation,
              foregroundColor: widget.itemStyle?.accentColor,
              shape: widget.itemStyle?.shape,
            ),
            onPressed: () async {
              var result = await Navigator.push(context, SPopupMenuRoute(
                builder: (context) {
                  return _SDropdownMenuPopup(
                    position: calcPopupPosition(),
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
                // _currentIndex = result.key;
              }
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
                if (_currentIndex == -1) ...[
                  widget.child,
                ] else ...[
                  widget.items[_currentIndex],
                ],
                if (widget.hideIcon != null && !widget.hideIcon!)
                  RotationTransition(
                    turns: _rotateAnimation!,
                    child: widget.icon ?? Icon(Icons.abc),
                  ),
              ],
            ),
          ),
        ));
  }

  Offset calcPopupPosition() {
    var renderBox = renderKey.currentContext?.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var windowSize = MediaQuery.of(context).size;
    var offset = renderBox.localToGlobal(Offset.zero);
    double topOffset;
    double leftOffset;

    switch (widget.style?.alignment) {
      case SDropdownMenuAlignment.topLeft:
        break;
      case SDropdownMenuAlignment.topCenter:
        break;
      case SDropdownMenuAlignment.topRight:
        break;
      case SDropdownMenuAlignment.centerLeft:
        break;
      case SDropdownMenuAlignment.center:
        break;
      case SDropdownMenuAlignment.centerRight:
        break;
      case SDropdownMenuAlignment.bottomLeft:
        break;
      case SDropdownMenuAlignment.bottomCenter:
        break;
      case SDropdownMenuAlignment.bottomRight:
      default:
        // default is bottom right

        break;
    }

    if (windowSize.height <
        (offset.dy + size.height + (widget.style?.height ?? 250))) {
      topOffset = offset.dy - size.height - (widget.style?.height ?? 250);
    } else {
      topOffset = offset.dy + size.height;
    }
    if ((0 - (offset.dx + size.width + (widget.style?.width ?? 150))) < 0) {
      leftOffset = offset.dx - size.width - (widget.style?.width ?? 150);
    } else {
      leftOffset = offset.dx - size.width + (widget.style?.width ?? 150);
    }
    return Offset(leftOffset, topOffset);
  }
}

class _SDropdownMenuPopup<T> extends StatelessWidget {
  final Object tag;
  final List<SMenuItem<T>> items;
  final SDropdownMenuStyle? style;
  final SMenuItemStyle? itemStyle;
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
      this.itemStyle = const SMenuItemStyle(),
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
                  borderRadius: style?.borderRadius,
                  color: style?.color ?? Colors.white),
              constraints: style?.constraints ??
                  BoxConstraints(
                      maxHeight: style?.height ?? 350,
                      maxWidth: 250,
                      minHeight: style?.height ?? 10),
              child: Column(
                children: [
                  ListView(
                    padding: style?.padding ?? EdgeInsets.zero,
                    shrinkWrap: true,
                    children: items,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
