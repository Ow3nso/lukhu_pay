import 'package:flutter/material.dart';

class CreditText extends StatelessWidget {
  const CreditText({super.key, this.title = '', this.description = ''});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
