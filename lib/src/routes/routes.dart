import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show ChangeNotifierProvider, Provider, SingleChildWidget;
import 'package:lukhu_pay/src/controller/accounts_controller.dart';
import 'package:lukhu_pay/src/controller/analytics_controller.dart';
import 'package:lukhu_pay/src/controller/keypad_controller.dart';
import 'package:lukhu_pay/src/controller/transaction_controller.dart';
import 'package:lukhu_pay/src/controller/wallet_controller.dart';

import '../controller/payment_controller.dart';
import '../controller/plan_controller.dart';
import '../controller/top_withdraw_controller.dart';
import '../pages/index.dart';

class LukhuPayRoutes {
  static Map<String, Widget Function(BuildContext)> guarded = {
    WalletPage.routeName: (context) => const WalletPage(),
    TransactionsPage.routeName: (context) => const TransactionsPage(),
    TopUpPage.routeName: (context) => const TopUpPage(),
    WithdrawalPage.routeName: (context) => const WithdrawalPage(),
    AnalyticsPage.routeName: (context) => const AnalyticsPage(),
    PaySettingsPage.routeName: (context) => const PaySettingsPage(),
    PlansView.routeName: (context) => const PlansView(),
    PlanCompareView.routeName: (context) => const PlanCompareView(),
    LoadingView.routeName: (context) => const LoadingView(),
  };

  static Map<String, Widget Function(BuildContext)> public = {};

  static List<SingleChildWidget> providers() {
    return [
      ChangeNotifierProvider(
        create: (context) => WalletController(),
      ),
      ChangeNotifierProvider(
        create: (_) => TransactionController(),
      ),
      ChangeNotifierProvider(
        create: (context) => AccountsController(),
      ),
      ChangeNotifierProvider(
        create: (context) => KeypadController(),
      ),
      ChangeNotifierProvider(
        create: (context) => AnalyticsController(),
      ),
      ChangeNotifierProvider(create: (context) => PlanController()),
      ChangeNotifierProvider(create: (context) => PaymentController()),
      ChangeNotifierProvider(create: (context) => TopWithdrawController()),
      Provider<BuildContext>(create: (c) => c),
    ];
  }
}
