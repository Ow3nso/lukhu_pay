import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart' show StyleColors;

class DetailCard extends StatelessWidget {
  const DetailCard(
      {super.key, this.description, this.title, this.child, this.onTap});
  final String? description;
  final String? title;
  final Widget? child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: StyleColors.lukhuDividerColor,
          ),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: StyleColors.lukhuGrey80,
                    ),
                  ),
                if (description != null)
                  Text(
                    description ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  )
              ],
            ),
            const Spacer(),
            if (child != null) child!
          ],
        ),
      ),
    );
  }
}
