
# Flutter SMenus

A Flutter package for dropdown menus, many types of side menus, three dot menus, and popup menus.
Almost any kind of menu can be created with this package with almost any style. The basic types of menu and their customizability is shown below. This package is super easy to use and includes the ability to customize the menus to the T. All menus support custom menu pages or custom menu items. There are animated resizable menus, dropdown menus, and traditional menus.
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

![SMenus, fire Flutter Menus](image.png)
# Features

See Showcase for visual on all types of menus and examples I've created.
  
## Menus:

|Name                 | Description                                                                                        |
|---------------------|----------------------------------------------------------------------------------------------------|
|SResiableMenu        |A menu that can be resized programatically or phsyically                                            |
|SSlideMenu           |A menu that either slides in, slides in while body slides away, or body slides away to reveal menu  |
|SDropdownMenuCascade |Classic dropdown menu [WIP]                                                                         |
|SDropdownMenuMorph   |Dropdown popup menu using Hero [WIP]                                                                |

# Getting started

## Install

Visit the Install tab for more information

Add this line to your pubspec.yaml

```yaml
dependencies:
    flutter_smenus: ^1.0.0
```

or run this in your project's terminal

```shell
$ flutter pub add flutter_smenus
```

> Remember to run ```flutter pub get```

Once you have done that, you are ready to use this package!

Have a look below to see how to implement the custom menus.
# Showcase


# Code

TODO: Include short and useful examples for package users. Add longer examples to `/example` folder.

Jump to:

SResizableMenu

SResizableMenuNoWrapper

SSlideMenu

SMenuItemButton

SMenuItemCustom

SMenuController

SMenuState

SMenuPosition

SMenuStyle

SMenuItemStyle



## SResizableMenu

```dart
SResizableMenu(
    controller: SMenuController(),
    position: SMenuPosition.left,
    items: [],
    body: Container(),
)
```

<details>
<summary>Parameters</summary>

Either ```items``` or ```builder``` must not be null

|Parameter             |Object Type                           |Default                          |Description                                                                                            |
|----------------------|--------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------|
|```style```           |SMenuStyle?                           |SMenuStyle()                     |Color, border radius, size, padding, alignment. See ```SMenuStyle```                                         |
|```controller```      |SMenuController?                      |SMenuController()                |Controller to open, close, or toggle menu                                                              |
|```items```           |List< SMenuItem>?                     |null                             |List of ```SMenuItem``` types that make the menu                                                             |
|```builder```         |Widget Function(BuildContext context)?|null                             |Builder function for custom menu                                                                       |
|```body```            |Widget?                               |Container()                      |The widget which contains the contents, or page                                                                                  |
|```header```          |Widget?                               |null                             |The widget at the top of the menu                                                                      |
|```footer```          |Widget?                               |null                             |The widget at the bottom of the menu                                                                   |
|```scrollPhysics```   |ScrollPhysics?                        |null                             |How the menu should scroll                                                                             |
|```direction```       |Axis?                                 |Axis.vertical                    |Scroll direction, this is set automatically. Do not change this unless you know what you are doing.    |
|```duration```        |Duration?                             |const Duration(milliseconds: 250)|The duration for the animation of openning and closing the menu                                        |
|```position```        |SMenuPosition?                        |SMenuPosition.left               |Which side of the screen the menu will be location                                                     |
|```enableSelector```  |bool?                                 |false                            |In the event your menu items are menu buttons, turn on this selector to show the current selected item.|
|```resizable```       |bool?                                 |true                             |If resizing bar should show                                                                            |
|```barColor```        |Color?                                |null                             |Color of resizing bar                                                                                  |
|```barHoverColor```   |Color?                                |null                             |Color of resizing bar when hovered                                                                     |
|```barSize```         |double?                               |3                                |Size of resizing bar                                                                                   |
|```barHoverSize```    |double?                               |5                                |Size of resizing bar when hovered                                                                      |


</details>


## SResizableMenuNoWrapper

```dart
Row(
    children: [
        SResizableMenuNoWrapper(
            controller: SMenuController(),
            position: SMenuPosition.left,
            items: [],
        ),
        Expanded(child: Container()),
    ],
)
```


<details>
<summary>Parameters</summary>

Either ```items``` or ```builder``` must not be null

|Parameter             |Object Type                           |Default                          |Description                                                                                            |
|----------------------|--------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------|
|```style```           |SMenuStyle?                           |SMenuStyle()                     |Color, border radius, size, padding, alignment. See ```SMenuStyle```                                         |
|```controller```      |SMenuController?                      |SMenuController()                |Controller to open, close, or toggle menu                                                              |
|```items```           |List< SMenuItem>?                     |null                             |List of ```SMenuItem``` types that make the menu                                                             |
|```builder```         |Widget Function(BuildContext context)?|null                             |Builder function for custom menu                                                                       |
|```header```          |Widget?                               |null                             |The widget at the top of the menu                                                                      |
|```footer```          |Widget?                               |null                             |The widget at the bottom of the menu                                                                   |
|```scrollPhysics```   |ScrollPhysics?                        |null                             |How the menu should scroll                                                                             |
|```direction```       |Axis?                                 |Axis.vertical                    |Scroll direction, this is set automatically. Do not change this unless you know what you are doing.    |
|```duration```        |Duration?                             |const Duration(milliseconds: 250)|The duration for the animation of openning and closing the menu                                        |
|```position```        |SMenuPosition?                        |SMenuPosition.left               |Which side of the screen the menu will be location                                                     |
|```enableSelector```  |bool?                                 |false                            |In the event your menu items are menu buttons, turn on this selector to show the current selected item.|
|```resizable```       |bool?                                 |true                             |If resizing bar should show                                                                            |
|```barColor```        |Color?                                |null                             |Color of resizing bar                                                                                  |
|```barHoverColor```   |Color?                                |null                             |Color of resizing bar when hovered                                                                     |
|```barSize```         |double?                               |3                                |Size of resizing bar                                                                                   |
|```barHoverSize```    |double?                               |5                                |Size of resizing bar when hovered                                                                      |


</details>


## SSlideMenu

```dart
SSlideMenu(
    controller: SMenuController(),
    position: SMenuPosition.left,
    items: [],
    isBodyMovable = false,
    body: Container(),
)
```

<details>
<summary>Parameters</summary>

Either ```items``` or ```builder``` must not be null

|Parameter             |Object Type                           |Default                          |Description                                                                                            |
|----------------------|--------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------|
|```style```           |SMenuStyle?                           |SMenuStyle()                     |Color, border radius, size, padding, alignment. See ```SMenuStyle```                                         |
|```controller```      |SMenuController?                      |SMenuController()                |Controller to open, close, or toggle menu                                                              |
|```items```           |List< SMenuItem>?                     |null                             |List of ```SMenuItem``` types that make the menu                                                             |
|```builder```         |Widget Function(BuildContext context)?|null                             |Builder function for custom menu                                                                       |
|```body```            |Widget?                               |Container()                      |The widget which contains the contents, or page                                                                                  |
|```header```          |Widget?                               |null                             |The widget at the top of the menu                                                                      |
|```footer```          |Widget?                               |null                             |The widget at the bottom of the menu                                                                   |
|```scrollPhysics```   |ScrollPhysics?                        |null                             |How the menu should scroll                                                                             |
|```direction```       |Axis?                                 |Axis.vertical                    |Scroll direction, this is set automatically. Do not change this unless you know what you are doing.    |
|```duration```        |Duration?                             |const Duration(milliseconds: 250)|The duration for the animation of openning and closing the menu                                        |
|```position```        |SMenuPosition?                        |SMenuPosition.left               |Which side of the screen the menu will be location                                                     |
|```enableSelector```  |bool?                                 |false                            |In the event your menu items are menu buttons, turn on this selector to show the current selected item.|
|```barrierColor```       |Color?                                 |true                             |When menu is open, this is the color overlayed on the body                                                                            |
|```enableGestures```        |bool?                                |null                             |If gestures can open, close, or toggle the menu                                                                                  |
|```isBodyMovable```   |bool?                                |true                             |Whether the body moves in the animation or not                                                                     |
|```isMenuMovable```         |bool?                               |true                                |Whether the menu moves in the animation or not                                                                                   |


</details>


## SDropdownMenuCascade

```dart
SDropdownMenuCascade(
    controller: SMenuController(),
    items: [],
    child: Container(),
)
```

<details>
<summary>Parameters</summary>

|Parameter             |Object Type                           |Default                          |Description                                                                                            |
|----------------------|--------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------|
|```items```           |List< SMenuItem< T>>                     |required                             |List of ```SMenuItem``` types, with a value, that make the menu                                                              |
|```style```           |SDropdownMenuStyle?                           |SDropdownMenuStyle()                     |Color, border radius, size, padding, alignment. See ```SDropdownMenuStyle```                                         |
|```controller```      |SMenuController?                      |SMenuController()                |Controller to open, close, or toggle menu                                                              |
|```header```          |Widget?                               |null                             |The widget at the top of the menu                                                                      |
|```footer```          |Widget?                               |null                             |The widget at the bottom of the menu                                                                   |
|```hideIcon```       |bool?                                 |false                    |If icon should be hidden    |
|```duration```        |Duration?                             |const Duration(milliseconds: 250)|The duration for the animation of openning and closing the menu                                        |
|```child```        |Widget?                        |null               |                                                     |
|```icon```  |Widget?                                 |null                            ||
|```leadingIcon```        |bool?                                |false                             |If Icon should come before text                                                                                  |
|```onChange```   |void Function(T value, int index)??                                |null                             |                                                                     |
|```showSelected```         |bool?                               |true                                |If selected widget should be displayed when menu is closed                                                                                   |
|```isSmall```         |bool?                               |false                                |                                                                                   |
|```buttonStyle```         |SMenuItemStyle?                               |SMenuItemStyle()                                |                                                                                   |
|```barrierColor```       |Color?                                 |Colors.black26                             |                                                                            |

</details>

## SDropdownMenuMorph

```dart
SDropdownMenuMorph(
    controller: SMenuController(),
    items: [],
    child: Container(),
)
```

<details>
<summary>Parameters</summary>

|Parameter             |Object Type                           |Default                          |Description                                                                                            |
|----------------------|--------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------|
|```items```           |List< SMenuItem< T>>                     |required                             |List of ```SMenuItem``` types, with a value, that make the menu                                                              |
|```style```           |SDropdownMenuStyle?                           |SDropdownMenuStyle()                     |Color, border radius, size, padding, alignment. See ```SDropdownMenuStyle```                                         |
|```controller```      |SMenuController?                      |SMenuController()                |Controller to open, close, or toggle menu                                                              |
|```header```          |Widget?                               |null                             |The widget at the top of the menu                                                                      |
|```footer```          |Widget?                               |null                             |The widget at the bottom of the menu                                                                   |
|```hideIcon```       |bool?                                 |false                    |If icon should be hidden    |
|```child```        |Widget?                        |null               |                                                     |
|```icon```  |Widget?                                 |null                            ||
|```leadingIcon```        |bool?                                |false                             |If Icon should come before text                                                                                  |
|```onChange```   |void Function(T value, int index)??                                |null                             |                                                                     |
|```showSelected```         |bool?                               |true                                |If selected widget should be displayed when menu is closed                                                                                   |
|```isSmall```         |bool?                               |false                                |                                                                                   |
|```itemStyle```         |SMenuItemStyle?                               |SMenuItemStyle()                                |                                                                                   |


</details>


## SMenuItemButton

```dart
SMenuItemButton(
    icon: Icons.home,
    value: 1,
    title: Text('Home'),
    isSelected: select,
    onPressed: () {
        setState((){
            select = !select;
        });
    }
)
```

<details>
<summary>Parameters</summary>

|Parameter             |Object Type                           |Default                          |Description                                                                                            |
|----------------------|--------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------|
|```icon```           |IconData                     |required                             |                                                              |
|```style```           |SMenuItemStyle?                           |SMenuItemStyle()                     |Color, border radius, size, padding, alignment. See ```SMenuItemStyle```                                         |
|```value```      |T?                      |null                |Controller to open, close, or toggle menu                                                              |
|```title```  |Widget?                                 |null                            ||
|```selectedTextColor```          |Color?                               |null                             |The widget at the top of the menu                                                                      |
|```selectedIconColor```          |Color?                               |null                             |The widget at the bottom of the menu                                                                   |
|```textColor```       |Color?                                 |null                    |If icon should be hidden    |
|```iconColor```        |Color?                        |null               |                                                     |
|```isSelected```  |bool?                                 |false                            ||
|```onPressed```        |void Function()?                                |null                             |If Icon should come before text                                                                                  |


</details>


## SMenuItemCustom


```dart
SMenuItemCustom(
    value: 'Custom Item',
    builder: () {
        return Text('Menu Item');
    }
)
```


<details>
<summary>Parameters</summary>

|Parameter             |Object Type                           |Default                          |Description                                                                                            |
|----------------------|--------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------|
|```child```           |Widget?                     |Container()          |The widget that makes up the menu item|
|```style```           |SMenuItemStyle?                           |SMenuItemStyle()                     |Color, border radius, size, padding, alignment. See ```SMenuItemStyle```                                         |
|```value```      |T?                      |null                |Controller to open, close, or toggle menu                                                              |
|```builder```  |Widget Function(BuildContext context, SMenuItemStyle? style, Widget? child)?                                 |null                            |If builder is not null, then the builder function will be used to make the menu item rather than the child. A builder function has parameters context, style, and child. This function should return a widget.|



</details>


## SMenuItemDropdown

```dart
SMenuItemDropdown(
    value: 1,
    title: Text('Dropdown Item')
)
```

<details>
<summary>Parameters</summary>

|Parameter             |Object Type                           |Default                          |Description                                                                                            |
|----------------------|--------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------|
|```value```      |T                      |required                |Controller to open, close, or toggle menu                                                              |
|```leading```           |Widget?                     |null          |The widget that makes up the menu item|
|```title```           |Widget?                     |null          |The widget that makes up the menu item|
|```trailing```           |Widget?                     |null          |The widget that makes up the menu item|
|```style```           |SMenuItemStyle?                           |SMenuItemStyle()                     |Color, border radius, size, padding, alignment. See ```SMenuItemStyle```                                         |
|```onPressed```        |void Function()?                                |null                             |If Icon should come before text                                                                                  |


</details>


## SMenuItemDropdownSelectable

ListTile version of ```SMenuItemDropdown```
```dart
SMenuItemDropdownSelectable(
    value: 1,
    title: Text('Dropdown Item')
)
```

<details>
<summary>Parameters</summary>

|Parameter             |Object Type                           |Default                          |Description                                                                                            |
|----------------------|--------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------|
|```value```      |T                      |required                |Controller to open, close, or toggle menu                                                              |
|```leading```           |Widget?                     |null          |The widget that makes up the menu item|
|```title```           |Widget?                     |null          |The widget that makes up the menu item|
|```trailing```           |Widget?                     |null          |The widget that makes up the menu item|
|```onPressed```        |void Function()?                                |null                             |If Icon should come before text                                                                                  |


</details>


## SMenuStyle


```dart
SMenuStyle(
    borderRadius: BorderRadius.circular(15),
    size: BoxContraints(minWidth: 50, maxWidth: 250)
)
```

<details>
<summary>Parameters</summary>

|Parameter             |Object Type                           |Default                          |Description                                                                                            |
|----------------------|--------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------|
|```borderRadius```      |BorderRadius?                      |null                | |
|```headerAlignment```      |MainAxisAlignment?                      |null                | |
|```padding```      |EdgeInsets?                      |null                | |
|```size```      |BoxConstraints?                      |null                | |
|```footerAlignment```      |MainAxisAlignment?                      |null                | |
|```alignment```      |MainAxisAlignment?                      |null                | |
|```barColor```      |Color?                      |null                | |
|```backgroundColor```      |Color?                      |null                | |


</details>


## SDropdownMenuStyle

```dart
SDropdownMenuStyle(
    borderRadius: BorderRadius.circular(15),
)
```

<details>
<summary>Parameters</summary>

|Parameter             |Object Type                           |Default                          |Description                                                                                            |
|----------------------|--------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------|
|```alignment```      |SDropdownMenuAlignment?                      |SDropdownMenuAlignment.bottomCenter                | |
|```constraints```      |BoxConstraints?                      |null                | |
|```offset```      |Offset?                      |null                | |
|```width```      |double                      |250                | |
|```height```      |double?                      |null                | |
|```elevation```      |double?                      |null                | |
|```color```      |Color?                      |null                | |
|```padding```      |EdgeInsets?                      |null                | |
|```borderRadius```      |BorderRadius?                      |null                | |

</details>


## SMenuItemStyle

```dart
SMenuItemStyle(
    borderRadius: BorderRadius.circular(15),
)
```

<details>
<summary>Parameters</summary>

|Parameter             |Object Type                           |Default                          |Description                                                                                            |
|----------------------|--------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------|
|```mainAxisAlignment```      |MainAxisAlignment?                      |null                | |
|```borderRadius```      |BorderRadius?                      |null                | |
|```shape```      |OutlinedBorder?                      |null                | |
|```elevation```      |double?                      |null                | |
|```padding```      |EdgeInsets?                      |null                | |
|```constraints```      |BoxConstraints?                      |null                | |
|```width```      |double?                      |null                | |
|```height```      |double?                      |null                | |
|```accentColor```      |Color?                      |null                | |
|```selectedAccentColor```      |Color?                      |null                | |
|```bgColor```      |Color?                      |null                | |
|```selectedBgColor```      |Color?                      |null                | |

</details>


## SMenuPosition

```dart
SMenuPosition.top
SMenuPosition.bottom
SMenuPosition.left
SMenuPosition.right
SMenuPosition.isVertical
SMenuPosition.isHorizontal
```

<details>
<summary>More Information</summary>

|Parameter             |Type |Description                           |
|----------------------|-|--------------------------------------|
|```SMenuPosition.top```      |Enum|Position the menu at the top of a screen|
|```SMenuPosition.bottom```      |Enum|Position the menu at the bottom of a screen|
|```SMenuPosition.left```      |Enum|Position the menu to the left of a screen|
|```SMenuPosition.right```      |Enum|Position the menu to the right of a screen|
|```SMenuPosition.isVertical```      |bool|True if position is currently set to top or bottom|
|```SMenuPosition.isHorizontal```      |bool|True if position is currently set to left or right|


</details>


## SDropdownMenuAlignment

```dart
SDropdownMenuAlignment.topLeft
SDropdownMenuAlignment.topCenter
SDropdownMenuAlignment.topRight
SDropdownMenuAlignment.centerLeft
SDropdownMenuAlignment.center
SDropdownMenuAlignment.centerRight
SDropdownMenuAlignment.bottomLeft
SDropdownMenuAlignment.bottomCenter
SDropdownMenuAlignment.bottomRight
```

<details>
<summary>More Information</summary>

Dropdown button is located at the center. The dropdown will open in these directions as specificed by the alignment:

||||
|-|-|-|
|  Top Left  |  Top Center  |  Top Right  |
|  Center Left  |  Center  |  Center Right  |
|  Bottom Left  |  Bottom Center  |  Bottom RIght  |

</details>


## SMenuController

```dart
SMenuController.open()
SMenuController.close()
SMenuController.toggle()
SMenuController.state
    -> SMenuController.state.addListenter()
    -> SMenuController.state.removeListenter()
    -> SMenuController.state.value = <SMenuState>
    -> ... other ValueNotifier methods
```

<details>
<summary>More Information</summary>


|Parameter             |Type |Description                           |
|----------------------|-|--------------------------------------|
|```SMenuController.open()```      |Method|Open the menu that this controller is assigned to|
|```SMenuController.close()```      |Method|Close the menu that this controller is assigned to|
|```SMenuController.toggle()```      |Method|Toggle the menu that this controller is assigned to|
|```SMenuController.state```      |ValueNotifier< SMenuState>|A value notifier that will send an update when the state of the menu changes. The value of this notifier is ```SMenuState```|

</details>


## SMenuState

```dart
SMenuState.open
SMenuState.closed
SMenuState.opening
SMenuState.closing
```

<details>
<summary>More Information</summary>


|Parameter             | Description                           |
|----------------------|--------------------------------------|
|```SMenuState.open```      |The menu is currently not fully closed|
|```SMenuState.closed```      |The menu is currently fully closed|
|```SMenuState.opening```      |The menu is currently in the process of opening. The animation to open is still playing|
|```SMenuState.closing```      |The menu is currently in the process of closing. The animation to close is still playing|

</details>



# Additional information

More: -

Contribute: -

Issues: -


> Note: Some features may not work with custom children, this includes but is not limited to dropdown menus having nuances with values, having picked item displayed, or even the inkwell to display clicking. These work fine with ```SMenuItem```, but custom items may have issues. Use at your own risk.