import 'package:flutter/material.dart';

import 'package:flutter_smenus/dropdown.dart';
import 'package:flutter_smenus/menu.dart';
import 'package:flutter_smenus/menu_item.dart';
import 'package:flutter_smenus/base.dart';

/// Note: This example also implements a custom indicator for the clickable
/// menu buttons on the left, which extend the [SMenuItem] class. This is
/// unrelated to the package, but it is implemented in this example.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SMenus',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Flutter SMenus'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // A controller for each menu
  SMenuController detailsMenuController = SMenuController();
  SMenuController leftMenuController = SMenuController();
  SMenuController consoleMenuController = SMenuController();
  // Data for details menu (current chosen item in ListView)
  Map<String, dynamic> chosenFile = data[1];
  // the current selected menu button (custom class found below this class called SMenuItemButton)
  int selectedIndex = 0;
  // Keys for the left hand side menu items and allows us to grab their heights, see below for more info.
  List<GlobalKey> keys = List.generate(4, (index) => GlobalKey());
  List<double> heights = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        heights = keys
            .map((key) => key.currentContext!.size!.height)
            .toList()
            .reversed
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // a variable to hold the style for dropdown menu items that are in the middle,
    // this was repetitive so it was made into a variable
    const midDropdownButtonStyle = SMenuItemStyle(
        borderRadius: BorderRadius.zero, alignment: MainAxisAlignment.center);
    // Build app
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Center(
              child: SizedBox.square(
                dimension: 32,
                // Settings dropdown menu that is on the right of the app bar
                child: SDropdownMenuCascade(
                  position: SDropdownMenuPosition.bottomLeft,
                  icon: Icon(
                    Icons.settings,
                    size: 22,
                  ),
                  items: [
                    // The top and bottom menu items have special
                    // border radius to create a rounded rectangle look of
                    // the dropdown. This is because the clickable item
                    // has its own background.
                    SMenuItem.clickable(
                      value: 1,
                      title: Text('First Option (1)'),
                      style: SMenuItemStyle(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                    ),
                    SMenuItem.clickable(
                      value: 2,
                      title: Text('Option 2'),
                      style: midDropdownButtonStyle,
                    ),
                    SMenuItem.clickable(
                      value: 3,
                      title: Text('Option 3'),
                      style: midDropdownButtonStyle,
                    ),
                    SMenuItem.clickable(
                      value: 4,
                      title: Text('Option 4'),
                      style: midDropdownButtonStyle,
                    ),
                    SMenuItem.clickable(
                      value: 5,
                      title: Text('Last Option (5)'),
                      style: SMenuItemStyle(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),

      // Persistent main menu
      body: SResizableMenu(
        // specify size so buttons fit
        closedSize: 60,
        controller: leftMenuController,
        resizable:
            false, // Remove resize bar, user shouldn't be able to control size
        position: SMenuPosition.left,
        style: SMenuStyle(
            border: Border.all(color: Colors.black12, width: 1),
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(15))),
        // add a button to toggle the menu
        header: TextButton(
            onPressed: () {
              leftMenuController.toggle();
              setState(() {});
            },
            // Icon changes based on the state, could also use a listener on
            // the controller state instead of doing this
            child: Icon((leftMenuController.state.value == SMenuState.closed ||
                    leftMenuController.state.value == SMenuState.closing)
                ? Icons.menu
                : Icons.menu_open_outlined)),
        footer: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            'This is a basic footer',
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
        builder: (context, items) {
          // Use the height of all widgets that are above it, and half the current
          // button widget's height, to calculate the offset from the top of the menu
          // (under the header) that the animated container that is the indicator
          // should move.

          double offset = 0.0;
          int val = -1;
          // calc offset
          for (int i = 0; i < heights.length; i++) {
            if (items[i] is SMenuItemButton) {
              val++;
            }

            if (val == selectedIndex) {
              offset += heights[i] / 2;

              break;
            }
            if (i == 0) {
              offset += 20 / 2;
            }
            offset += heights[i];
          }

          // Create a stack so that the animated container can lie on top of the buttons
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: items,
                ),
              ),
              // This animated container is the actual indicator that shows what
              // button is selected. It animates between different button for a
              // smooth transition effect.
              AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCirc,
                  // This top margin is the offset calculated earlier
                  margin: EdgeInsets.only(top: offset, left: 2),
                  height: 25,
                  width: 5.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.onPrimary)),
            ],
          );
        },
        items: [
          // Creates our custom class SMenuItemButton which enables us to show
          // that a button is selected. The key is given so that we can have a way
          // to measure the height of the widget.
          SMenuItemButton(
            key: keys[0],
            text: 'Home',
            isSelected: selectedIndex == 0,
            icon: Icons.home,
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          SMenuItemButton(
            key: keys[1],
            text: 'A Page',
            isSelected: selectedIndex == 1,
            icon: Icons.file_open,
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
          SMenuItemButton(
            key: keys[2],
            text: 'Another Page',
            isSelected: selectedIndex == 2,
            icon: Icons.document_scanner,
            onTap: () {
              setState(() {
                selectedIndex = 2;
              });
            },
          ),
          // Creates a literal label. Not clickable.
          SMenuItem.label(
            key: keys[3],
            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'This is a label',
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
            style: midDropdownButtonStyle,
          ),
        ],

        // Console Menu
        body: SResizableMenu(
          controller: consoleMenuController,
          position: SMenuPosition.bottom,
          items: [
            // Creates a rounded rectangle container to act as some filler
            SMenuItem(
              builder: (context, style, child) {
                return Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(15)),
                );
              },
            )
          ],
          // Create the header, with text on the left, and a dropdown menu along
          // with the menu toggle button on the right
          header: SizedBox(
            height: 50,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                      child: Text(
                    'Command Bar',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox.square(
                        dimension: 40,
                        child: Center(
                          child: SDropdownMenuMorph(
                            height: 150,
                            position: SDropdownMenuPosition.topLeft,
                            icon: Icon(Icons.menu),
                            items: [
                              // The top and bottom menu items have special
                              // border radius to create a rounded rectangle look of
                              // the dropdown. This is because the clickable item
                              // has its own background.
                              SMenuItem.clickable(
                                value: 1,
                                title: Text('First Option (1)'),
                                style: SMenuItemStyle(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                              ),
                              SMenuItem.clickable(
                                value: 2,
                                title: Text('Option 2'),
                                style: midDropdownButtonStyle,
                              ),
                              SMenuItem.clickable(
                                value: 3,
                                title: Text('Option 3'),
                                style: midDropdownButtonStyle,
                              ),
                              SMenuItem.clickable(
                                value: 4,
                                title: Text('Option 4'),
                                style: midDropdownButtonStyle,
                              ),
                              SMenuItem.clickable(
                                value: 5,
                                title: Text('Last Option (5)'),
                                style: SMenuItemStyle(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Open/close the menu
                      TextButton(
                          onPressed: () {
                            consoleMenuController.toggle();
                          },
                          child: const Icon(Icons.keyboard_command_key)),
                    ],
                  ),
                ]),
          ),

          // Details Menu
          body: SSlideMenu(
            closedSize: 60,
            openSize: 400,
            position: SMenuPosition.right,
            controller: detailsMenuController,
            isBodyMovable: false,
            items: [
              // Create a menu item for each item in the currently chosen map
              // These are the details shown when you click an item in the ListView
              for (String key in chosenFile.keys)
                SMenuItem(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '$key:',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Text(chosenFile[key]),
                    ],
                  ),
                ),
            ],
            // Build the list view for the data. This is the actual "app"
            body: Container(
              color: Colors.white,
              child: Center(
                  child: ListView(
                children: [
                  for (Map<String, dynamic> item in data)
                    ListTile(
                      leading: Text(item['name']),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item['location']),
                        ],
                      ),
                      trailing: Text(item['size']),
                      onTap: () {
                        setState(() {
                          chosenFile = item;
                        });
                        detailsMenuController.toggle();
                      },
                    )
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}

/// This is a custom class that extends the [SMenuItem]. All it does is create
/// a custom widget using the child argument. This class exists to wrap certain
/// variables, such as isSelected. This allows us to create a TextButton in place
/// of the regular menu item. We want the button to be a certain
/// color when selected. This is a rudimentary implementation of a Menu Button,
/// which means it is not fully fledged out.
///
/// Used in the left hand side menu in this example.
class SMenuItemButton<T> extends SMenuItem {
  const SMenuItemButton({
    super.key,
    this.onTap,
    super.style = const SMenuItemStyle(),
    required this.icon,
    this.selectedTextColor,
    this.selectedIconColor,
    this.textColor,
    this.iconColor,
    this.text,
    this.isSelected = false,
    this.onHover,
    this.onLongPress,
  });
  final IconData icon;
  final Color? selectedTextColor;
  final Color? selectedIconColor;
  final Color? textColor;
  final Color? iconColor;
  final String? text;
  final bool isSelected;
  final void Function()? onTap;
  final void Function(bool)? onHover;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return SMenuItem(
      style: style,
      child: AnimatedContainer(
        height: 45,
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: style.borderRadius,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : style.bgColor ?? Theme.of(context).colorScheme.onPrimary,
        ),
        duration: const Duration(milliseconds: 250),
        child: TextButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: style.borderRadius))),
          onPressed: onTap,
          onHover: onHover,
          onLongPress: onLongPress,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Icon(
                  icon,
                  color: isSelected
                      ? selectedIconColor ??
                          Theme.of(context).colorScheme.onPrimary
                      : style.accentColor ??
                          iconColor ??
                          Theme.of(context).colorScheme.primary,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    text ?? '',
                    style: TextStyle(
                        color: isSelected
                            ? selectedTextColor ??
                                Theme.of(context).colorScheme.onPrimary
                            : style.accentColor ??
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
      ),
    );
  }
}

const List<Map<String, dynamic>> data = [
  {
    'name': 'File 1',
    'created': '1/1/2000',
    'modified': '2/2/2023',
    'author': 'User 1',
    'type': 'svg',
    'location': '/usr/bin/mktemp',
    'size': '12.09 TB',
    'security': 'drwx------x',
  },
  {
    'name': 'File 2',
    'created': '2/2/2000',
    'modified': '3/3/2023',
    'author': 'User 2',
    'type': 'txt',
    'location': 'C:\\Windows\\Containers\\serviced',
    'size': '2 MB',
    'security': 'lrwxr-xr-x',
  },
  {
    'name': 'File 3',
    'created': '3/3/2000',
    'modified': '4/4/2023',
    'author': 'User 3',
    'type': 'dart',
    'location': '/User/User 3/bin/app.dart',
    'size': '6 GB',
    'security': '-rw-r--r--',
  },
  {
    'name': 'File 4',
    'created': '4/4/2000',
    'modified': '5/5/2023',
    'author': 'User 4',
    'type': 'pdf',
    'location': '/dev',
    'size': '15 KB',
    'security': '-rw-------',
  }
];
