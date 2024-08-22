import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show AccountType, CustomColors, ReadContext, TransactionType, WatchContext;

import '../../../util/app_util.dart';
import '../../controller/accounts_controller.dart';
import '../settings/account_card.dart';

class WithdrawCard extends StatelessWidget {
  const WithdrawCard({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = context.watch<AccountsController>();
    // var data = controller.checkedBillingMethods.isEmpty
    //     ? controller.billingMethods
    //         .where((value) => value['account'] == 'Mpesa')
    //         .toList()
    //     : controller.checkedBillingMethods;
    var data = controller.getPhoneAccounts();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select a withdrawal Method',
            style: TextStyle(
              color: Theme.of(context).colorScheme.scrim,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var account =
                    context.read<AccountsController>().dataModel(index, data)!;
                return AccountTile(
                  model: account,
                  image: AppUtil.getPayIcon(AccountType.mpesa),
                  data: account.toJson(),
                  color: !context
                          .watch<AccountsController>()
                          .isPaymodelSelected(account.id ?? "")
                      ? Theme.of(context).colorScheme.scrim
                      : Theme.of(context).extension<CustomColors>()?.neutral,
                  onTap: () {
                    context
                        .read<AccountsController>()
                        .toggleSelectedMethod(account.id!);
                    // context.read<AccountsController>().pickbilling(index);
                  },
                  type: TransactionType.withdraw,
                );
              },
              itemCount: data.keys.length,
            ),
          )
        ],
      ),
    );
  }
}
