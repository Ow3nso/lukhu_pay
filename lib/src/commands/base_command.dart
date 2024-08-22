import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show CartController, Provider, UserRepository, ExpenseController;
import 'package:lukhu_pay/lukhu_pay.dart';
import 'package:lukhu_pay/src/controller/top_withdraw_controller.dart';

import '../controller/keypad_controller.dart';

abstract class BaseCommand {
  static BuildContext? _lastKnownRoot;

  late BuildContext context;

  BaseCommand(BuildContext c) {
    context = (c == _lastKnownRoot) ? c : Provider.of(c, listen: false);
    _lastKnownRoot = context;
  }

  Future execute();

  Future clear();

  T getProvided<T>() => Provider.of<T>(context, listen: false);

  AccountsController get accountController => getProvided();

  PaymentController get paymentController => getProvided();

  TopWithdrawController get topWithdrawController => getProvided();

  KeypadController get keyPadController => getProvided();

  UserRepository get userRepository => getProvided();

  CartController get cartController => getProvided();

  TransactionController get transactionController => getProvided();

  ExpenseController get expenseController => getProvided();
}

mixin CancellableCommandMixin on BaseCommand {
  bool isCancelled = false;

  bool cancel() => isCancelled = true;
}
