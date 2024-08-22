import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show DefaultTextBtn, StyleColors;

class AmountCard extends StatelessWidget {
  const AmountCard({super.key, required this.amount, this.onTap});
  final String amount;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 24, bottom: 24),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            border: Border.all(color: StyleColors.lukhuDividerColor),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(
                        color: StyleColors.lukhuGrey70,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                  Text(
                    'KSh $amount',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.scrim,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            DefaultTextBtn(label: 'Edit', onTap: onTap)
          ],
        ),
      ),
    );
  }
}
