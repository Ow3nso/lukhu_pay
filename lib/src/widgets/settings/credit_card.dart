import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show AccountType, GlobalAppUtil, PaymentModel, StyleColors;
import 'package:lukhu_pay/util/app_util.dart';

import 'credit_text.dart';

class CreditCard extends StatelessWidget {
  const CreditCard({super.key, required this.model, this.onTap});
  final PaymentModel model;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var type = model.type ?? AccountType.mpesa;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppUtil.accountColor(type),
              stops: const [
                0.1,
                1,
              ]),
          color: AppUtil.accountColor(type).first,
        ),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 26,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  border: Border.all(color: StyleColors.lukhuDividerColor),
                  borderRadius: BorderRadius.circular(4)),
              child: Image.asset(
                type == AccountType.visa
                    ? AppUtil.visaIcon
                    : AppUtil.masterIcon,
                package: GlobalAppUtil.productListingPackageName,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 23),
              child: Text(
                model.account ?? '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CreditText(
                  title: 'Card Hold',
                  description: model.name ?? '',
                ),
                CreditText(
                  title: 'Exp. Date',
                  description: model.expiryDate ?? '',
                )
              ],
            ),
            const SizedBox(
              height: 2,
            ),
          ],
        ),
      ),
    );
  }
}
