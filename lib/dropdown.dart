import 'package:flutter/material.dart';

import 'base.dart';
import 'helper.dart';
import 'menu_item.dart';

class SDropdownMenuCascade<T> extends SBaseDropdownMenu<T> {
  const SDropdownMenuCascade({
    required super.items,
    super.key,
    super.duration,
    super.child,
    super.style,
    super.height,
    super.width,
    super.onChange,
    super.controller,
    super.header,
    super.footer,
    super.curve,
    super.icon,
    super.position,
    super.builder,
    super.buttonStyle,
  });

  @override
  State<SDropdownMenuCascade<T>> createState() =>
      _SDropdownMenuCascadeState<T>();
}

class _SDropdownMenuCascadeState<T>
    extends SBaseDropdownMenuState<SDropdownMenuCascade<T>> {
  final GlobalKey _renderKey = GlobalKey();
  late final Animation<double> _expandAnimation;
  late final Animation<double> _rotateIconAnimation;
  late final Animation<double> _opacityAnimation;
  OverlayEntry? _overlayEntry;
  int _currentIndex = -1;

  @override
  void openMenu() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    animationController.forward();
  }

  @override
  void closeMenu() async {
    await animationController
        .reverse()
        .then((value) => _overlayEntry?.remove());
  }

  @override
  void toggleMenu({bool close = false}) async {
    if (controller.state.value == SMenuState.open || close) {
      closeMenu();
    } else {
      openMenu();
    }
  }

  @override
  void initState() {
    super.initState();

    // Setup animations
    _expandAnimation = CurvedAnimation(
      parent: animationController,
      curve: widget.curve,
    );
    _rotateIconAnimation = Tween(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(parent: animationController, curve: widget.curve));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    super.dispose();

    if (true) {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.buttonStyle.width,
      height: widget.buttonStyle.height,
      child: OutlinedButton(
        key: _renderKey,
        style: OutlinedButton.styleFrom(
          enabledMouseCursor: widget.buttonStyle.mouseCursor,
          padding: widget.buttonStyle.padding ?? const EdgeInsets.all(0),
          backgroundColor: widget.buttonStyle.bgColor ??
              Theme.of(context).colorScheme.onPrimary,
          elevation: widget.buttonStyle.elevation,
          foregroundColor: widget.buttonStyle.accentColor,
          shape: widget.buttonStyle.shape ??
              RoundedRectangleBorder(borderRadius: widget.style.borderRadius),
        ),
        onPressed: toggleMenu,
        child: Row(
          mainAxisAlignment: widget.buttonStyle.alignment,
          textDirection:
              widget.style.leadingIcon ? TextDirection.rtl : TextDirection.ltr,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!(widget.style.isSmall))
              if ((!(widget.style.showSelected) || (_currentIndex == -1)) &&
                  (widget.child != null)) ...[
                Flexible(child: widget.child!),
              ] else ...[
                if (widget.style.showSelected)
                  Flexible(
                      child: widget.items?[_currentIndex].getPreview(context) ??
                          Container()),
              ],
            if (!widget.style.hideIcon)
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
        onTap: () => toggleMenu(close: true),
        behavior: HitTestBehavior.translucent,
        // full screen container to register taps anywhere and close drop down
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            color: widget.style.barrierColor,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  left: position.dx,
                  top: position.dy,
                  child: SizeTransition(
                    axisAlignment: 1,
                    sizeFactor: _expandAnimation,
                    child: Material(
                      // TODO: add a border parameter to dropdown cascade or add a shape to style and use that instead of border and border radius
                      elevation: widget.style.elevation ?? 0,
                      borderRadius: widget.style.borderRadius,
                      color: widget.style.color ?? Colors.transparent,
                      child: ConstrainedBox(
                        constraints: widget.style.constraints ??
                            BoxConstraints(
                              maxWidth: widget.width,
                              maxHeight: widget.height,
                            ),
                        child: SizedBox(
                          height: widget.height,
                          child: ListView(
                            padding: widget.style.padding ?? EdgeInsets.zero,
                            shrinkWrap: true,
                            children: widget.items
                                    ?.asMap()
                                    .entries
                                    .map((element) {
                                  final SMenuItem item = element.value;
                                  // Add a button effect if this item has a value
                                  if (item.value == null) {
                                    return item;
                                  }
                                  if (item.onPressed != null) {
                                    return item;
                                  }
                                  return Material(
                                    shape: item.style.shape ??
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                item.style.borderRadius),
                                    color: item.style.bgColor ??
                                        Theme.of(context).colorScheme.onPrimary,
                                    child: InkWell(
                                      highlightColor: item.style.accentColor,
                                      hoverColor: item.style.accentColor,
                                      splashColor: item.style.accentColor
                                          ?.withOpacity(0.1),
                                      customBorder: item.style.shape,
                                      mouseCursor: item.style.mouseCursor,
                                      borderRadius: item.style.borderRadius,
                                      onTap: () {
                                        setState(
                                            () => _currentIndex = element.key);
                                        if (widget.onChange != null) {
                                          widget.onChange!(
                                              item.value as T, element.key);
                                        }

                                        toggleMenu(close: true);
                                      },
                                      child: item,
                                    ),
                                  );
                                }).toList() ??
                                [Container()],
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

class SDropdownMenuMorph<T> extends SBaseDropdownMenu<T> {
  const SDropdownMenuMorph({
    required super.items,
    super.key,
    super.child,
    super.style,
    super.curve,
    super.duration,
    super.onChange,
    super.controller,
    super.header,
    super.footer,
    super.height,
    super.width,
    super.icon,
    super.position,
    super.builder,
    super.buttonStyle,
  });

  @override
  State<SDropdownMenuMorph<T>> createState() => _SDropdownMenuMorphState<T>();
}

class _SDropdownMenuMorphState<T>
    extends SBaseDropdownMenuState<SDropdownMenuMorph<T>> {
  int _currentIndex = -1;
  GlobalKey key = GlobalKey();
  GlobalKey renderKey = GlobalKey();
  Animation<double>? _rotateAnimation;

  @override
  void openMenu() async {
    MapEntry<int, SMenuItem>? result = await Navigator.push(
        context,
        SPopupMenuRoute(
          animDuration: const Duration(milliseconds: 250),
          bgColor: widget.style.barrierColor,
          dismissable: true,
          fullscreenDialog: false,
          builder: (context) {
            return SDropdownMenuPopup(
              position: calcPopupPosition(renderKey.currentContext!),
              tag: key,
              items: widget.items ?? [],
              style: widget.style,
              controller: widget.controller,
              header: widget.header,
              footer: widget.footer,
              width: widget.width,
              height: widget.height,
            );
          },
        ));
    if (result != null) {
      setState(
        () => _currentIndex = result.key,
      );
      if (widget.onChange != null) {
        widget.onChange!(result.value.value as T, result.key);
      }
    }
  }

  @override
  void closeMenu() {
    // Implement close menu
    throw (UnimplementedError);
  }

  @override
  void toggleMenu() {
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
    super.initState();

    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: animationController,
      curve: widget.curve,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: prevent button from taking place of menu when closing hero anim
    return CustomHero(
        tag: key,
        child: Container(
          color: Colors.transparent,
          key: renderKey,
          width: widget.buttonStyle.width,
          height: widget.buttonStyle.height,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: widget.buttonStyle.padding ?? const EdgeInsets.all(0),
              backgroundColor: widget.buttonStyle.bgColor ??
                  Theme.of(context).colorScheme.onPrimary,
              elevation: widget.buttonStyle.elevation,
              foregroundColor: widget.buttonStyle.accentColor,
              shape: widget.buttonStyle.shape ??
                  RoundedRectangleBorder(
                      borderRadius: widget.buttonStyle.borderRadius),
            ),
            onPressed: () async {
              openMenu();
            },
            child: Row(
              mainAxisAlignment: widget.buttonStyle.alignment,
              textDirection: widget.style.leadingIcon
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!(widget.style.isSmall))
                  if ((!(widget.style.showSelected) || (_currentIndex == -1)) &&
                      (widget.child != null)) ...[
                    Flexible(child: widget.child!),
                  ] else ...[
                    if (widget.style.showSelected)
                      Flexible(
                          child: widget.items?[_currentIndex]
                                  .getPreview(context) ??
                              Container()),
                  ],
                if (!widget.style.hideIcon)
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
