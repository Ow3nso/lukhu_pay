import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        CustomColors,
        DefaultBackButton,
        DefaultButton,
        GlobalAppUtil,
        ReadContext,
        StyleColors,
        TransactionType,
        WatchContext;
import 'package:lukhu_pay/src/controller/accounts_controller.dart';
import 'package:lukhu_pay/src/controller/keypad_controller.dart';
import 'package:lukhu_pay/src/controller/payment_controller.dart';
import 'package:lukhu_pay/src/widgets/billing/topup_card.dart';

import 'amount_card.dart';

class BillingCard extends StatelessWidget {
  const BillingCard({
    super.key,
    required this.label,
    this.onConfirm,
    required this.title,
    this.type = TransactionType.topup,
  });
  final String label;
  final String title;
  final Function()? onConfirm;
  final TransactionType type;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var isPaySelected = context.watch<AccountsController>().isPaymentSelected;
    return WillPopScope(
      onWillPop: () async {
        context.read<AccountsController>().reset();
        return true;
      },
      child: Container(
        width: size.width,
        height: isPaySelected && type == TransactionType.topup ? 430 : 550,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            border: Border.all(color: StyleColors.lukhuDividerColor),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Text(title,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.scrim,
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                  DefaultBackButton(
                    onTap: () {
                      context.read<AccountsController>().reset();
                      Navigator.of(context).pop();
                    },
                    assetIcon: GlobalAppUtil.closeIcon,
                    packageName: GlobalAppUtil.productListingPackageName,
                  )
                ],
              ),
            ),
            Divider(color: StyleColors.lukhuDividerColor),
            AmountCard(
              amount: context.watch<KeypadController>().keyPadCode,
              onTap: () {
                context.read<AccountsController>().reset();
                Navigator.of(context).pop();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: Column(
                children: [
                  if (type == TransactionType.topup)
                    const TopUpCard(
                      title: 'Select a Top-up Method',
                    ),
                  if (type == TransactionType.withdraw)
                    const TopUpCard(
                      title: 'Select a Withdrawal Method',
                      type: TransactionType.withdraw,
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: DefaultButton(
                label: label,
                color: Theme.of(context).extension<CustomColors>()?.neutral,
                textColor: Theme.of(context).colorScheme.onPrimary,
                loading: context.watch<PaymentController>().isLoading,
                actionDissabledColor: StyleColors.lukhuDisabledButtonColor,
                onTap: context
                        .watch<AccountsController>()
                        .selectedMethod
                        .keys
                        .isNotEmpty
                    ? () {
                        if (onConfirm != null) {
                          onConfirm!();
                        }
                      }
                    : null,
                width: size.width - 32,
                height: 40,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: DefaultButton(
                label: 'Cancel',
                color: Theme.of(context).colorScheme.onPrimary,
                textColor: Theme.of(context).colorScheme.scrim,
                boarderColor: StyleColors.lukhuDividerColor,
                onTap: () {
                  Navigator.of(context).pop();
                },
                width: size.width - 32,
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
