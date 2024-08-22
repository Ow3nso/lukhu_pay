import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show CustomColors, DefaultButton, ReadContext, ReportButton, StyleColors;
import 'package:lukhu_pay/src/controller/accounts_controller.dart';
import 'package:lukhu_pay/util/app_util.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard(
      {super.key,
      required this.title,
      required this.description,
      this.onReport,
      this.onTap});
  final String title;
  final String description;
  final void Function()? onReport;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        context.read<AccountsController>().reset();
        return true;
      },
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: StyleColors.lukhuRuby10,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: StyleColors.boarderErrorRed,
                child: Image.asset(
                  AppUtil.dangerIcon,
                  package: AppUtil.packageName,
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
            DefaultButton(
              label: 'Retry',
              color: Theme.of(context).extension<CustomColors>()?.neutral,
              textColor: Theme.of(context).colorScheme.onPrimary,
              actionDissabledColor: StyleColors.lukhuDisabledButtonColor,
              onTap: onTap,
              width: size.width - 32,
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ReportButton(
                onTap: onReport,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
