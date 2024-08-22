import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        DateFormat,
        DefaultBackButton,
        GlobalAppUtil,
        StatusCard,
        StyleColors,
        Transaction;
import 'package:lukhu_pay/src/widgets/report_problem.dart';

import '../../../util/app_util.dart';
import 'detail_card.dart';
import 'transaction_image.dart';

class TransactionDetail extends StatelessWidget {
  const TransactionDetail({super.key, required this.transactions});
  final Transaction transactions;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var statusType = transactions.metadata ?? {};
    return Container(
      width: size.width,
      height: 419,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 16, bottom: 24, right: 8, left: 16),
            child: Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: TransactionImage(
                    transaction: transactions,
                    padding: 0,
                  ),
                ),
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transactions.description ?? '',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.scrim,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm a').format(transactions.createdAt!),
                      style: TextStyle(
                        color: StyleColors.lukhuGrey80,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                DefaultBackButton(
                  assetIcon: GlobalAppUtil.closeIcon,
                  packageName: GlobalAppUtil.productListingPackageName,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        AppUtil.transactionTypeColor(statusType, transactions)
                            .first,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${transactions.imageUrl == null ? AppUtil.transactionOperator(AppUtil.transactionType(statusType)) : ''}${transactions.currency} ${transactions.amount ?? '0'}',
                    style: TextStyle(
                      color:
                          AppUtil.transactionTypeColor(statusType, transactions)
                              .last,
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: DetailCard(
                    title: 'Date and Time',
                    description: DateFormat('MMMM dd, yyyy - HH:mm').format(
                      transactions.createdAt!,
                    ),
                  ),
                ),
                DetailCard(
                  title: 'Transaction no.',
                  description: transactions.transactionId ?? '',
                  child: Image.asset(
                    AppUtil.copyIcon,
                    package: AppUtil.packageName,
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                if (statusType['type'] != null)
                  DetailCard(
                    description: 'Order Status',
                    child: StatusCard(
                      type: AppUtil.statusType(statusType),
                    ),
                  ),
                ReportButton(
                  onTap: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
