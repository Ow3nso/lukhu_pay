import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        CircularCheckbox,
        CustomColors,
        GlobalAppUtil,
        PaymentModel,
        StyleColors,
        TransactionType;
import 'package:lukhu_pay/util/app_util.dart';

class AccountTile extends StatelessWidget {
  const AccountTile(
      {super.key,
      required this.data,
      this.onTap,
      this.height,
      this.type = TransactionType.other,
      this.color = Colors.black,
      this.packageName,
      this.model,
      required this.image});
  final Map<String, dynamic> data;
  final void Function()? onTap;
  final TransactionType type;
  final double? height;
  final Color? color;
  final String? packageName;
  final PaymentModel? model;
  final String image;

  @override
  Widget build(BuildContext context) {
    bool show = type != TransactionType.other;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: AnimatedContainer(
        height: (model?.isChecked ?? data['isChecked']) && show ? 200 : height,
        duration: AppUtil.animationDuration,
        decoration: BoxDecoration(
          color: (model?.isChecked ?? data['isChecked']) && show
              ? StyleColors.lukhuBlue10
              : Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: StyleColors.lukhuDividerColor,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InkWell(
              onTap: onTap,
              child: Row(
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
                      image,
                      package: packageName ??
                          GlobalAppUtil.productListingPackageName,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    model?.account ?? data['account'],
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  if ((model?.isChecked ?? data['isChecked']) &&
                      type == TransactionType.other)
                    Text(
                      'Edit',
                      style: TextStyle(
                        color: Theme.of(context)
                            .extension<CustomColors>()
                            ?.neutral,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  if (!(model?.isChecked ?? data['isChecked']) || show)
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: StyleColors.lukhuDividerColor)),
                      child: CircularCheckbox(
                        isChecked: (model?.isChecked ?? data['isChecked']),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
