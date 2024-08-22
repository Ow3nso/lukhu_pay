import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart';

class AccountInfo extends StatelessWidget {
  const AccountInfo(
      {super.key,
      this.isChecked = false,
      this.title = '',
      this.onTap,
      this.type = AccountType.mpesa});
  final bool isChecked;
  final String title;
  final void Function()? onTap;
  final AccountType type;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: StyleColors.lukhuDividerColor,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                type == AccountType.mpesa
                    ? title
                    : 'Card ending in ${title.substring(title.length - 4)}',
                style: TextStyle(
                    color: StyleColors.lukhuGrey70,
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: StyleColors.lukhuDividerColor)),
              child: CircularCheckbox(
                isChecked: isChecked,
              ),
            )
          ],
        ),
      ),
    );
  }
}
