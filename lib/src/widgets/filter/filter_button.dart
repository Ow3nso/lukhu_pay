import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart' show GlobalAppUtil, StyleColors;

import '../../../util/app_util.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.onTap,
  });
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: StyleColors.lukhuDividerColor)),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Image.asset(
              AppUtil.filterSquare,
              package: AppUtil.packageName,
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 16),
              child: Text(
                'Filter',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.scrim,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Image.asset(GlobalAppUtil.chevronDown,
                package: GlobalAppUtil.mainPackageName)
          ],
        ),
      ),
    );
  }
}
