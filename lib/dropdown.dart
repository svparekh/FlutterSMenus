import 'package:flutter/material.dart';

import 'base.dart';
import 'helper.dart';
import 'menu_item.dart';

// TODO: Add builder to dropdowns

/// A dropdown menu that uses an Overlay. This is a classic type of dropdown menu.
/// Use a SMenuItem.clickable if you would like the onChange function of
/// this dropdown to run. The item's value will be made available through it.
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
          side: widget.buttonStyle.side,
          enabledMouseCursor: widget.buttonStyle.mouseCursor,
          padding: widget.buttonStyle.padding ?? const EdgeInsets.all(0),
          backgroundColor: widget.buttonStyle.bgColor ??
              Theme.of(context).colorScheme.background,
          elevation: widget.buttonStyle.elevation,
          foregroundColor: widget.buttonStyle.accentColor,
          shape: widget.buttonStyle.shape ??
              RoundedRectangleBorder(
                  borderRadius: widget.buttonStyle.borderRadius),
        ),
        onPressed: toggleMenu,
        child: Row(
          mainAxisAlignment: widget.buttonStyle.alignment,
          textDirection:
              widget.style.leadingIcon ? TextDirection.rtl : TextDirection.ltr,
          mainAxisSize: MainAxisSize.min,
          children: [
            // if the widget is not set to be small, place a child, otherwise go to icon
            if (!(widget.style.isSmall))
              // if we are to show the selected item, else show child if given
              if (widget.style.showSelected)
                // show selected item if one is selected
                if (_currentIndex >= 0) ...[
                  Flexible(
                      child: widget.items[_currentIndex].getPreview(context)),
                ] else ...[
                  // show child if item has not been selected and child it not null, otherwise show nothing
                  if ((_currentIndex <= 0) && (widget.child != null))
                    Flexible(child: widget.child!),
                ]
              else ...[
                if (widget.child != null) Flexible(child: widget.child!),
              ],
            // place icon if not hidden
            if (!widget.style.hideIcon)
              Flexible(
                child: RotationTransition(
                  turns: _rotateIconAnimation,
                  child: widget.icon ?? const Icon(Icons.expand_more_rounded),
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
                      color: widget.style.color ??
                          Theme.of(context).colorScheme.background,
                      child: ConstrainedBox(
                        // TODO: to container
                        constraints: widget.style.constraints ??
                            BoxConstraints(
                              maxWidth: widget.width,
                              maxHeight: widget.height,
                            ),
                        child: SizedBox(
                          // TODO: to container
                          height: widget
                              .height, // TODO: to container: padding: widget.style.padding ?? EdgeInsets.zero,
                          child: buildMenu(onTap: (element) {
                            // If an onTap is available, use it to call onChange
                            setState(() => _currentIndex = element.key);
                            if (widget.onChange != null) {
                              widget.onChange!(
                                  element.value.value as T, element.key);
                            }

                            toggleMenu(close: true);
                          }),
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

/// A current WIP. Uses a Hero widget to create a dropdown menu. This can be used
/// as a popup menu.
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
              buildMenu: buildMenu,
              position: calcPopupPosition(renderKey.currentContext!),
              tag: key,
              items: widget.items,
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
        child: SizedBox(
          //TODO : was a container, shouldnt cause issue
          key: renderKey,
          width: widget.buttonStyle.width,
          height: widget.buttonStyle.height,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: widget.buttonStyle.side,
              padding: widget.buttonStyle.padding ?? const EdgeInsets.all(0),
              backgroundColor: widget.buttonStyle.bgColor ??
                  Theme.of(context).colorScheme.background,
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
                // if the widget is not set to be small, place a child, otherwise go to icon
                if (!(widget.style.isSmall))
                  // if we are to show the selected item, else show child if given
                  if (widget.style.showSelected)
                    // show selected item if one is selected
                    if (_currentIndex >= 0) ...[
                      Flexible(
                          child:
                              widget.items[_currentIndex].getPreview(context)),
                    ] else ...[
                      // show child if item has not been selected and child it not null, otherwise show nothing
                      if ((_currentIndex <= 0) && (widget.child != null))
                        Flexible(child: widget.child!),
                    ]
                  else ...[
                    if (widget.child != null) Flexible(child: widget.child!),
                  ],
                if (!widget.style.hideIcon)
                  Flexible(
                    // TODO: add option to disable rotation
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
