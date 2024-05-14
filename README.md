<div align="center"> 
<h2 align="center">Flutter SMenus</h2> 
<img height="160" align="center"  alt="logo" src="https://raw.githubusercontent.com/svparekh/fluttermenus/main/smenus_logo.png"/>
</br>
<a href="https://github.com/svparekh/fluttermenus/blob/main/LICENSE">  
  <img alt="GitHub" src="https://img.shields.io/github/license/svparekh/fluttermenus"> 
</a>  
<a href="https://pub.dev/packages/flutter_smenus">  
  <img alt="Pub Version" src="https://img.shields.io/pub/v/flutter_smenus" />
</a>  
<a>  
  <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/svparekh/fluttermenus">  
</a>  
</div>
</br>
Custom menus designed to your imagination!

A Flutter package for dropdown menus, many types of side menus, sliding menus, resizable menus, three dot menus, and popup menus.
Almost any kind of menu can be created with this package with almost any style. The basic types of menu and their customizability is shown below. This package is super easy to use and includes the ability to customize the menus to the your imagination. All menus support custom menu pages or custom menu items. There are animated resizable menus, dropdown menus, and traditional menus.

# Features

See Showcase for visual on all types of menus and examples I've created.

## Menus

These are the main menus included in this package. Each support custom menu items, see below.

| Name                 | Description                                                                                        |
|----------------------|----------------------------------------------------------------------------------------------------|
| SResizableMenu       | A menu that can be resized programatically or phsyically                                           |
| SSlideMenu           | A menu that either slides in, slides in while body slides away, or body slides away to reveal menu |
| SDropdownMenuCascade | Classic dropdown menu                                                                              |
| SDropdownMenuMorph   | Dropdown popup menu using Hero. This is a **WIP**, mostly works but there may be some glitches.    |


# Getting started

## Install

Visit the Install tab for more information

Add this line to your pubspec.yaml

```yaml
dependencies:
    flutter_smenus: ^2.0.0
```

or run this in your project's terminal

```shell
$ flutter pub add flutter_smenus
```

> Remember to run ```flutter pub get```


## Import

```dart
import 'package:flutter_smenus/flutter_smenus.dart'
```

## Use
Once you have done all of the above, you are ready to use this package!

Have a look below to see how to implement the custom menus.
# Showcase
## Simple App Using All Menus
<img height="400" align="center"  alt="All Menu Showcase" src="https://raw.githubusercontent.com/svparekh/fluttermenus/main/full_example.gif"/>


# Code


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

| Parameter            | Object Type                            | Default                           | Description                                                                                             |
|----------------------|----------------------------------------|-----------------------------------|---------------------------------------------------------------------------------------------------------|
| ```style```          | SMenuStyle                            | SMenuStyle()                      | Color, border radius, size, padding, alignment. See ```SMenuStyle```                                    |
| ```controller```     | SMenuController?                       | SMenuController()                 | Controller to open, close, or toggle menu                                                               |
| ```items```          | List< SMenuItem>?                      | null                              | List of ```SMenuItem``` types that make the menu                                                        |
| ```builder```        | Widget Function(BuildContext context, List<SMenuItem>? items)? | null                              | Builder function for custom menu                                                                        |
| ```header```         | Widget?                                | null                              | The widget at the top of the menu                                                                       |
| ```footer```         | Widget?                                | null                              | The widget at the bottom of the menu                                                                    |
| ```scrollPhysics```  | ScrollPhysics?                         | null                              | How the menu should scroll                                                                              |
| ```scrollDirection```      | Axis                                  | Axis.vertical                     | Scroll direction, this is set automatically. Do not change this unless you know what you are doing.     |
| ```duration```       | Duration                              | const Duration (milliseconds: 250) | The duration for the animation of openning and closing the menu                                         |
| ```position```       | SMenuPosition                         | SMenuPosition.left                | Which side of the screen the menu will be location                                                      |
| ```openSize``` | double                                  | 250.0                             | The size of the menu when it is open. Sets width for left or right position or height for top and bottom. |
| ```closedSize``` | double                                  | 50.0                             | The size of the menu when it is closed. Sets width for left or right position or height for top and bottom. |
| ```body```           | Widget?                                | Container()                       | The widget that is the contents, or page. This is whatever you want the menu to open over.                                                         |
| ```resizable```      | bool                                  | true                              | If resizing bar should show                                                                             |
| ```barColor```       | Color?                                 | null                              | Color of resizing bar                                                                                   |
| ```barHoverColor```  | Color?                                 | null                              | Color of resizing bar when hovered                                                                      |
| ```barSize```        | double?                                | 3                                 | Size of resizing bar                                                                                    |
| ```barHoverSize```   | double?                                | 5                                 | Size of resizing bar when hovered                                                                       |
| ```enableWrapper```   | bool                                | true                                 | If true, wraps the menu in a Flex widget with children being this menu and an Expanded widget that contains the body.                                                                       |
| ```performanceMode```   | bool                                | false                                 | When turned on, the scrollable will be a `ListView`, thus enabling lazy loading. Otherwise it is a `SingleChildScrollView` which renders all items at once. If using a `builder`, this is not applicable |



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

| Parameter            | Object Type                            | Default                           | Description                                                                                             |
|----------------------|----------------------------------------|-----------------------------------|---------------------------------------------------------------------------------------------------------|
| ```style```          | SMenuStyle                            | SMenuStyle()                      | Color, border radius, size, padding, alignment. See ```SMenuStyle```                                    |
| ```controller```     | SMenuController?                       | SMenuController()                 | Controller to open, close, or toggle menu                                                               |
| ```items```          | List< SMenuItem>?                      | null                              | List of ```SMenuItem``` types that make the menu                                                        |
| ```builder```        | Widget Function(BuildContext context, List<SMenuItem>? items)? | null                              | Builder function for custom menu                                                                        |
| ```header```         | Widget?                                | null                              | The widget at the top of the menu                                                                       |
| ```footer```         | Widget?                                | null                              | The widget at the bottom of the menu                                                                    |
| ```scrollPhysics```  | ScrollPhysics?                         | null                              | How the menu should scroll                                                                              |
| ```scrollDirection```      | Axis                                  | Axis.vertical                     | Scroll direction, this is set automatically. Do not change this unless you know what you are doing.     |
| ```duration```       | Duration                              | const Duration (milliseconds: 250) | The duration for the animation of openning and closing the menu                                         |
| ```position```       | SMenuPosition                         | SMenuPosition.left                | Which side of the screen the menu will be location                                                      |
| ```openSize``` | double                                  | 250.0                             | The size of the menu when it is open. Sets width for left or right position or height for top and bottom. |
| ```closedSize``` | double                                  | 50.0                             | The size of the menu when it is closed. Sets width for left or right position or height for top and bottom. |
| ```offset```         | Offset                                | Offset.zero                       | The offset to apply when determining the start position of the menu                                     |
| ```body```           | Widget?                                | null                       | The widget which contains the contents, or page                                                         |
| ```enableGestures``` | bool?                                  | null                              | If gestures can open, close, or toggle the menu [WIP]                                                   |
| ```isBodyMovable```  | bool                                  | true                              | Whether the body moves in the animation or not                                                          |
| ```isMenuMovable```  | bool                                  | true                              | Whether the menu moves in the animation or not                                                          |
| ```performanceMode```   | bool                                | false                                 | When turned on, the scrollable will be a `ListView`, thus enabling lazy loading. Otherwise it is a `SingleChildScrollView` which renders all items at once. If using a `builder`, this is not applicable |

</details>


## SDropdownMenuCascade

<img height="400" align="center"  alt="Cascade Dropdown Menu Showcase" src="https://raw.githubusercontent.com/svparekh/fluttermenus/main/cascade_example.gif"/>


```dart
SDropdownMenuCascade(
    controller: SMenuController(),
    items: [],
    child: Container(),
)
```

<details>
<summary>Parameters</summary>

| Parameter          | Object Type                         | Default                           | Description                                                                                            |
|--------------------|-------------------------------------|-----------------------------------|--------------------------------------------------------------------------------------------------------|
| ```items```        | List< SMenuItem< T>>?                | required                          | List of ```SMenuItem``` types, with a value, that make the menu                                        |
| ```style```        | SDropdownMenuStyle                 | SDropdownMenuStyle()              | Color, border radius, size, padding, alignment. See ```SDropdownMenuStyle```                           |
| ```controller```   | SMenuController?                    | SMenuController()                 | Controller to open, close, or toggle menu                                                              |
| ```header```       | Widget?                             | null                              | The widget at the top of the menu                                                                      |
| ```footer```       | Widget?                             | null                              | The widget at the bottom of the menu                                                                   |
| ```duration```     | Duration                           | const Duration (milliseconds: 250) | The duration for the animation of openning and closing the menu                                        |
| ```child```        | Widget?                             | null                              | Initial widget to display as the dropdown menu button                                                  |
| ```icon```         | Widget?                             | null                              | Icon to display next to the child                                                                      |
| ```onChange```     | void Function(T value, int index)? | null                              | Function to call when the currently picked value of the dropdown is changed                            |
| ```buttonStyle```  | SMenuItemStyle                     | SMenuItemStyle()                  | The style of each item of the dropdown                                                                 |
| ```height``` | double                              | 250.0                    | The height of the popup menu |
| ```width``` | double                              | 350.0                   | The width of the popup menu |
| ```curve``` | Curve                              | Curves.easeInOutCirc                    | The animation curve to use when animating this menu |
| ```position``` | SDropdownMenuPosition?                              | SDropdownMenuPosition. bottomCenter                    | The location, relative to the dropdown button, that the menu will open at |
| ```builder``` | Widget Function(BuildContext context, List<SMenuItem>? items)?                              | null                    | Builder function for custom menu |
| ```performanceMode```   | bool                                | false                                 | When turned on, the scrollable will be a `ListView`, thus enabling lazy loading. Otherwise it is a `SingleChildScrollView` which renders all items at once. If using a `builder`, this is not applicable |

</details>


## SDropdownMenuMorph

**(THIS IS A WIP)**

```dart
SDropdownMenuMorph(
    controller: SMenuController(),
    items: [],
    child: Container(),
)
```

<details>
<summary>Parameters</summary>

| Parameter          | Object Type                         | Default              | Description                                                                  |
|--------------------|-------------------------------------|----------------------|------------------------------------------------------------------------------|
| ```items```        | List< SMenuItem< T>>?                | required                          | List of ```SMenuItem``` types, with a value, that make the menu                                        |
| ```style```        | SDropdownMenuStyle                 | SDropdownMenuStyle()              | Color, border radius, size, padding, alignment. See ```SDropdownMenuStyle```                           |
| ```controller```   | SMenuController?                    | SMenuController()                 | Controller to open, close, or toggle menu                                                              |
| ```header```       | Widget?                             | null                              | The widget at the top of the menu                                                                      |
| ```footer```       | Widget?                             | null                              | The widget at the bottom of the menu                                                                   |
| ```duration```     | Duration                           | const Duration(milliseconds: 250) | The duration for the animation of openning and closing the menu                                        |
| ```child```        | Widget?                             | null                              | Initial widget to display as the dropdown menu button                                                  |
| ```icon```         | Widget?                             | null                              | Icon to display next to the child                                                                      |
| ```onChange```     | void Function(T value, int index)? | null                              | Function to call when the currently picked value of the dropdown is changed                            |
| ```buttonStyle```  | SMenuItemStyle                     | SMenuItemStyle()                  | The style of each item of the dropdown                                                                 |
| ```height``` | double                              | 250.0                    | The height of the popup menu |
| ```width``` | double                              | 350.0                   | The width of the popup menu |
| ```curve``` | Curve                              | Curves.easeInOutCirc                    | The animation curve to use when animating this menu |
| ```position``` | SDropdownMenuPosition?                              | SDropdownMenuPosition. bottomCenter                    | The location, relative to the dropdown button, that the menu will open at |
| ```builder``` | Widget Function(BuildContext context, List<SMenuItem>? items)?                              | null                    | Builder function for custom menu |
| ```performanceMode```   | bool                                | false                                 | When turned on, the scrollable will be a `ListView`, thus enabling lazy loading. Otherwise it is a `SingleChildScrollView` which renders all items at once. If using a `builder`, this is not applicable |

</details>



## SMenuItem


```dart
SMenuItem(
    value: 'one',
    builder: (context, style, child, onPressed) {
        return Text('Menu Item');
    },
)
```

Create a custom item.

<details>
<summary>Parameters</summary>

| Parameter | Object Type | Default | Description |
| ------------- | ----------------------- | ---------------- | -- |
| ```child``` | Widget? | Container() | The widget that makes up the menu item |
| ```style``` | SMenuItemStyle | SMenuItemStyle() | Color, border radius, size, padding, alignment. See ```SMenuItemStyle``` |
| ```builder``` | Widget Function(BuildContext context, SMenuItemStyle style, Widget? child, void Function()? onPressed)? | null | If builder is not null, then the builder function will be used to make the menu item rather than the child. A builder function has parameters context, style, and child. This function should return a widget. |
| ```preview``` | Widget? | self | If showSelected is enabled on a dropdown menu, then this widget is shown as the selected item on the dropdown menu button |

</details>
<br/>

```dart
SMenuItem.clickable(
    value: 1,
    title: Text("Option 1"),
)
```

An items that can have a value. Useful for dropdown menus where onChanged will be updated with clicked item's value. Can use onPressed to add functionality in other menus.


<details>
<summary>Parameters</summary>

| Parameter | Object Type | Default | Description |
| ------------- | ----------------------- | ---------------- | -- |
| ```title``` | Widget? | Container() | The widget that makes up the middle of the menu item |
| ```trailing``` | Widget? | Container() | The widget that makes up the end of the menu item |
| ```leading``` | Widget? | Container() | The widget that makes up the start of the menu item |
| ```style``` | SMenuItemStyle | SMenuItemStyle() | Color, border radius, size, padding, etc.. See ```SMenuItemStyle``` |
| ```value``` | T? | null | Value of this item, could be ```string```, ```int```, ```double```, etc. |
| ```preview``` | Widget? | self | If showSelected is enabled on a dropdown menu, then this widget is shown as the selected item on the dropdown menu button |
| ```onPressed``` | void Function()? | null | This allows an action to be done by the item. For dropdown menus, this is in addition to the onChange function being called. |


</details>

<br/>

```dart
SMenuItem.label(
    title: Text("Option 1"),
)
```
A customizable label. Can be any widget. Is not clickable by default.

<details>
<summary>Parameters</summary>

| Parameter | Object Type | Default | Description |
| ------------- | ----------------------- | ---------------- | -- |
| ```title``` | Widget? | Container() | The widget that makes up the middle of the menu item |
| ```trailing``` | Widget? | Container() | The widget that makes up the end of the menu item |
| ```leading``` | Widget? | Container() | The widget that makes up the start of the menu item |
| ```style``` | SMenuItemStyle | SMenuItemStyle() | Color, border radius, size, padding, etc.. See ```SMenuItemStyle``` |
| ```preview``` | Widget? | self | If showSelected is enabled on a dropdown menu, then this widget is shown as the selected item on the dropdown menu button |


</details>
<br/>


```dart
SMenuItem.switchable(
    value: 1,
    title: Text("Option 1"),
)
```
**(THIS IS A WIP)**
An item that can be toggled on and off.

<details>
<summary>Parameters</summary>

| Parameter | Object Type | Default | Description |
| ------------- | ----------------------- | ---------------- | -- |
| ```toggled``` | bool? | Container() | The current toggle state of the switch |
| ```onToggle``` | Widget? | Container() | Function that handles a change in value |
| ```style``` | SMenuItemStyle | SMenuItemStyle() | Color, border radius, size, padding, etc.. See ```SMenuItemStyle``` |
| ```preview``` | Widget? | self | If showSelected is enabled on a dropdown menu, then this widget is shown as the selected item on the dropdown menu button |


</details>



## SMenuStyle


```dart
var style = SMenuStyle(
    borderRadius: BorderRadius.circular(7),
);
// You can copy any style
var style2 = style.copyWith(
    barrierColor: Colors.black12,
);
```

<details>
<summary>Parameters</summary>

| Parameter | Object Type | Default | Description |
|------------|----------|---------|----------------------|
| ```borderRadius``` | BorderRadius | BorderRadius.circular(15) | The amount and style of the border radius around the menu |
| ```padding``` | EdgeInsets? | null | The padding around the menu |
| ```border``` | BoxBorder? | null | The border to apply around the menu. |
| ```alignment``` | CrossAxisAlignment? | null | **(WIP)** Aligns the column that makes up the menu's  cross axis |
| ```barrierColor``` | Color | Colors.black26 | For slide menu, the color that is the background of the screen when the menu opens. Usually is translucent so the app can still be seen. This is the same region where "clicking off" the menu will close it. Below menu but on top of menu body. |
| ```backgroundColor``` | Color? | null | Color of the background of the menu |

</details>


## SDropdownMenuStyle

```dart
var style = SDropdownMenuStyle(
    borderRadius: BorderRadius.circular(7),
);
// You can copy any style
var style2 = style.copyWith(
    barrierColor: Colors.black12,
);
```

<details>
<summary>Parameters</summary>

| Parameter | Object Type | Default | Description |
|--------------------|-------------------------|-------------------------------------|--------------------------------------------------------------------------------|
| ```borderRadius``` | BorderRadius | BorderRadius.circular(15) | The border radius to apply to the menu |
| ```elevation``` | double? | null | The elavation to apply to the menu background |
| ```color``` | Color? | Colors.transparent | The color of the menu background |
| ```padding``` | EdgeInsets? | null | The padding around the menu |
| ```border``` | BoxBorder? | null | The border of the menu |
| ```constraints``` | BoxConstraints? | null | The constraints on the size of the dropdown menu |
| ```barrierColor``` | Color | Colors.black26 | For dropdown menus or slide menus, the color that is the background of the screen when the menu opens. Usually is translucent so the app can still be seen. This is the same region where "clicking off" the menu will close it. Below menu but on top of menu body. |
| ```offset``` | Offset? | null | Add an offset to the position of the menu that has been  calculated from ```SDropdownMenuPosition```. Moves the top left of the dropdown relative to the top left of the button after the calculation. |
| ```hideIcon``` | bool | false | If true, the icon provided will not show |
| ```leadingIcon``` | bool | false | If true, the icon will move to left of text |
| ```showSelected``` | bool | false | If true, the selected object's preview widget will replace the text and icon on the dropdown button to show what is selected, default is false. |
| ```isSmall``` | bool | true | If true, doesn't show the selected item, doesn't show the child, only shows the icon. If `hideIcon` is also true the dropdown button will be an empty button according to the ```SMenuItemStyle``` that it might have been given. |

</details>


## SMenuItemStyle

```dart
var style = SMenuItemStyle(
    borderRadius: BorderRadius.circular(7),
);
// You can copy any style
var style2 = style.copyWith(
    accentColor: Colors.amber,
);
```

<details>
<summary>Parameters</summary>

| Parameter                 | Object Type        | Default | Description                                                                              |
|---------------------------|--------------------|---------|------------------------------------------------------------------------------------------|
| ```alignment```   | MainAxisAlignment | MainAxisAlignment.start    | The alignment of the flex widget the makes up the item |
| ```borderRadius```        | BorderRadius      | BorderRadius.circular(15)    | The border radius to apply to the menu item                              |
| ```shape```               | OutlinedBorder?    | null    | The shape of the item, overwrites border radius for the item (contained in shape) |
| ```elevation```           | double?            | null    | The elavation to apply to the item                                                       |
| ```padding```             | EdgeInsets?        | null    | The padding around the menu item                                                         |
| ```width```               | double?             | null    | The width of the menu item                                                               |
| ```height```              | double?            | null    | The height of the menu item                                                              |
| ```accentColor```         | Color?             | null    | The accent, or primary, color of the item. This is applied to things like icons and text |
| ```bgColor```             | Color?             | null    | The background color                                                                     |
| ```mouseCursor```     | MouseCursor?             | null    | The cursor of the mouse when hovering over the item |


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

| Value                            | Value Type | Description                                        |
|----------------------------------|------------|----------------------------------------------------|
| ```SMenuPosition.top```          | Enum       | Position the menu at the top of a screen           |
| ```SMenuPosition.bottom```       | Enum       | Position the menu at the bottom of a screen        |
| ```SMenuPosition.left```         | Enum       | Position the menu to the left of a screen          |
| ```SMenuPosition.right```        | Enum       | Position the menu to the right of a screen         |
| ```SMenuPosition.isVertical```   | bool       | True if position is currently set to top or bottom |
| ```SMenuPosition.isHorizontal``` | bool       | True if position is currently set to left or right |


</details>


## SDropdownMenuPosition

```dart
SDropdownMenuPosition.topLeft
SDropdownMenuPosition.topCenter
SDropdownMenuPosition.topRight
SDropdownMenuPosition.centerLeft
SDropdownMenuPosition.center
SDropdownMenuPosition.centerRight
SDropdownMenuPosition.bottomLeft
SDropdownMenuPosition.bottomCenter
SDropdownMenuPosition.bottomRight
```

<details>
<summary>More Information</summary>

Imagine the dropdown button is located at the center of a 2D space. The dropdown will open in these directions as specificed by the position:

|             |               |              |
|-------------|---------------|--------------|
| Top Left    | Top Center    | Top Right    |
| Center Left | Center        | Center Right |
| Bottom Left | Bottom Center | Bottom RIght |

The center is where the dropdown menu button is, so if position is set to that the button will be covered.

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


| Name                           | Type                       | Description                                                                                                                  |
|--------------------------------|----------------------------|------------------------------------------------------------------------------------------------------------------------------|
| ```SMenuController.open()```   | Method                     | Open the menu that this controller is assigned to                                                                            |
| ```SMenuController.close()```  | Method                     | Close the menu that this controller is assigned to                                                                           |
| ```SMenuController.toggle()``` | Method                     | Toggle the menu that this controller is assigned to                                                                          |
| ```SMenuController.state```    | ValueNotifier< SMenuState> | A value notifier that will send an update when the state of the menu changes. The value of this notifier is ```SMenuState``` |

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


| Value                    | Description                                                                              |
|--------------------------|------------------------------------------------------------------------------------------|
| ```SMenuState.open```    | The menu is currently not fully closed                                                   |
| ```SMenuState.closed```  | The menu is currently fully closed                                                       |
| ```SMenuState.opening``` | The menu is currently in the process of opening. The animation to open is still playing  |
| ```SMenuState.closing``` | The menu is currently in the process of closing. The animation to close is still playing |

</details>



# Additional information

### More: 
#### Additional Classes

| Class                    | Object Type                          |
|--------------------------|--------------------------------------|
| ```SBaseMenu```          | Abstract Stateful Widget Class       |
| ```SBaseMenuState```     | Abstract Stateful Widget State Class |
| ```SBaseDropdownMenu```      | Abstract Stateful Widget Class       |
| ```SBaseDropdownMenuState``` | Abstract Stateful Widget State Class |



### Contribute: -

### Issues: -


> Note: Some features may not work with custom children, this includes but is not limited to dropdown menus having nuances with values, having picked item displayed, or even the inkwell to display clicking. These work fine with ```SMenuItem```, but custom items may have issues. Use at your own risk.