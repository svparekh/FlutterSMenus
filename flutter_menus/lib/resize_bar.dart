import 'package:flutter/material.dart';

import 'menu.dart';

class ResizeBar extends StatefulWidget {
  const ResizeBar(
      {Key? key,
      required this.menuController,
      this.color = const Color.fromARGB(255, 211, 211, 211),
      this.hoverColor = const Color.fromARGB(134, 33, 149, 243),
      required this.position})
      : super(key: key);
  final SMenuController menuController;
  final SSideMenuPosition position;
  final Color? color;
  final Color? hoverColor;

  @override
  State<ResizeBar> createState() => _ResizeBarState();
}

class _ResizeBarState extends State<ResizeBar> {
  bool isHover = false;
  late bool vert;

  @override
  void initState() {
    switch (widget.position) {
      case SSideMenuPosition.bottom:
      case SSideMenuPosition.top:
        vert = false;
        break;
      case SSideMenuPosition.left:
      case SSideMenuPosition.right:
        vert = true;
        break;
      default:
        vert = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
          color: isHover ? widget.hoverColor! : widget.color!,
          borderRadius: BorderRadius.circular(2)),
      duration: Duration(milliseconds: 250),
      height: vert ? null : 3,
      width: vert ? 3 : null,
      child: MouseRegion(
        cursor: vert
            ? SystemMouseCursors.resizeLeftRight
            : SystemMouseCursors.resizeUpDown,
        onEnter: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            // direction, (0, 1] = right, [-1, 0) = left

            final delta = (details.delta.dx);
            print(delta);
            final width = ((widget.position == SSideMenuPosition.left) ||
                    (widget.position == SSideMenuPosition.bottom))
                ? widget.menuController.size.value + delta
                : widget.menuController.size.value - delta;
            print(width);
            widget.menuController.size.value =
                width.clamp(SMenuSize.menuWidthClosed, SMenuSize.menuWidthOpen);
          },
          // onTap: () {
          //   menuController.toggle();
          // },
        ),
      ),
    );
  }
}
