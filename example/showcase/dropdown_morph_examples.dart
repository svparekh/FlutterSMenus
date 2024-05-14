import 'package:flutter/material.dart';

import 'package:flutter_smenus/dropdown.dart';
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
  bool? isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // variables to hold the style for dropdown menu items,
    // this was repetitive so it was made into a variable
    var blueItemStyle = const SMenuItemStyle(
      accentColor: Colors.blue,
    );
    var grayItemStyle = const SMenuItemStyle(
      accentColor: Colors.blueGrey,
    );
    var blueItemStyleWithBG = blueItemStyle.copyWith(
      bgColor: Colors.blue.withOpacity(0.239),
    );
    var grayItemStyleWithBG = grayItemStyle.copyWith(
      bgColor: Colors.blueGrey.withOpacity(0.231),
    );
    var noBRBlueItemStyle = blueItemStyle.copyWith(
      borderRadius: BorderRadius.zero,
      alignment: MainAxisAlignment.center,
    );
    var noBRGrayItemStyle = grayItemStyle.copyWith(
      borderRadius: BorderRadius.zero,
      alignment: MainAxisAlignment.center,
    );

    var noBRBlueItemStyleWithBG = blueItemStyleWithBG.copyWith(
      borderRadius: BorderRadius.zero,
      alignment: MainAxisAlignment.center,
    );
    // var noBRGrayItemStyleWithBG = grayItemStyleWithBG.copyWith(
    //   borderRadius: BorderRadius.zero,
    //   alignment: MainAxisAlignment.center,
    // );
    // items for the settings dropdown
    List<SMenuItem> itemsSettings = [
      SMenuItem(
        style: noBRGrayItemStyle,
        child: const Padding(
          padding: EdgeInsets.only(top: 16.0, bottom: 8),
          child: Text(
            'Settings',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      SMenuItem.switchable(
        style: noBRGrayItemStyle,
        title: const Text("Checkbox"),
        onToggle: (value) {
          setState(() {
            isChecked = value;
          });
        },
        toggled: isChecked,
      )
    ];
    itemsSettings.addAll(createItems(noBRGrayItemStyle));

    // the menus (row, column)
    List<SDropdownMenuMorph> menus = [
      // menu 1,1
      SDropdownMenuMorph(
        icon: Transform.rotate(
          angle: 3.14159,
          child: const Icon(
            Icons.details,
          ),
        ),
        buttonStyle: grayItemStyleWithBG.copyWith(
          shape: const CircleBorder(eccentricity: 1),
          side: BorderSide.none,
        ),
        height: 150,
        items: createItems(grayItemStyle),
      ),
      // menu 1,2
      SDropdownMenuMorph(
        position: SDropdownMenuPosition.bottomLeft,
        icon: const Icon(
          Icons.arrow_drop_down_rounded,
        ),
        buttonStyle: grayItemStyleWithBG.copyWith(
          shape: const CircleBorder(eccentricity: 1),
          side: BorderSide(
              color: grayItemStyleWithBG.bgColor!.withOpacity(0.5), width: 2),
        ),
        height: 150,
        items: createItems(grayItemStyle, isRounded: true),
      ),
      // menu 1,3
      SDropdownMenuMorph(
        position: SDropdownMenuPosition.bottomRight,
        icon: const Icon(
          Icons.expand_more_rounded,
        ),
        buttonStyle: grayItemStyleWithBG.copyWith(
          borderRadius: BorderRadius.zero,
          side: BorderSide.none,
        ),
        style: const SDropdownMenuStyle(borderRadius: BorderRadius.zero),
        height: 150,
        items: createItems(noBRGrayItemStyle),
      ),
      // menu 1,4
      SDropdownMenuMorph(
        position: SDropdownMenuPosition.topRight,
        height: 150,
        items: itemsSettings,
        buttonStyle: grayItemStyleWithBG.copyWith(
          borderRadius: BorderRadius.zero,
          side: BorderSide(
              color: grayItemStyleWithBG.bgColor!.withOpacity(0.5), width: 2),
        ),
        style: const SDropdownMenuStyle(borderRadius: BorderRadius.zero),
        icon: const Icon(
          Icons.settings,
        ),
      ),
      // menu 1,5
      SDropdownMenuMorph(
        position: SDropdownMenuPosition.topRight,
        height: 255,
        items: itemsSettings,
        buttonStyle: grayItemStyleWithBG.copyWith(
          borderRadius: BorderRadius.zero,
          side: BorderSide(
              color: grayItemStyleWithBG.bgColor!.withOpacity(0.5), width: 2),
        ),
        style: const SDropdownMenuStyle(borderRadius: BorderRadius.zero),
        icon: const Icon(
          Icons.settings,
        ),
      ),
      // menu 2,1
      SDropdownMenuMorph(
        buttonStyle: blueItemStyleWithBG.copyWith(
          padding: const EdgeInsets.only(right: 5),
          side: BorderSide.none,
        ),
        style: const SDropdownMenuStyle(
          showSelected: true,
          isSmall: false,
        ),
        position: SDropdownMenuPosition.topCenter,
        height: 150,
        items: createItems(blueItemStyle, isRounded: true),
        child: const Padding(
          padding: EdgeInsets.only(left: 10, right: 5),
          child: Text("Choose"),
        ),
      ),
      // menu 2,2
      SDropdownMenuMorph(
        buttonStyle: blueItemStyleWithBG.copyWith(
          padding: const EdgeInsets.only(left: 5),
          side: BorderSide(
              color: blueItemStyleWithBG.bgColor!.withOpacity(0.5), width: 2),
        ),
        style: const SDropdownMenuStyle(
          showSelected: true,
          isSmall: false,
          leadingIcon: true,
        ),
        position: SDropdownMenuPosition.topLeft,
        height: 150,
        items: createItems(blueItemStyle, isRounded: true),
        child: const Padding(
          padding: EdgeInsets.only(left: 5, right: 10),
          child: Text("Choose"),
        ),
      ),
      // menu 2,3
      SDropdownMenuMorph(
        style: const SDropdownMenuStyle(
          showSelected: true,
          isSmall: false,
          hideIcon: true,
        ),
        buttonStyle: noBRBlueItemStyleWithBG.copyWith(
          side: BorderSide.none,
        ),
        position: SDropdownMenuPosition.centerLeft,
        height: 150,
        items: createItems(noBRBlueItemStyle, isRounded: true),
        child: const Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text("Choose"),
        ),
      ),
      // menu 2,4
      SDropdownMenuMorph(
        buttonStyle: noBRBlueItemStyleWithBG.copyWith(
          side: BorderSide(
              color: blueItemStyleWithBG.bgColor!.withOpacity(0.5), width: 2),
        ),
        style: const SDropdownMenuStyle(
          isSmall: false,
        ),
        position: SDropdownMenuPosition.centerRight,
        height: 150,
        items: createItems(blueItemStyle, isRounded: true),
        child: const Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text("Choose"),
        ),
      ),
      // menu 2,5
      SDropdownMenuMorph(
        footer: const Text("This is a footer"),
        header: const Text("This is a header"),
        buttonStyle: noBRBlueItemStyleWithBG.copyWith(
          side: BorderSide(
              color: blueItemStyleWithBG.bgColor!.withOpacity(0.5), width: 2),
        ),
        style: const SDropdownMenuStyle(
          isSmall: false,
          hideIcon: true,
        ),
        position: SDropdownMenuPosition.center,
        height: 190,
        items: createItems(noBRBlueItemStyle),
        child: const Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text("Choose"),
        ),
      ),
    ];

    // Build app
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      // grid
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        itemCount: menus.length,
        // menus
        itemBuilder: (context, index) {
          final menuButtonsWithSetWidths = [0, 1, 2, 3, 4];
          return Center(
            child: SizedBox(
              height: 50,
              width: menuButtonsWithSetWidths.contains(index) ? 50 : null,
              child: menus[index],
            ),
          );
        },
      ),
    );
  }
}

List<SMenuItem> createItems(SMenuItemStyle style, {bool isRounded = false}) {
  return [
    SMenuItem.clickable(
      value: 1,
      title: const Text('First Option (1)'),
      style: style.copyWith(
        borderRadius: isRounded
            ? const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )
            : null,
      ),
    ),
    SMenuItem.clickable(
      value: 2,
      title: const Text('Option 2'),
      style: style.copyWith(
        borderRadius: isRounded ? BorderRadius.zero : null,
      ),
    ),
    SMenuItem.clickable(
      value: 3,
      title: const Text('Option 3'),
      style: style.copyWith(
        borderRadius: isRounded ? BorderRadius.zero : null,
      ),
    ),
    SMenuItem.clickable(
      value: 4,
      title: const Text('Option 4'),
      style: style.copyWith(
        borderRadius: isRounded ? BorderRadius.zero : null,
      ),
    ),
    SMenuItem.clickable(
      value: 5,
      title: const Text('Last Option (5)'),
      style: style.copyWith(
        borderRadius: isRounded
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )
            : null,
      ),
    ),
  ];
}
