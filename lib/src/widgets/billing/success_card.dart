import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        CustomColors,
        DateFormat,
        DefaultButton,
        GlobalAppUtil,
        NumberFormat,
        ReadContext,
        ShortMessages,
        StyleColors,
        TransactionType,
        WatchContext;
import 'package:lukhu_pay/lukhu_pay.dart' show ReportButton;
import 'package:lukhu_pay/src/controller/keypad_controller.dart';
import 'package:lukhu_pay/src/controller/payment_controller.dart';

import '../../../util/app_util.dart';
import '../transactions/detail_card.dart';

class SuccessCard extends StatelessWidget {
  const SuccessCard(
      {super.key,
      required this.title,
      required this.description,
      required this.subTitle,
      this.type = TransactionType.topup,
      this.onReport,
      this.onTap});
  final String title;
  final String description;
  final String subTitle;
  final TransactionType type;
  final void Function()? onReport;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 75),
            child: CircleAvatar(
              backgroundColor: StyleColors.shadeColor1,
              radius: 24,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: StyleColors.shadeColor2,
                child: Image.asset(
                  AppUtil.iconCircleCheck,
                  package: GlobalAppUtil.mainPackageName,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.scrim,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: StyleColors.lukhuGrey80,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                subTitle,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.scrim,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppUtil.getTransactionColor(type).first,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${NumberFormat.currency(
                locale: 'en_US',
                symbol: 'KES ',
              ).format(double.parse(context.read<KeypadController>().keyPadCode))}',
              style: TextStyle(
                color: AppUtil.getTransactionColor(type).last,
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
                DateTime.now(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: DetailCard(
              title: 'Transaction no.',
              description:
                  context.watch<PaymentController>().invoice?.mpesaReference,
              child: Image.asset(
                AppUtil.copyIcon,
                package: AppUtil.packageName,
              ),
              onTap: () {
                if (context.read<PaymentController>().invoice?.mpesaReference ==
                    '') return;
                Clipboard.setData(
                  ClipboardData(
                      text: context
                              .read<PaymentController>()
                              .invoice
                              ?.mpesaReference ??
                          ''),
                );

                ShortMessages.showShortMessage(
                  message: 'Transaction no. copied',
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 79),
            child: ReportButton(
              onTap: onReport,
            ),
          ),
          DefaultButton(
            label: 'Back to Wallet',
            color: Theme.of(context).extension<CustomColors>()?.neutral,
            textColor: Theme.of(context).colorScheme.onPrimary,
            actionDissabledColor: StyleColors.lukhuDisabledButtonColor,
            onTap: onTap,
            width: size.width - 32,
            height: 40,
          ),
        ],
      ),
    );
  }
}
