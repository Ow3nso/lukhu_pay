import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AppDBConstants,
        CartController,
        FirebaseFirestore,
        Helpers,
        InvoiceModel,
        MpesaModel,
        NavigationService,
        ReadContext,
        ShortMessages,
        StringExtension,
        Transaction,
        TransactionFields,
        UserRepository;
import 'package:lukhu_pay/util/app_util.dart';

class TransactionController extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  Map<String, Transaction> _transactions = {};
  Map<String, Transaction> get transactions => _transactions;
  set transactions(Map<String, Transaction> value) {
    _transactions = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> filterTransactions = AppUtil.filterTransactions;

  Set<String> selectedFilterTransactions = {};

  TransactionController() {
    init();
  }

  MpesaModel? _mpesaModel;
  MpesaModel? get mpesaModel => _mpesaModel;
  set mpesaModel(MpesaModel? value) {
    _mpesaModel = value;
    notifyListeners();
  }

  InvoiceModel? _invoice;
  InvoiceModel? get invoice => _invoice;
  set invoice(InvoiceModel? value) {
    _invoice = value;
    notifyListeners();
  }

  late TextEditingController missingNameontroller;
  late TextEditingController missingPhoneController;
  late GlobalKey<FormState> missingDetailsFormKey;

  void init() {
    missingDetailsFormKey = GlobalKey();
    missingPhoneController = TextEditingController();
    missingNameontroller = TextEditingController();
    mpesaModel = null;
    isPaymentComplete = false;
    isVerified = false;
    invoiceID = null;
  }

  Future<void> updateMissingDetails() async {
    if (missingDetailsFormKey.currentState!.validate()) {
      BuildContext? context = NavigationService.navigatorKey.currentContext;
      if (context == null) return;

      var order = context.read<CartController>().order;

      order = order!.copyWith(
        name: missingNameontroller.text.trim(),
        phoneNumber: missingPhoneController.text.trim().toLukhuNumber().trim(),
      );

      Navigator.pop(context, true);
      ShortMessages.showShortMessage(message: 'Details updated successfully!.');
    }
  }

  Map<String, Transaction> _shopTransaction = {};
  Map<String, Transaction> get shopTransaction => _shopTransaction;
  set shopTransaction(Map<String, Transaction> value) {
    _shopTransaction = value;
    notifyListeners();
  }

  Map<String, Map<String, Transaction>> similarTransactions = {};

  Future<bool> getTransactions({
    bool isRefreshMode = false,
    int limit = 10,
  }) async {
    BuildContext? context = NavigationService.navigatorKey.currentContext;
    if (context == null) return false;
    var shopId = context.read<UserRepository>().shop?.shopId;
    if (!isRefreshMode && similarTransactions[shopId] != null) {
      return false;
    }

    try {
      final transactionDoc = await db
          .collection(AppDBConstants.transactionCollection)
          .where(TransactionFields.shopId, isEqualTo: shopId)
          .get();

      if (transactionDoc.docs.isNotEmpty) {
        shopTransaction = {
          for (var e in transactionDoc.docs)
            e.id: Transaction.fromJson(e.data())
        };

        similarTransactions[shopId!] = shopTransaction;
        return true;
      }
    } catch (e) {
      Helpers.debugLog('An Error occurred while fetching transactions: $e');
      return false;
    }
    return false;
  }

  Transaction? _transaction;
  Transaction? get transaction => _transaction;
  set transaction(Transaction? value) {
    _transaction = value;
    notifyListeners();
  }

  /// It takes an index, and then it checks if the index is checked, if it is, it adds it to the
  /// selectedFilterTransactions list, if it isn't, it removes it from the list
  ///
  /// Args:
  ///   index (int): The index of the item in the list.
  void chooseOption(
    int index,
  ) {
    filterTransactions[index]['isChecked'] =
        !filterTransactions[index]['isChecked'];
    if (filterTransactions[index]['isChecked']) {
      selectedFilterTransactions.add(filterTransactions[index]['name']);
    } else {
      selectedFilterTransactions.remove(filterTransactions[index]['name']);
    }
    log('[SELECTED]=$selectedFilterTransactions');
    notifyListeners();
  }

  String? _invoiceID;
  String? get invoiceID => _invoiceID;
  set invoiceID(String? value) {
    _invoiceID = value;
    notifyListeners();
  }

  bool _isPaymentComplete = false;
  bool get isPaymentComplete => _isPaymentComplete;
  set isPaymentComplete(bool value) {
    _isPaymentComplete = value;
    notifyListeners();
  }

  bool _isVerified = false;
  bool get isVerified => _isVerified;
  set isVerified(bool value) {
    _isVerified = value;
    notifyListeners();
  }
}
