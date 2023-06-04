
# FlutterMenus

A Flutter package for dropdown menus, many types of side menus, three dot menus, and popup menus.

<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.
For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).
For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.
  
### Menus:

|Name                 | Description                                                                                        |
|---------------------|----------------------------------------------------------------------------------------------------|
|SResiableMenu        |A menu that can be resized programatically or phsyically                                            |
|SSlideMenu           |A menu that either slides in, slides in while body slides away, or body slides away to reveal menu  |
|SDropdownMenuCascade |Classic dropdown menu [WIP]                                                                         |
|SDropdownMenuMorph   |Dropdown popup menu using Hero [WIP]                                                                |

## Getting started

TODO: List prerequisites and provide or point to information on how to start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples to `/example` folder.

### Menus

```dart
const SResizableMenu
const SResizableMenuNoWrapper
const SSlideMenu
```

### Menu Items

```dart
const SMenuItemButton
const SMenuItemCustom
```

### Classes

```dart
SMenuController
const SMenuState
const SMenuPosition
const SMenuStyle
const SMenuItemStyle
const SBaseMenu
const SBaseMenuState
```

### Custom Menu Items and Menu Builder

All menus support custom children.

```dart
items = <SMenuItem>[];
```

or

```dart
builder = (context) {
    return <Widget>
}
```

## Upcoming

```dart
const SDropdownMenuCascade
const SDropdownMenuMorph

const SMenuItemDropdown
const SMenuItemDropdownSelectable

const SDropdownMenuAlignment
const SDropdownMenuStyle

const SDropdownMenu
const SDropdownMenuState
```

> Note: Some features may not work with custom children

## Additional information

TODO: Tell users more about the package: where to find more information, how to contribute to the package, how to file issues, what response they can expect from the package authors, and more.