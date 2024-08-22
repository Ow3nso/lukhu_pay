import 'package:flutter/material.dart';

import '../../../util/app_util.dart';

class WalletOption extends StatelessWidget {
  const WalletOption({
    super.key,
    required this.option,
    this.onTap,
  });

  final Map<String, dynamic> option;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(
              option['image'],
              package: AppUtil.packageName,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          option['name'],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
