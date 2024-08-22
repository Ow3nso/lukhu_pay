import 'package:flutter/material.dart';
import 'package:lukhu_pay/util/app_util.dart';

class WalletText extends StatelessWidget {
  const WalletText(
      {super.key, this.show = true, required this.description, this.style});
  final bool show;
  final String description;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState:
          show ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Text(
        '**********',
        style: style,
      ),
      secondChild: Text(
        description,
        style: style,
      ),
      sizeCurve: Curves.easeInOut,
      duration: AppUtil.animationDuration,
    );
  }
}
