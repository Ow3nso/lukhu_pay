import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AppBarType,
        DefaultBackButton,
        DefaultIconBtn,
        GlobalAppUtil,
        LuhkuAppBar,
        ReadContext;
import 'package:lukhu_pay/src/controller/analytics_controller.dart';
import 'package:lukhu_pay/src/widgets/analytics/summary_card.dart';
import 'package:lukhu_pay/util/app_util.dart';

import '../widgets/analytics/graph_container.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});
  static const routeName = 'analytics';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var summary = context.read<AnalyticsController>().summaryList;
    return Scaffold(
      appBar: LuhkuAppBar(
        appBarType: AppBarType.other,
        backAction: const DefaultBackButton(),
        centerTitle: true,
        title: Text(
          'Analytics',
          style: TextStyle(
            color: Theme.of(context).colorScheme.scrim,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: DefaultIconBtn(
              assetImage: AppUtil.callIcon,
              packageName: GlobalAppUtil.productListingPackageName,
            ),
          )
        ],
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: ListView(
          children: [
            const GraphContainer(),
            const SizedBox(height: 24),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: SizedBox(
                height: 400,
                width: size.width,
                child: GridView.builder(
                  itemBuilder: (context, index) =>
                      SummaryCard(data: summary[index]),
                  itemCount: summary.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.9,
                    crossAxisSpacing: 9,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 75,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
