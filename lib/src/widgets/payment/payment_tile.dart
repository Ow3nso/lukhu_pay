import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show CircularCheckbox, DefaultTextBtn, StyleColors;

class PaymentOptionTile extends StatelessWidget {
  const PaymentOptionTile({
    super.key,
    required this.data,
    this.isChecked = false,
    this.onTap,
  });

  final Map<String, dynamic> data;
  final bool isChecked;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: StyleColors.lukhuDividerColor,
          )),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          height: 32,
          width: 46,
          decoration: BoxDecoration(
            color: data['color'],
            border: Border.all(color: StyleColors.lukhuDividerColor),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            data['image'],
            package: data['package'],
          ),
        ),
        horizontalTitleGap: 10,
        title: Text(
          '${data['name']}${data['account'] != null && data['account'] != '' ? '- ${data['account']}' : ''}',
          style: TextStyle(
            color: isChecked
                ? StyleColors.lukhuBlue
                : Theme.of(context).colorScheme.scrim,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: isChecked
            ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      'Set Default',
                      style: TextStyle(
                        color: StyleColors.lukhuBlue50,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  DefaultTextBtn(
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: StyleColors.lukhuBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              )
            : null,
        trailing: CircularCheckbox(
          isChecked: isChecked,
        ),
      ),
    );
  }
}
