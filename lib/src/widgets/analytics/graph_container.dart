import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show DefaultDropdown, DiscountCard, ReadContext, StyleColors;
import 'package:lukhu_pay/util/app_util.dart';

import '../../controller/analytics_controller.dart';
import '../drop_down_tile.dart';
import 'chart_card.dart';

class GraphContainer extends StatelessWidget {
  const GraphContainer({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          child ??
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Income Overview',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.scrim,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: DefaultDropdown(
                      radius: 8,
                      itemChild: (value) => DropdownTitle(
                        iconData: Icons.calendar_month,
                        title: value,
                        color: StyleColors.lukhuDark1,
                      ),
                      onChanged: (value) {
                        context.read<AnalyticsController>().selectedDuration =
                            value ?? '';
                      },
                      hintWidget: DropdownTitle(
                        iconData: Icons.calendar_month,
                        title: context
                            .read<AnalyticsController>()
                            .selectedDuration,
                        color: StyleColors.lukhuDark1,
                      ),
                      items: context.read<AnalyticsController>().durations,
                    ),
                  ),
                ],
              ),
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 16),
            child: SizedBox(height: 300, child: ChartCard()),
          ),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: 150,
              child: DiscountCard(
                color: StyleColors.lukhuError10,
                iconImage: AppUtil.arrowUp,
                packageName: AppUtil.packageName,
                description: '14.32% vs Last Week',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.scrim,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
