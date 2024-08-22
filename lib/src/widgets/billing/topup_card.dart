import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show TransactionType, WatchContext;
import 'package:lukhu_pay/src/controller/accounts_controller.dart';
import 'package:lukhu_pay/src/widgets/billing/payment_detail.dart';

import 'paymethod_container.dart';

class TopUpCard extends StatelessWidget {
  const TopUpCard({super.key, required this.title, this.type});
  final String title;
  final TransactionType? type;

  @override
  Widget build(BuildContext context) {
    //  controller.checkedBillingMethods.isEmpty
    //     ?
    //     : controller.checkedBillingMethods;
    var isPaySelected = context.watch<AccountsController>().isPaymentSelected;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: isPaySelected ? 110 : 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.scrim,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          isPaySelected
              ? PaymentDetail(
                  data: context.watch<AccountsController>().selectedPayMethod,
                  onTap: () {},
                )
              : Expanded(
                  child: PaymethodContainer(
                    type: type,
                  ),
                )
        ],
      ),
    );
  }
}
