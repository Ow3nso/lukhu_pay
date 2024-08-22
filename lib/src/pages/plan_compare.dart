import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AppBarType,
        DefaultBackButton,
        DefaultCallBtn,
        LuhkuAppBar,
        StyleColors;

class PlanCompareView extends StatelessWidget {
  const PlanCompareView({super.key});
  static const routeName = "compare-plan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LuhkuAppBar(
        appBarType: AppBarType.other,
        backAction: const DefaultBackButton(),
        title: Text(
          "Compare Plans",
          style: TextStyle(
            color: StyleColors.lukhuDark1,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: const [DefaultCallBtn()],
      ),
    );
  }
}
