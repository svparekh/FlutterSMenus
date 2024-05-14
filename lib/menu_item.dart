import 'package:flutter/material.dart';

import 'base.dart';

enum SMenuItemType { clickable, label, switchable, custom }

/// A Menu Item. Note for the [SBaseDropdownMenu] : Use a SMenuItem.clickable
/// to be able to use the onChange function.
class SMenuItem<T> extends StatelessWidget {
  final SMenuItemType type;

  // Shared properties
  final T? value;
  final SMenuItemStyle style;

  /// The widget that is shown when the item is selected in a dropdown menu
  /// with the showSelected flag set to true.
  final Widget? preview;

  /// This allows an action to be done by the item. For dropdown menus, this is
  /// in addition to the onChange function being called.
  final void Function()? onPressed;

  // Custom Menu Item properties
  final Widget? child;
  final Widget Function(
      BuildContext context, SMenuItemStyle style, Widget? child)? builder;

  // Label Menu Item properties
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;

  // Switchable Menu Item properties
  final void Function(bool? value)? onToggle;
  final bool? toggled;
  // TODO: add ability to be used in onChange?
  const SMenuItem({
    super.key,
    this.child,
    this.builder,
    this.preview,
    this.style = const SMenuItemStyle(),
  })  : leading = null,
        trailing = null,
        title = null,
        value = null,
        onPressed = null,
        onToggle = null,
        toggled = null,
        type = SMenuItemType.custom
  // TODO: Make this work? SMenuItemButton doesn't work if this is enabled
  // assert(!(child == null && builder == null),
  // "SMenuItem error: A child or a builder must be provided."),
  ;

  const SMenuItem.clickable({
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
        type = SMenuItemType.clickable;

  const SMenuItem.label({
    super.key,
    this.preview,
    this.leading,
    this.trailing,
    this.title,
    this.style = const SMenuItemStyle(),
  })  : builder = null,
        child = null,
        value = null,
        onPressed = null,
        onToggle = null,
        toggled = null,
        type = SMenuItemType.label;

  /// WIP
  const SMenuItem.switchable({
    super.key,
    required this.onToggle,
    required this.toggled,
    this.title,
    this.style = const SMenuItemStyle(),
  })  : leading = null,
        trailing = null,
        preview = null,
        value = null,
        builder = null,
        child = null,
        onPressed = null,
        type = SMenuItemType.switchable;

  // TODO: wrap with Theme to use style.accentColor and style.bgColor
  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SMenuItemType.clickable:
      case SMenuItemType.label:
        return SizedBox(
          width: style.width,
          height: style.height,
          child: Padding(
            padding: style.padding ?? const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: style.alignment,
              children: [
                if (leading != null) leading!,
                Expanded(child: title ?? Container()),
                if (trailing != null) trailing!
              ],
            ),
          ),
        );
      case SMenuItemType.switchable:
        return AnimatedContainer(
          height: style.height,
          margin: const EdgeInsets.only(top: 5),
          duration: const Duration(milliseconds: 250),
          // TODO: Add checkbox options
          child: CheckboxListTile(
            activeColor: style.accentColor,
            value: toggled,
            // TODO: make checkbox work (overlay to new stateful widget?)
            onChanged: onToggle,
            title: title,
          ),
        );
      case SMenuItemType.custom:
        return builder == null
            ? (child ?? Container())
            : builder!(context, style, child);
      default:
        throw Exception(
            "Invalid instantiation of SMenuItem. Use SMenuItem, SMenuItem.label, or SMenuItem.switchable.");
    }
  }

  Widget getPreview(BuildContext context) {
    return preview ?? build(context);
  }
}
