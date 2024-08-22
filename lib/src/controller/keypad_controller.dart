import 'package:flutter/material.dart';

class KeypadController extends ChangeNotifier {
  String _keyPadCode = '';
  String get keyPadCode => _keyPadCode;
  set keyPadCode(String value) {
    _keyPadCode = value;
    notifyListeners();
  }

  void createCode(String value) {
    if (keyPadCode.startsWith('0')) {
      keyPadCode.replaceAll('0', '');
      keyPadCode += value;
    } else {
      keyPadCode += value;
    }

    //keyPadCode = keyPadCode.substring(0, keyPadCode.length - 1);
  }

  void deleteCode() {
    if (keyPadCode.isNotEmpty) {
      keyPadCode = keyPadCode.substring(0, keyPadCode.length - 1);
    } else if (keyPadCode.startsWith('0') || keyPadCode.isEmpty) {
      keyPadCode = '';
    }
  }
}
