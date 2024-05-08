import 'package:flutter/material.dart';

import 'menu_item.dart';

/// All possible menu states
enum SMenuState { open, closed, opening, closing }

/// The controller for all menus. Can open, close, toggle, the menu.
/// Has a [ValueNotifier] for state that will notify when [SMenuState] changes.
class SMenuController {
  /// Open the menu that this controller controls.
  late void Function() open;

  /// Close the menu that this controller controls.
  late void Function() close;

  /// Toggle the menu that this controller controls. If it is open, it closes,
  /// if closed, then it opens.
  late void Function() toggle;

  /// A [ValueNotifier] for current menu state that will notify when the
  /// state changes. Possible values are of type [SMenuState].
  final ValueNotifier<SMenuState> state =
      ValueNotifier<SMenuState>(SMenuState.closed);
}

/// All possible positions (i.e. locations) of the menu
enum SMenuPosition {
  /// Menu is positioned on the left and opens to the right
  right,

  /// Menu is positioned on the right and opens to the left
  left,

  /// Menu is positioned on the bottom and opens upward
  bottom,

  /// Menu is positioned on the top and opens downward
  top;

  /// True if current enum value is vertical (i.e. top or bottom)
  bool get isVertical =>
      this == SMenuPosition.top || this == SMenuPosition.bottom;

  /// True if current enum value is horizontal (i.e. left or right)
  bool get isHorizontal =>
      this == SMenuPosition.left || this == SMenuPosition.right;
}

/// Position of the dropdown menu relative to the dropdown menu button
enum SDropdownMenuPosition {
  /// The dropdown menu opens to the top left of the dropdown menu button
  topLeft,

  /// The dropdown menu opens to the top left of the dropdown menu button
  topCenter,

  /// The dropdown menu opens to the top center of the dropdown menu button
  topRight,

  /// The dropdown menu opens to the top right of the dropdown menu button
  centerLeft,

  /// The dropdown menu opens to the center left of the dropdown menu button
  center,

  /// The dropdown menu opens to the center of the dropdown menu button
  centerRight,

  /// The dropdown menu opens to the center right left of the dropdown menu button
  bottomLeft,

  /// The dropdown menu opens to the bottom left of the dropdown menu button
  bottomCenter,

  /// The dropdown menu opens to the bottom center of the dropdown menu button
  bottomRight

  /// The dropdown menu opens to the bottom right of the dropdown menu button
}

/// Style of the side menu. Styles contain colors, borders, alignments, padding
class SMenuStyle {
  /// The border radius of the menu
  final BorderRadius borderRadius;

  /// The padding around the menu
  final EdgeInsets? padding;

  /// The border around the menu
  final BoxBorder? border;

  /// Alignment of widgets within the menu
  final CrossAxisAlignment? alignment;

  /// For slide menu, the color that is the background of
  /// the screen when the menu opens. Usually is translucent so the app can
  /// still be seen. This is the same region where "clicking off" the menu
  /// will close it. Below menu but on top of menu body.
  final Color barrierColor;

  /// The background color of the menu
  final Color? backgroundColor;

  const SMenuStyle({
    this.barrierColor = Colors.black26,
    this.backgroundColor,
    this.border,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.alignment,
  });

  /// Creates a new style object with same properties as this style object
  /// except for properties that were provided in the function.
  SMenuStyle copyWith({
    final BorderRadius? borderRadius,
    final EdgeInsets? padding,
    final BoxBorder? border,
    final CrossAxisAlignment? alignment,
    final Color? barrierColor,
    final Color? backgroundColor,
  }) {
    return SMenuStyle(
      alignment: alignment ?? this.alignment,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      barrierColor: barrierColor ?? this.barrierColor,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
    );
  }
}

/// Style of the dropdown menu
class SDropdownMenuStyle {
  /// The border radius of the menu
  final BorderRadius borderRadius;

  /// The elavation, or shadow, applied to the menu
  final double? elevation;

  /// The color of the background of the menu, size of the background is
  /// determined by width and height given. Default is transparent.
  final Color? color;

  /// The padding around the menu
  final EdgeInsets? padding;

  /// The border around the menu
  final BoxBorder? border;

  /// The size contraints for the dropdown, used TODO: what is this for
  final BoxConstraints? constraints;

  /// For dropdown menus or slide menus, the color that is the background of
  /// the screen when the menu opens. Usually is translucent so the app can
  /// still be seen. This is the same region where "clicking off" the menu
  /// will close it. Below menu but on top of menu body.
  final Color barrierColor;

  /// Add an offset to the position of the menu that has been calculated from
  /// [SDropdownMenuPosition]. Move the top left of the dropdown relative to
  /// the top left of the button.
  final Offset? offset;

  /// If true, icon will not be shown, default is false
  final bool hideIcon;

  /// If true, the icon will move to left of text, default is false
  final bool leadingIcon;

  /// If true, the selected object's preview widget will replace the text and
  /// icon on the dropdown button to show what is selected, default is false.
  final bool showSelected;

  /// If true, doesn't show the selected item, doesn't show the child, only
  /// shows the icon. If hideIcon is also true the dropdown button will be an
  /// empty button according to [SMenuItemStyle].
  final bool isSmall;

  const SDropdownMenuStyle({
    this.border,
    this.barrierColor = Colors.black26,
    this.isSmall = true,
    this.showSelected = false,
    this.leadingIcon = false,
    this.hideIcon = false,
    this.constraints,
    this.offset,
    this.elevation,
    this.color,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
  });

  /// Creates a new style object with same properties as this style object
  /// except for properties that were provided in the function.
  SDropdownMenuStyle copyWith({
    final BorderRadius? borderRadius,
    final double? elevation,
    final Color? color,
    final EdgeInsets? padding,
    final BoxConstraints? constraints,
    final Color? barrierColor,
    final Offset? offset,
    final bool? hideIcon,
    final bool? leadingIcon,
    final bool? showSelected,
    final bool? isSmall,
    final BoxBorder? border,
  }) {
    return SDropdownMenuStyle(
      elevation: elevation ?? this.elevation,
      color: color ?? this.color,
      barrierColor: barrierColor ?? this.barrierColor,
      constraints: constraints ?? this.constraints,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      offset: offset ?? this.offset,
      hideIcon: hideIcon ?? this.hideIcon,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      showSelected: showSelected ?? this.showSelected,
      isSmall: isSmall ?? this.isSmall,
      border: border ?? this.border,
    );
  }
}

/// Style of an item inside a menu
class SMenuItemStyle {
  /// The alignment of the flex widget the makes up the item
  final MainAxisAlignment alignment;

  /// The border radius of the item
  final BorderRadius borderRadius;

  /// The shape of the item, overwrites border radius for the item (contained in shape)
  final OutlinedBorder? shape;

  /// The drop shadow amount determined by elevation
  final double? elevation;

  /// The padding to apply around the item
  final EdgeInsets? padding;

  /// The width of the item
  final double? width;

  /// The height of the item
  final double? height;

  /// The primary color used for text, icons, etc.
  final Color? accentColor;

  /// The background color of the item
  final Color? bgColor;

  /// The cursor of the mouse when hovering over the item
  final MouseCursor? mouseCursor;

  const SMenuItemStyle({
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.accentColor,
    this.bgColor,
    this.mouseCursor,
    this.alignment = MainAxisAlignment.start,
    this.height,
    this.width,
    this.elevation,
    this.padding,
    this.shape,
  });

  /// Creates a new style object with same properties as this style object
  /// except for properties that were provided in the function.
  SMenuItemStyle copyWith({
    final MainAxisAlignment? alignment,
    final BorderRadius? borderRadius,
    final OutlinedBorder? shape,
    final double? elevation,
    final EdgeInsets? padding,
    final double? width,
    final double? height,
    final Color? accentColor,
    final Color? bgColor,
  }) {
    return SMenuItemStyle(
      elevation: elevation ?? this.elevation,
      alignment: alignment ?? this.alignment,
      shape: shape ?? this.shape,
      width: width ?? this.width,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      height: height ?? this.height,
      accentColor: accentColor ?? this.accentColor,
      bgColor: bgColor ?? this.bgColor,
    );
  }
}

/// The base for all menus.
/// This class contains functions and variables that are consistent
/// between different types of menus.
/// The [State] class is responsible for setting up the controller and animation
/// controller. [SMenuController] functions such as open or close must be implemented
/// by derived class.
abstract class SBase extends StatefulWidget {
  const SBase({
    super.key,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOutCirc,
    this.items,
    this.header,
    this.footer,
    this.controller,
    this.builder,
  }) : assert(
          !(builder == null && items == null),
          "SMenus: Menus require 'builder' and/or 'items' argument to be populated.",
        );

  /// The animation duration
  final Duration duration;

  /// The animation curve
  final Curve curve;

  /// The optional controller for this menu
  final SMenuController? controller;

  /// Items that make up the menu
  final List<SMenuItem>? items;

  /// The builder that makes the menu
  final Widget Function(BuildContext context, List<SMenuItem>? items)? builder;

  /// The widget at the top of the menu
  final Widget? header;

  /// The widget at the bottom of the menu
  final Widget? footer;

  @override
  State<SBase> createState();
}

/// Responsible for setting up the controller and animation
/// controller. SMenuController functions such as open or close must be
/// implemented by derived class.
abstract class SBaseState<T extends SBase> extends State<T>
    with TickerProviderStateMixin {
  /// The controller responsible for animating the menu. The animation controls
  /// the menu opening and closing.
  late final AnimationController animationController;

  /// The controller for this menu. Default is internal controller, but an
  /// external one (i.e. from class parameter) can be provided and is set to
  /// this variable in the initState() function.
  SMenuController controller = SMenuController();

  /// The function responsible for performing the open menu task. Controller open
  /// function is set to this function.
  void openMenu();

  /// The function responsible for performing the close menu task. Controller close
  /// function is set to this function.
  void closeMenu();

  /// The function responsible for performing the toggle menu task. Controller toggle
  /// function is set to this function.
  void toggleMenu();

  @override
  void initState() {
    super.initState();
    // Setup the menu controller
    if (widget.controller != null) {
      // If an controller is provided, use it. Otherwise use internal controller
      controller = widget.controller!;
    }
    // Set the controller functions
    controller.open = openMenu;
    controller.close = closeMenu;
    controller.toggle = toggleMenu;

    // Setup animation controller with given duration
    animationController =
        AnimationController(vsync: this, duration: widget.duration);
    // Add a listener to the animation controller so that we can update
    // the menu controller state based on animation state.
    animationController.addStatusListener((status) {
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
    // Remove animation controller and its listener
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

/// The base for all regular menus (i.e. not dropdowns).
/// This class contains functions and variables that are consistent
/// between different types of regular menus.
/// The [State] class is responsible for setting up the controller functions
/// and the actual animation, which is a [Tween].
/// A funciton is introduced to build the child (i.e. put [SMenuItem]s in scroll view).
abstract class SBaseMenu extends SBase {
  const SBaseMenu({
    super.key,
    super.duration,
    super.items,
    super.builder,
    super.header,
    super.footer,
    super.controller,
    this.style = const SMenuStyle(),
    this.scrollDirection = Axis.vertical,
    this.position = SMenuPosition.left,
    this.openSize = 250.0,
    this.closedSize = 50.0,
    this.scrollPhysics,
  });

  /// The position (AKA location) of the menu
  final SMenuPosition position;

  /// The style of the menu
  final SMenuStyle style;

  /// The direction that the menu scrolls
  final Axis scrollDirection;

  /// The size of the menu when it is opened
  final double openSize;

  /// The size of the menu when it is closed
  final double closedSize;

  /// The menu's scroll physics, or how the menu scrolls
  final ScrollPhysics? scrollPhysics;

  @override
  State<SBaseMenu> createState();
}

/// Responsible for setting up the controller functions
/// and the actual animation, which is a [Tween].
/// A funciton is introduced to build the child (i.e. put [SMenuItem]s in scroll view).
abstract class SBaseMenuState<T extends SBaseMenu> extends SBaseState<T> {
  late final Animation animation;

  @override
  void openMenu() {
    animationController.forward();
  }

  @override
  void closeMenu() {
    animationController.reverse();
  }

  @override
  void toggleMenu() {
    if (animationController.isCompleted) {
      closeMenu();
    } else {
      openMenu();
    }
  }

  @override
  void initState() {
    super.initState();

    // Setup the actual animation, it is a tween from closed size to open size
    animation = Tween<double>(begin: widget.closedSize, end: widget.openSize)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: widget.curve,
            reverseCurve: widget.curve));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  /// Given the builder and items, build the actual menu. Uses a
  /// [SingleChildScrollView] if builder is null, or directly uses builder if given.
  Widget buildChild() {
    if (widget.builder == null) {
      return SingleChildScrollView(
        scrollDirection: widget.scrollDirection,
        child: Flex(
          mainAxisSize: MainAxisSize.min,
          direction: widget.scrollDirection,
          children: widget.items!,
        ),
      );
    } else {
      return widget.builder!(context, widget.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

abstract class SBaseDropdownMenu<T> extends SBase {
  const SBaseDropdownMenu({
    super.key,
    required super.items,
    super.duration,
    super.curve,
    super.controller,
    super.header,
    super.footer,
    super.builder,
    this.width = 250,
    this.height = 350,
    this.style = const SDropdownMenuStyle(),
    this.position = SDropdownMenuPosition.bottomCenter,
    this.icon,
    this.child,
    this.onChange,
    this.buttonStyle = const SMenuItemStyle(),
  });

  /// The style of the dropdown menu button
  final SMenuItemStyle buttonStyle;

  /// The child widget for the dropdown menu button
  final Widget? child;

  /// The position that the menu will open relative to the button.
  final SDropdownMenuPosition? position;

  /// Dropdown button icon, defaults to Caret
  final Widget? icon;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(T value, int index)? onChange;

  /// Style
  final SDropdownMenuStyle style;

  /// Width of this menu. Button width must be set for this to take effect
  final double width;

  /// Height of the menu
  final double height;

  @override
  State<SBaseDropdownMenu<T>> createState();
}

abstract class SBaseDropdownMenuState<T extends SBaseDropdownMenu>
    extends SBaseState<T> {
  /// Calculate the location from (0, 0) of the screen if the menu is located at
  /// the top left of the dropdown button. Given the location of the button
  /// (offset), the size of the popup menu, and the size of the dropdown menu
  /// button, calculate location of the menu.
  Offset topLeftPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(
      offset.dx - popupSize.width,
      offset.dy - popupSize.height,
    );
  }

  /// Calculate the location from (0, 0) of the screen if the menu is located at
  /// the top center of the dropdown button. Given the location of the button
  /// (offset), the size of the popup menu, and the size of the dropdown menu
  /// button, calculate location of the menu.
  Offset topCenterPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(
      offset.dx + (buttonSize.width / 2) - (popupSize.width / 2),
      offset.dy - popupSize.height,
    );
  }

  /// Calculate the location from (0, 0) of the screen if the menu is located at
  /// the top right of the dropdown button. Given the location of the button
  /// (offset), the size of the popup menu, and the size of the dropdown menu
  /// button, calculate location of the menu.
  Offset topRightPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(
      offset.dx + buttonSize.width,
      offset.dy - popupSize.height,
    );
  }

  /// Calculate the location from (0, 0) of the screen if the menu is located at
  /// the center left of the dropdown button. Given the location of the button
  /// (offset), the size of the popup menu, and the size of the dropdown menu
  /// button, calculate location of the menu.
  Offset centerLeftPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(
      offset.dx - popupSize.width,
      offset.dy + (buttonSize.height / 2) - (popupSize.height / 2),
    );
  }

  /// Calculate the location from (0, 0) of the screen if the menu is located at
  /// the center of the dropdown button. Given the location of the button
  /// (offset), the size of the popup menu, and the size of the dropdown
  /// menu button, calculate location of the menu.
  Offset centerPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(
      offset.dx + (buttonSize.width / 2) - (popupSize.width / 2),
      offset.dy + (buttonSize.height / 2) - (popupSize.height / 2),
    );
  }

  /// Calculate the location from (0, 0) of the screen if the menu is located at
  /// the center right of the dropdown button. Given the location of the button
  /// (offset), the size of the popup menu, and the size of the dropdown menu
  /// button, calculate location of the menu.
  Offset centerRightPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(offset.dx + buttonSize.width,
        offset.dy + (buttonSize.height / 2) - (popupSize.height / 2));
  }

  /// Calculate the location from (0, 0) of the screen if the menu is located at
  /// the bottom left of the dropdown button. Given the location of the button
  /// (offset), the size of the popup menu, and the size of the dropdown menu
  /// button, calculate location of the menu.
  Offset bottomLeftPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(offset.dx - popupSize.width, offset.dy + buttonSize.height);
  }

  /// Calculate the location from (0, 0) of the screen if the menu is located at
  /// the bottom center of the dropdown button. Given the location of the button
  /// (offset), the size of the popup menu, and the size of the dropdown menu
  /// button, calculate location of the menu.
  Offset bottomCenterPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(offset.dx - (popupSize.width / 2) + (buttonSize.width / 2),
        offset.dy + buttonSize.height);
  }

  /// Calculate the location from (0, 0) of the screen if the menu is located at
  /// the bottom right of the dropdown button. Given the location of the button
  /// (offset), the size of the popup menu, and the size of the dropdown menu
  /// button, calculate location of the menu.
  Offset bottomRightPositionCalculation(
      Size buttonSize, Size popupSize, Offset offset) {
    return Offset(offset.dx + buttonSize.width, offset.dy + buttonSize.height);
  }

  /// Calculate the position of the menu. Finds dropdown button size, window size,
  /// and popup menu size. Then finds location of the dropdown button. Finally,
  /// depending on the [SDropdownMenuPosition], this function will calculate the
  /// location of the menu (from its top left corner) relative to the screen's
  /// (0, 0) coordinate. Also adjusts the positon of the menu will be out of
  /// screen bounds (thus making it clip off screen)
  Offset calcPopupPosition(BuildContext context) {
    // Get the render box for finding size
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    // Get button size
    Size buttonSize = renderBox.size;
    // Get user provided offset
    Offset styleOffset = widget.style.offset ?? Offset.zero;
    // Get window size
    Size windowSize = MediaQuery.of(context).size;
    // Get popup menu size
    Size popupSize = Size(widget.width, widget.height);
    // Get location of the widget
    Offset offset = renderBox.localToGlobal(Offset.zero);

    // The returned location of the menu's top left corner
    Offset answer;

    // Calculate menu position
    switch (widget.position) {
      case SDropdownMenuPosition.topLeft:
        answer = topLeftPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuPosition.topCenter:
        answer = topCenterPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuPosition.topRight:
        answer = topRightPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuPosition.centerLeft:
        answer = centerLeftPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuPosition.center:
        answer = centerPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuPosition.centerRight:
        answer = centerRightPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuPosition.bottomLeft:
        answer = bottomLeftPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuPosition.bottomRight:
        answer = bottomRightPositionCalculation(buttonSize, popupSize, offset);
        break;
      case SDropdownMenuPosition.bottomCenter:
      default:
        // default is bottom center
        answer = bottomCenterPositionCalculation(buttonSize, popupSize, offset);
        break;
    }

    // Add given offset
    answer = Offset(answer.dx + styleOffset.dx, answer.dy + styleOffset.dy);

    // Bounds checking
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
