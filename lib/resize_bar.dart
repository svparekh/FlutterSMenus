import 'package:flutter/material.dart';

import 'menu.dart';

class ResizeBar extends StatefulWidget {
  const ResizeBar(
      {Key? key,
      required this.menuController,
      this.color = const Color.fromARGB(255, 211, 211, 211),
      this.hoverColor = const Color.fromARGB(134, 33, 149, 243),
      required this.position,
      this.hoverSize})
      : super(key: key);
  final SMenuController menuController;
  final SSideMenuPosition position;
  final Color? color;
  final Color? hoverColor;
  final double? hoverSize;

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
      height: vert ? null : (isHover ? widget.hoverSize ?? 5 : 3),
      width: vert ? (isHover ? widget.hoverSize ?? 5 : 3) : null,
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
            if ((widget.position == SSideMenuPosition.left) ||
                (widget.position == SSideMenuPosition.right)) {
              double delta = details.delta.dx;
              final width = widget.position == SSideMenuPosition.left
                  ? widget.menuController.size.value + delta
                  : widget.menuController.size.value - delta;
              widget.menuController.size.value = width.clamp(
                  SMenuSize.menuWidthClosed, SMenuSize.menuWidthOpen);
            }
          },
          onVerticalDragUpdate: (details) {
            if ((widget.position == SSideMenuPosition.top) ||
                (widget.position == SSideMenuPosition.bottom)) {
              double delta = details.delta.dy;
              final width = widget.position == SSideMenuPosition.top
                  ? widget.menuController.size.value + delta
                  : widget.menuController.size.value - delta;
              widget.menuController.size.value = width.clamp(
                  SMenuSize.menuWidthClosed, SMenuSize.menuWidthOpen);
            }
          },
          // onTap: () {
          //   menuController.toggle();
          // },
        ),
      ),
    );
  }
}
