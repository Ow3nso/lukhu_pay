import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AppBarType,
        DefaultBackButton,
        DefaultTextBtn,
        LuhkuAppBar,
        StyleColors,
        WatchContext,
        ReadContext;
import 'package:lukhu_pay/src/controller/plan_controller.dart';

import '../widgets/plans/plan_card.dart';

class PlansView extends StatelessWidget {
  const PlansView({super.key});
  static const routeName = "plans";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LuhkuAppBar(
        appBarType: AppBarType.other,
        color: StyleColors.lukhuWhite,
        enableShadow: true,
        backAction: const DefaultBackButton(),
        title: Text(
          "Lukhu Plans",
          style: TextStyle(
            color: StyleColors.lukhuDark1,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DefaultTextBtn(
              onTap: () {},
              label: "Compare Plans",
              underline: false,
            ),
          )
        ],
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            var item = context.watch<PlanController>().plans[index];
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: PlanCard(
                item: item,
                isSelected: item['status'],
                onTap: () {
                  context.read<PlanController>().togglePlan(index);
                },
              ),
            );
          },
          itemCount: context.watch<PlanController>().plans.length,
        ),
      ),
    );
  }
}
