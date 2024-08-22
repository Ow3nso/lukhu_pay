import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show InvoiceModel, LoaderCard, ReadContext, WatchContext;
import 'package:lukhu_pay/src/commands/top_command.dart';
import 'package:lukhu_pay/src/controller/accounts_controller.dart';
import 'package:lukhu_pay/src/controller/payment_controller.dart';

import '../widgets/billing/error_card.dart';
import '../widgets/billing/success_card.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});
  static const routeName = 'loading';

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  late TopUpCommand _topUpCommand;

  PaymentController get paymentController => context.read<PaymentController>();
  set paymentController(PaymentController value) {
    paymentController = value;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PaymentController>().invoice = InvoiceModel.empty();
      _topUpCommand = TopUpCommand(context)..execute(true);
    });
  }

  @override
  void dispose() {
    _topUpCommand.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => false);
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: const LoaderCard(
                title: 'Please wait as your top-up request is being processed.',
              ),
            ),
            if (context.watch<AccountsController>().isSuccess)
              Positioned(
                child: SuccessCard(
                  onTap: () {
                    _topUpCommand.clear().then((value) {
                      if (value) {
                        Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        );
                      }
                    });
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
}
