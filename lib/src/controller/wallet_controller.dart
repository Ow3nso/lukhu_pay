import 'package:flutter/material.dart';

class WalletController extends ChangeNotifier {
  bool _showBalance = true;
  bool get showBalance => _showBalance;

  set showBalance(bool value) {
    _showBalance = value;
    notifyListeners();
  }
}
