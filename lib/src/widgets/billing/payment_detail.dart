import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show AccountType, BlurDialogBody, CustomColors, GlobalAppUtil, StyleColors;
import 'package:lukhu_pay/src/widgets/settings/add_card.dart';
import 'package:lukhu_pay/src/widgets/settings/add_number.dart';
import 'package:lukhu_pay/util/app_util.dart';

class PaymentDetail extends StatelessWidget {
  const PaymentDetail({super.key, required this.data, this.onTap});
  final Map<String, dynamic> data;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Widget child;
        if (AppUtil.accountType(data) == AccountType.mpesa) {
          child = AddNumber(
            label: 'Add your number',
            onTap: (value) {},
          );
        } else {
          child = AddCard(
            label: 'Add your card',
            onTap: (value) {},
          );
        }

        _showEdit(context, child);
      },
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            border: Border.all(color: StyleColors.lukhuDividerColor),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: StyleColors.lukhuDividerColor,
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                data['image'],
                package: GlobalAppUtil.productListingPackageName,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Details',
                    style: TextStyle(
                        color: StyleColors.lukhuGrey60,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                  Text(
                    data['account'],
                    style: TextStyle(
                        color: StyleColors.lukhuGrey80,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                  Text(
                    'Edit',
                    style: TextStyle(
                        color: Theme.of(context)
                            .extension<CustomColors>()
                            ?.neutral,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showEdit(BuildContext context, Widget child) {
    showDialog(
      context: context,
      builder: (context) {
        return BlurDialogBody(
          bottomDistance: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: child,
          ),
        );
      },
    );
  }
}
