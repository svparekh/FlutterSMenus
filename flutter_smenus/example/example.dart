import 'package:flutter/material.dart';
import 'package:flutter_smenus/menu.dart';
import 'package:flutter_smenus/menu_item.dart';
import 'package:flutter_smenus/dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  SMenuController detailsMenuController = SMenuController();
  SMenuController leftMenuController = SMenuController();
  SMenuController consoleMenuController = SMenuController();
  Map<String, dynamic> chosenFile = data[1];
  int selectedIndex = 0;

  SMenuPosition _resizableMenuPosition = SMenuPosition.left;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: const [
          SDropdownMenuCascade(items: []),
          SDropdownMenuMorph(items: [])
        ],
      ),
      // Persistent console menu
      body: SResizableMenu(
        enableSelector: true,
        controller: leftMenuController,
        resizable: false,
        position: SMenuPosition.left,
        header: TextButton(
            onPressed: () {
              leftMenuController.toggle();
              setState(() {});
            },
            child: Icon((leftMenuController.state.value == SMenuState.closed ||
                    leftMenuController.state.value == SMenuState.closing)
                ? Icons.menu
                : Icons.menu_open_outlined)),
        items: [
          SMenuItemButton(
            title: 'Exercise Bank',
            isSelected: selectedIndex == 0,
            icon: Icons.home,
            onPressed: () {
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          SMenuItemButton(
            title: 'Workout Builder',
            isSelected: selectedIndex == 1,
            icon: Icons.fitness_center,
            onPressed: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
          SMenuItemButton(
            title: 'Diet Planner',
            isSelected: selectedIndex == 2,
            icon: Icons.food_bank,
            onPressed: () {
              setState(() {
                selectedIndex = 2;
              });
            },
          ),
        ],
        // Details Menu
        body: SResizableMenu(
          controller: consoleMenuController,
          position: SMenuPosition.bottom,
          items: [
            SMenuItemCustom(
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
                          child: Icon(
                            Icons.settings,
                            size: 22,
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            consoleMenuController.toggle();
                          },
                          child: const Icon(Icons.keyboard_command_key)),
                    ],
                  ),
                ]),
          ),

          // direction: Axis.horizontal,

          // controller: controller,
          body: SSlideMenu(
            style:
                SMenuStyle(size: BoxConstraints(minWidth: 50, maxWidth: 400)),
            position: SMenuPosition.right,
            controller: detailsMenuController,
            isBodyMovable: false,
            items: [
              for (String key in chosenFile.keys)
                SMenuItemCustom(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '$key:',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Text(chosenFile[key]),
                    ],
                  ),
                ),
            ],
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
