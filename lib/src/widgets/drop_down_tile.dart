import 'package:flutter/material.dart';

class DropdownTitle extends StatelessWidget {
  const DropdownTitle(
      {super.key,
      this.iconData,
      this.color,
      required this.title,
      this.assetImage});
  final IconData? iconData;
  final Color? color;
  final String title;
  final String? assetImage;

  @override
  Widget build(BuildContext context) {
    return Row(verticalDirection: VerticalDirection.up, children: [
      Icon(
        iconData,
        color: color,
        size: 16,
      ),
      const SizedBox(width: 4),
      Text(
        title,
        style:
            TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 12),
      )
    ]);
  }
}
