import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AppBarType,
        BlurDialogBody,
        DefaultBackButton,
        LoaderCard,
        LuhkuAppBar,
        ReadContext,
        ShortMessages,
        StyleColors,
        TransactionType,
        WatchContext;
import 'package:lukhu_pay/src/controller/accounts_controller.dart';
import 'package:lukhu_pay/src/widgets/billing/error_card.dart';
import 'package:lukhu_pay/src/widgets/billing/success_card.dart';

import '../controller/keypad_controller.dart';
import '../widgets/billing/billing_amount.dart';
import '../widgets/billing/billing_card.dart';
import '../widgets/default_key_pad.dart';

class WithdrawalPage extends StatelessWidget {
  const WithdrawalPage({super.key});
  static const routeName = 'withdraw';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var success = context.watch<AccountsController>().isSuccess;
    var error = context.watch<AccountsController>().isError;
    return WillPopScope(
      onWillPop: () async {
        context.read<KeypadController>().keyPadCode = '';
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Scaffold(
              appBar: LuhkuAppBar(
                appBarType: AppBarType.other,
                backAction: DefaultBackButton(
                  onTap: () {
                    context.read<KeypadController>().keyPadCode = '';
                    Navigator.of(context).pop();
                  },
                ),
                centerTitle: true,
                title: Text(
                  'Withdraw',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.scrim,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              body: SizedBox(
                height: size.height,
                width: size.width,
                child: ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Withdraw Amount',
                            style: TextStyle(
                                color: StyleColors.lukhuGrey70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          BillingAmount(
                            amount: context
                                    .watch<KeypadController>()
                                    .keyPadCode
                                    .isEmpty
                                ? '0'
                                : context.watch<KeypadController>().keyPadCode,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    DefaultKeyPad(
                      label: 'Withdraw',
                      onDelete: () {
                        context.read<KeypadController>().deleteCode();
                      },
                      onConfirm: () {
                        context.read<AccountsController>().reset();
                        context.read<AccountsController>().pickbilling(0);

                        show(context);
                      },
                      onTap: (value) {
                        context.read<KeypadController>().createCode(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (context.watch<AccountsController>().showGlow)
              const Positioned(
                child: LoaderCard(
                  title:
                      'Please wait as your withdrawal request is being processed.',
                ),
              ),
            if (success)
              Positioned(
                child: SuccessCard(
                  onTap: () {
                    context.read<AccountsController>().reset();

                    Navigator.of(context).pop();
                  },
                  title: 'Withdraw Successful',
                  description:
                      'Your wallet withdrawal request was successful. You can find the details below for your reference.',
                  subTitle: 'Withdrawal Details',
                ),
              ),
            if (error)
              Positioned(
                child: ErrorCard(
                  title: 'Withdrawal Failed',
                  description:
                      'We were unable to complete your wallet withdrawal request. Tap below to retry',
                  onTap: () {
                    context.read<AccountsController>().reset();
                    context.read<AccountsController>().startTimer(() {});
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  void show(BuildContext context) {
    if (context.read<KeypadController>().keyPadCode.isEmpty) {
      ShortMessages.showShortMessage(
          message: "To proceed, add a valid amount!.");
      return;
    }
    if (context.read<KeypadController>().keyPadCode == '0') {
      ShortMessages.showShortMessage(
          message: "To proceed, amount must be greater than zero!.");
      return;
    }
    showDialog(
      context: context,
      builder: (context) => BlurDialogBody(
        child: BillingCard(
          type: TransactionType.withdraw,
          label: 'Confirm',
          title: 'Withdraw',
          onConfirm: () {
            Navigator.of(context).pop();
            context.read<AccountsController>().startTimer(() {});
          },
        ),
      ),
    );
  }
}
