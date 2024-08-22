import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AppBarType,
        BlurDialogBody,
        DefaultBackButton,
        Helpers,
        LuhkuAppBar,
        MpesaFields,
        NavigationService,
        ReadContext,
        ShortMessageType,
        ShortMessages,
        StyleColors,
        WatchContext,
        Uuid;
import 'package:lukhu_pay/lukhu_pay.dart';
import 'package:lukhu_pay/src/widgets/billing/billing_card.dart';
import 'package:lukhu_pay/src/widgets/default_key_pad.dart';

import '../controller/keypad_controller.dart';
import '../widgets/billing/billing_amount.dart';
import '../widgets/billing/error_card.dart';
import '../widgets/billing/success_card.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({super.key});
  static const routeName = 'top_up';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        context.read<KeypadController>().keyPadCode = '';
        context.read<AccountsController>().isError = false;
        context.read<AccountsController>().isSuccess = false;
        context.read<AccountsController>().showGlow = false;
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
                    context.read<AccountsController>().isError = false;
                    context.read<AccountsController>().isSuccess = false;
                    context.read<AccountsController>().showGlow = false;
                    Navigator.of(context).pop();
                  },
                ),
                centerTitle: true,
                title: Text(
                  'Top-Up',
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
                            'Top-up Amount',
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
                      label: 'Top-Up Wallet',
                      onDelete: () {
                        context.read<KeypadController>().deleteCode();
                      },
                      onConfirm:
                          context.read<KeypadController>().keyPadCode.isNotEmpty
                              ? () {
                                  context.read<AccountsController>().reset();
                                  show(context);
                                }
                              : null,
                      onTap: (value) {
                        context.read<KeypadController>().createCode(value);
                        log('[VALUE]$value');
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (context.watch<AccountsController>().isSuccess)
              Positioned(
                child: SuccessCard(
                  onTap: () {
                    context.read<AccountsController>().reset();

                    Navigator.of(context).pop();
                  },
                  title: 'Top-up Successful',
                  description:
                      'Your wallet top-up request was successful. You can find the details below for your reference.',
                  subTitle: 'Top-up Details',
                ),
              ),
            if (context.watch<AccountsController>().isError)
              Positioned(
                child: ErrorCard(
                  title: 'Top-up Failed',
                  description:
                      'We were unable to complete your wallet top-up request. Tap below to retry',
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
          label: 'Confirm',
          title: 'Top-up your wallet',
          onConfirm: () {
            _confirmPayment(context).then((value) {});
          },
        ),
      ),
    );
  }

  Future<void> _confirmPayment(BuildContext context) async {
    var payMethod =
        context.read<AccountsController>().selectedMethod.values.first;
    context.read<PaymentController>().isLoading = true;

    context
        .read<PaymentController>()
        .initiatePayment(type: payMethod.type!, post: {
      MpesaFields.amount: context.read<KeypadController>().keyPadCode,
      MpesaFields.phoneNumber: payMethod.account ?? '',
      MpesaFields.reference: const Uuid().v4(),
    }).then((result) {
      Helpers.debugLog('RESULT: $result');
      Future.delayed(const Duration(milliseconds: 3500));
      if (result || context.read<PaymentController>().isPaymentComplete) {
        context.read<PaymentController>().isTopUp = true;
        NavigationService.navigate(context, LoadingView.routeName);
        return;
      }
      ShortMessages.showShortMessage(
        message: 'Something went wrong!. Please try again.',
        type: ShortMessageType.error,
      );
      Navigator.of(context).pop();
    }).catchError((e) {
      ShortMessages.showShortMessage(message: 'Something went wrong!');
      // return false;
    });

    return;
  }
}
