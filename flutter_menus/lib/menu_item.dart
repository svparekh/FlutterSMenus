import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'menu.dart';

abstract class SMenuItem<T> extends StatelessWidget {
  const SMenuItem({
    Key? key,
    this.value,
    this.style,
  }) : super(key: key);
  final T? value;
  final SMenuItemStyle? style;
}

class SMenuItemButton<T> extends SMenuItem {
  const SMenuItemButton({
    Key? key,
    T? value,
    SMenuItemStyle? style = const SMenuItemStyle(),
    required this.icon,
    this.selectedTextColor,
    this.selectedIconColor,
    this.textColor,
    this.iconColor,
    this.title,
    this.isSelected = false,
    required this.onPressed,
  })  : assert(isSelected != null),
        super(key: key, value: value, style: style);
  final IconData icon;
  final Color? selectedTextColor;
  final Color? selectedIconColor;
  final Color? textColor;
  final Color? iconColor;
  final String? title;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 45,
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: isSelected
            ? style?.selectedBgColor ?? Theme.of(context).colorScheme.primary
            : style?.bgColor ?? Theme.of(context).colorScheme.background,
      ),
      duration: Duration(milliseconds: 250),
      child: TextButton.icon(
        onPressed: () {
          onPressed();
        },
        icon: Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Icon(
              icon,
              color: isSelected
                  ? style?.selectedAccentColor ??
                      selectedIconColor ??
                      Theme.of(context).colorScheme.onPrimary
                  : style?.accentColor ??
                      iconColor ??
                      Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        label: Text(
          title ?? '',
          style: TextStyle(
              color: isSelected
                  ? style?.selectedAccentColor ??
                      selectedTextColor ??
                      Theme.of(context).colorScheme.onPrimary
                  : style?.accentColor ??
                      textColor ??
                      Theme.of(context).colorScheme.primary),
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
      ),
    );
  }
}

// Wrapper for abstract class MenuItem
class SMenuItemCustom<T> extends SMenuItem {
  final Widget? child;
  const SMenuItemCustom({Key? key, T? value, SMenuItemStyle? style, this.child})
      : super(
          key: key,
          value: value,
          style: style,
        );

  @override
  Widget build(BuildContext context) {
    return child ?? Container();
  }
}

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
      child: Material(
        shape: style?.shape ??
            RoundedRectangleBorder(
                borderRadius: style?.borderRadius ?? BorderRadius.circular(15)),
        color: style?.bgColor ?? Colors.white,
        child: Padding(
          padding: style?.padding ?? const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Flexible(child: leading ?? Container()),
              Flexible(child: title ?? Container()),
              Flexible(child: trailing ?? Container())
            ],
          ),
        ),
      ),
    );
  }
}

class SMenuItemDropdownSelectable extends SMenuItem {
  const SMenuItemDropdownSelectable({
    this.onPressed,
    Key? key,
    this.leading,
    this.title,
    this.trailing,
  }) : super(key: key);
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 40,
      margin: EdgeInsets.only(top: 5),
      duration: Duration(milliseconds: 250),
      child: ListTile(
        onTap: onPressed,
        leading: leading,
        title: title,
        trailing: trailing,
      ),
    );
  }
}
