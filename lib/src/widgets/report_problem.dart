import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart';

import '../../util/app_util.dart';

class ReportButton extends StatelessWidget {
  const ReportButton({super.key, this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return DefaultButton(
      textColor: StyleColors.lukhuError,
      label: 'Report Problem',
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      asssetIcon: AppUtil.flagIcon,
      packageName: AppUtil.packageName,
    );
  }
}
