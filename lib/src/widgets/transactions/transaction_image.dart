import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart';

import '../../../util/app_util.dart';

class TransactionImage extends StatelessWidget {
  const TransactionImage(
      {super.key, required this.transaction, this.padding = 0});
  final Transaction transaction;
  final double padding;

  @override
  Widget build(BuildContext context) {
    var statusType = transaction.metadata ?? {};
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppUtil.transactionTypeColor(statusType, transaction).first,
        borderRadius: BorderRadius.circular(4),
      ),
      child: transaction.imageUrl == null
          ? Image.asset(
              AppUtil.transactionIcon(AppUtil.transactionType(statusType)),
              package: AppUtil.packageName,
              alignment: Alignment.center,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: ImageCard(
                image: transaction.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
