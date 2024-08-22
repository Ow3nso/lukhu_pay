import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart';

class BillingAmount extends StatelessWidget {
  const BillingAmount({super.key, required this.amount});
  final String amount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  NumberFormat.currency(
                    locale: 'en_US',
                    symbol: 'KES ',
                  ).format(double.parse(amount)),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.scrim,
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
          Divider(color: Theme.of(context).colorScheme.scrim)
        ],
      ),
    );
  }
}
