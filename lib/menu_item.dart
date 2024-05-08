import 'package:flutter/material.dart';

import 'base.dart';

enum SMenuItemType { custom, label, switchable }

/// A Menu Item. Note for the [SBaseDropdownMenu] : It places an InkWell over the
/// item if it has a value and the onPressed (or onToggle) functions are null
/// (default). If the value is null or a function is given, the item will no
/// longer display a preview of the item that is selected and the dropdown
/// menu will not close when the item is clicked. The onChange function will
/// not be called. This means that all functionality of the item will have
/// to be handled by the given function.
class SMenuItem<T> extends StatelessWidget {
  final SMenuItemType type;

  // Shared properties
  final T? value;
  final SMenuItemStyle style;

  /// The widget that is shown when the item is selected in a dropdown menu
  /// with the showSelected flag set to true.
  final Widget? preview;

  /// Only provide this if you know what you are doing.
  /// This allows an action to be done by the item.
  /// Note for the [SBaseDropdownMenu] : It places an InkWell over the
  /// item if it has a value and the onPressed function is null
  /// (default). If the value is null or a function is given, the item will no
  /// longer display a preview of the item that is selected and the dropdown
  /// menu will not close when the item is clicked. The onChange function will
  /// not be called. This means that all functionality of the item will have
  /// to be handled by the given function. It would also be best to use the builder.
  final void Function()? onPressed;

  // Custom Menu Item properties
  final Widget? child;
  final Widget Function(BuildContext context, SMenuItemStyle style,
      Widget? child, void Function()? onPressed)? builder;

  // Label Menu Item properties
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;

  // Switchable Menu Item properties
  final void Function(bool? value)? onToggle;
  final bool? toggled;

  const SMenuItem({
    super.key,
    this.child,
    this.builder,
    this.preview,
    this.value,
    this.onPressed,
    this.style = const SMenuItemStyle(),
  })  : leading = null,
        trailing = null,
        title = null,
        onToggle = null,
        toggled = null,
        type = SMenuItemType.custom,
        assert(!(child == null && builder == null),
            "SMenuItem error: A child or a builder must be provided.");

  const SMenuItem.label({
    super.key,
    this.preview,
    this.value,
    this.onPressed,
    this.leading,
    this.trailing,
    this.title,
    this.style = const SMenuItemStyle(),
  })  : builder = null,
        child = null,
        onToggle = null,
        toggled = null,
        type = SMenuItemType.label;

  // No value since we want to be able to click the toggle
  // const SMenuItem.switchable({
  //   super.key,
  //   required this.onToggle,
  //   required this.toggled,
  //   this.style = const SMenuItemStyle(),
  // })  : leading = null,
  //       trailing = null,
  //       title = null,
  //       preview = null,
  //       value = null,
  //       builder = null,
  //       child = null,
  //       onPressed = null,
  //       type = SMenuItemType.switchable;

  // TODO: wrap with Theme to use style.accentColor and style.bgColor
  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SMenuItemType.label:
        return SizedBox(
          width: style.width,
          height: style.height,
          child: Padding(
            padding: style.padding ?? const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: style.alignment,
              children: [
                leading ?? const SizedBox.square(dimension: 10),
                Expanded(child: title ?? Container()),
                trailing ?? const SizedBox.square(dimension: 10)
              ],
            ),
          ),
        );
      case SMenuItemType.switchable:
        return AnimatedContainer(
          height: 40,
          margin: const EdgeInsets.only(top: 5),
          duration: const Duration(milliseconds: 250),
          child: CheckboxListTile(
            value: toggled,
            onChanged: onToggle,
            title: title,
          ),
        );
      case SMenuItemType.custom:
        return builder == null
            ? (child ?? Container())
            : builder!(context, style, child, onPressed);
      default:
        throw Exception(
            "Invalid instantiation of SMenuItem. Use SMenuItem, SMenuItem.label, or SMenuItem.switchable.");
    }
  }

  Widget getPreview(BuildContext context) {
    return preview ?? build(context);
  }
}
