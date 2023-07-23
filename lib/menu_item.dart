import 'package:flutter/material.dart';

import 'menu.dart';

abstract class SMenuItem<T> extends StatelessWidget {
  const SMenuItem({
    Key? key,
    this.value,
    this.style = const SMenuItemStyle(),
  }) : super(key: key);
  final T? value;
  final SMenuItemStyle? style;
}

class SMenuItemButton<T> extends SMenuItem {
  const SMenuItemButton({
    super.key,
    super.value,
    super.style,
    required this.icon,
    this.selectedTextColor,
    this.selectedIconColor,
    this.textColor,
    this.iconColor,
    this.title,
    this.isSelected = false,
    this.onPressed,
  });
  final IconData icon;
  final Color? selectedTextColor;
  final Color? selectedIconColor;
  final Color? textColor;
  final Color? iconColor;
  final String? title;
  final bool isSelected;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 45,
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        borderRadius: style?.borderRadius ?? BorderRadius.circular(7),
        color: isSelected
            ? style?.selectedBgColor ?? Theme.of(context).colorScheme.primary
            : style?.bgColor ?? Theme.of(context).colorScheme.onPrimary,
      ),
      duration: const Duration(milliseconds: 250),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
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
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
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
            ),
          ],
        ),
      ),
    );
  }
}

// Wrapper for abstract class MenuItem
class SMenuItemCustom<T> extends SMenuItem {
  final Widget? child;
  final Widget Function(
      BuildContext context, SMenuItemStyle? style, Widget? child)? builder;
  const SMenuItemCustom({
    super.key,
    super.value,
    super.style,
    this.child,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return builder == null
        ? (child ?? Container())
        : builder!(context, style, child);
  }
}
