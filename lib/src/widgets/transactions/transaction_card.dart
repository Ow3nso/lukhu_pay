import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show DateFormat, NumberFormat, StatusCard, StyleColors, Transaction;
import 'package:lukhu_pay/src/widgets/wallet/wallet_text.dart';
import 'package:lukhu_pay/util/app_util.dart';

import 'transaction_image.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard(
      {super.key, this.show = false, this.onTap, required this.transaction});
  final bool show;
  final void Function()? onTap;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var statusType = transaction.metadata ?? {};
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          width: size.width,
          child: Row(
            children: [
              SizedBox(
                height: 32,
                width: 32,
                child: TransactionImage(
                  transaction: transaction,
                  padding: 0,
                ),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transaction.description ?? '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.scrim,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('HH:mm a').format(transaction.createdAt!),
                    style: TextStyle(
                      color: StyleColors.lukhuGrey50,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (statusType['type'] != null)
                StatusCard(
                  type: AppUtil.statusType(statusType),
                ),
              const SizedBox(width: 8),
              WalletText(
                description:
                    '${AppUtil.transactionOperator(AppUtil.transactionType(statusType))} ${NumberFormat.currency(
                  locale: 'en_US',
                  symbol: 'KES ',
                ).format(transaction.amount ?? 0)}',
                style: TextStyle(
                  color: AppUtil.transactionTypeColor(statusType, transaction)
                      .last, // textColor(statusType),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                show: show,
              ),
              const SizedBox(
                width: 4,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.scrim,
                size: 14,
              )
            ],
          ),
        ),
      ),
    );
  }
}
