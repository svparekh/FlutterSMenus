# Change log

## 2.0.0

#### Removed
* Removed `SMenuItemDropdownSelectable`, `SMenuItem`, `SMenuItemDropdown`, and `SMenuItemCustom`. They have been replaced with `SMenuItem` and `SMenuItem.label`
* Removed `SlidePageRoute`, `FadePageRoute`, and `SlideDirection` as they are uneccessary and unrelated.
* Removed `SResizableMenuNoWrapper`. Instead, use the property `enableWrapper` in `SResizableMenu`.
* Removed selected indicator on `SResizableMenu`. This added unwarranted complexity. Instead, the user must implement the indicator. See **example.dart** for more details.
* Removed `SMenuItemButton` for same reason as indicator. Instead, the user must implement the button. See **example.dart** for more details.

#### Changed
* Renamed `SDropdownMenuAlignment` to `SDropdownMenuPosition`.
* Renamed `SDropdownMenu` to `SBaseDropdownMenu`.
* Changed how `SDropdownMenuCascade` and `SDropdownMenuMorph` handles items. It now only places an `InkWell` over the item if it has a `value` and the `onPressed` function is null (default). If the value is null or a function is given, the item will no longer display a preview of the item that is selected and the dropdown menu will not close when the item is clicked. The `onChange` function will not be called. This means that all functionality of the item will have to be handled by the given function.
* Changed `SMenuStyle`:
    * Removed `headerAlignment`, `footerAlignment`, `size`, and `barColor`.
    * Changed `borderRadius` to non-nullable and added default value of `const BorderRadius.all(Radius.circular(15))`.
    * Added `barrierColor` with default value `Colors.black26`.
    * Added a `copyWith` function that creates a new style object with same properties  except for properties that were provided in the function.
* Changed `SDropdownMenuStyle`:
    * Removed `alignment`, `width` and `height`. Now part of the dropdown menu class.
    * Changed `borderRadius` to non-nullable and added default value of `const BorderRadius.all(Radius.circular(15))`.
    * Added `barrierColor` default `Colors.black26`, `border`, `hideIcon` default `false`, `leadingIcon` default `false`, `showSelected` default `false`, and `isSmall` default `true`.
    * Added a `copyWith` function that creates a new style object with same properties  except for properties that were provided in the function.
* Changed `SMenuItemStyle`:
    * Removed `selectedAccentColor` and `selectedBgColor`.
    * Renamed mainAxisAlignment to alignment.
    * Changed `borderRadius` to non-nullable and added default value of `const BorderRadius.all(Radius.circular(15))`.
    * Added `mouseCursor`.
    * Added a `copyWith` function that creates a new style object with same properties  except for properties that were provided in the function.
* Changed `SDropdownMenuCascade`:
    * Moved `hideIcon`, `barrierColor`, `isSmall`, `showSelected`, and `leadingIcon` to `SDropdownMenuStyle`.
    * Added `height`, `width`, animation `curve`, `position`, and `builder`.
* Changed `SDropdownMenuMorph`:
    * Fixed bug where `showSelected` didn't work.
    * Renamed `itemStyle` to `buttonStyle`.
    * Moved `hideIcon`, `barrierColor`, `isSmall`, `showSelected`, and `leadingIcon` to `SDropdownMenuStyle`.
    * Added `height`, `width`, animation `curve`, `position`, and `builder`.
* Changed `SDropdownMenuCascade`:
    * Moved `hideIcon`, `barrierColor`, `isSmall`, `showSelected`, and `leadingIcon` to `SDropdownMenuStyle`.
    * Added `height`, `width`, animation `curve`, `position`, and `builder`.
* Changed `SResizableMenu`:
    * Removed `enableSelector` (see point #3 above for why).
    * Renamed `direction` to `scrollDirection`.
    * Moved `barrierColor` to `SMenuStyle`.
    * Added `closedSize` and `openSize`.
    * Added a new property `enableWrapper`, which does what `SResizableMenu` used to do (add a wrapper). This removed the need for a seperate class `SResizableMenuNoWrapper`.
* Changed `SSlideMenu`:
    * Removed `enableSelector` (see point #3 above for why).
    * Renamed `direction` to `scrollDirection`.
    * Added `closedSize` and `openSize`.
* Changed the `InkWell` so that shape, borderRadius, and colors now reflect each item's style rather than the style for the dropdown menu button.

#### Created
* Created `SBase` and `SBaseState` abstract classes which the `SBaseMenu` and `SBaseDropdownMenu` are derived from.
* Created `SMenuItemType` enum for the `SMenuItem` to be able to build a widget based on the type. Useful because `SMenuItem` now has multiple constructors. Internal use only.
* Created `SMenuItem` and `SMenuItem.label`. This works by having multiple constructors and settings variables not needed by that constructor to `null`. A new variable `SMenuItemType type` is introduced and is set by each constructor so that the build function knows how to build the widget. `preview` is introduced along with `previewWidget` function. The `preview` widget is what the user will see appear on the dropdown menu button when `showSelected = true`. If it is `null`, it uses the `build` method. `builder` was updated to include `onPressed`. WIP for `SMenuItem.switchable`, not yet available. See point #3 under *Changed* up above for more info on how `value` and `onPressed` affect the workings of a dropdown menu.

#### Other
* Updated README.md, code formatting, and example code
* Example code now have the indicator implemented rather than it being in-built in this package (for reasons explained above, see points #4 and #5 under *Removed*).
* Reorganized file/class system:
    * *(new)* base.dart
        * `SBase` **(not exposed)**
        * `SBaseState` **(not exposed)**
        * `SBaseDropdownMenu`
        * `SBaseDropdownMenuState`
        * `SBaseMenu`
        * `SBaseMenuState`
        * `SDropdownMenuStyle`
        * `SMenuItemStyle`
        * `SMenuStyle`
        * `SMenuController`
        * `SDropdownMenuPosition`
        * `SMenuPosition`
        * `SMenuState`
    * *(new)* helper.dart **(not exposed)**
        * `ResizeBar`
        * `_ResizeBarState`
        * `SDropdownMenuPopup`
        * `CustomHero`
        * `CustomRectTween`
        * `SPopupMenuRoute`
    * menu.dart
        * `SSlideMenu`
        * `_SSlideMenuState` **(not exposed)**
        * `SResizableMenu`
        * `_SRresizableMenuState` **(not exposed)**
    * dropdown.dart
        * `SDropdownMenuCascade`
        * `_SDropdownMenuCascadeState` **(not exposed)**
        * `SDropdownMenuMorph`
        * `_SDropdownMenuMorphState` **(not exposed)**
    * menu_item.dart
        * `SMenuItem`
        * `SMenuItemType` **(not exposed)**


## 1.0.1
* Added a ```Offset? offset``` paramter to ```SSlideMenu``` to help determine the location of the menu. Initially it is at location (0, 0)
* Added a ```BoxBorder? border``` paramter to ```SMenuStyle``` to add a border around the Resizable or Slide menus.
* Updated README.md, code formatting, and example code

## 1.0.0

* INITIAL RELEASE: Package officially released with four main types of menus. SMenuResizable, SSlideMenu, SDropdownMenuCascade, and SDropdownMenuMorph