import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AccountType,
        AppDBConstants,
        CartController,
        // DeliveryStatus,
        ExternalRequestService,
        FirebaseFirestore,
        Helpers,
        InvoiceModel,
        MpesaModel,
        NavigationService,
        ReadContext,
        Transaction,
        // TransactionType,
        UserRepository,
        Uuid;

import '../../util/app_util.dart';
import 'keypad_controller.dart';

class PaymentController extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> initiatePayment({
    required AccountType type,
    required Map<String, String> post,
  }) async {
    isLoading = true;

    try {
      switch (type) {
        case AccountType.mpesa:
          return transactThroughMpesa(post);
        case AccountType.card:
          return transactThroughCard();
        default:
          return transactThroughMpesa(post);
      }
    } catch (e) {
      Helpers.debugLog('Something went wrong with transaction: $e');
      rethrow;
    }
  }

  InvoiceModel? _invoice;
  InvoiceModel? get invoice => _invoice;
  set invoice(InvoiceModel? value) {
    _invoice = value;
    notifyListeners();
  }

  String? _invoiceId;
  String? get invoiceId => _invoiceId;
  set invoiceId(String? value) {
    _invoiceId = value;
    notifyListeners();
  }

  MpesaModel? _mpesaModel;
  MpesaModel? get mpesaModel => _mpesaModel;
  set mpesaModel(MpesaModel? value) {
    _mpesaModel = value;
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

  Future<bool> transactThroughMpesa(Map<String, String> post) async {
    try {
      final response = await ExternalRequestService.makeRequest(
        url: "${AppUtil.paymentUriApi}${AppUtil.mpesa}",
        body: post,
        request: 'post',
        encode: false,
        headers: {'Authorization': 'NoAuth'},
      );
      Future.delayed(const Duration(milliseconds: 500));

      if (response != null) {
        mpesaModel = MpesaModel.empty();
        mpesaModel = MpesaModel.fromJson(response);
        invoiceId = mpesaModel?.data?.invoice?.invoiceId;
        isPaymentComplete = true;
        isLoading = false;
        return true;
      }
    } catch (e) {
      Helpers.debugLog('Something went wrong with mpesa: $e');
      return false;
    }
    return false;
  }

  Future<bool> verifyTransaction([bool includeOrder = false]) async {
    try {
      final response = await ExternalRequestService.makeRequest(
        url: '${AppUtil.paymentUriApi}${AppUtil.mpesa}/$invoiceId/',
        request: 'get',
        headers: {'Authorization': 'NoAuth'},
      );
      if (response == null) return false;
      mpesaModel = MpesaModel.empty();
      mpesaModel = MpesaModel.fromJson(response);
      invoice = mpesaModel?.data?.invoice;
      isVerified = invoice?.mpesaReference != null;
      return true;
    } catch (e) {
      Helpers.debugLog('Something went wrong with verifying mpesa: $e');
    }
    return false;
  }

  Future<bool> transactThroughCard() async {
    return false;
  }

  Future<bool> insertPayment([bool includeOrder = true]) async {
    if (invoice == null) return false;
    BuildContext? context = NavigationService.navigatorKey.currentContext;
    if (context == null) return false;
    final id = const Uuid().v4();
    invoice = invoice!.copyWith(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      id: id,
      orderId:
          includeOrder ? context.read<CartController>().order!.orderId : null,
      shopId: context.read<UserRepository>().shop?.shopId,
      amount: includeOrder
          ? context.read<CartController>().cartTotal
          : double.parse(context.read<KeypadController>().keyPadCode),
    );

    // Map<String, dynamic> type = includeOrder
    //     ? {
    //         'type': DeliveryStatus.pending,
    //       }
    //     : {
    //         'transaction': TransactionType.topup,
    //       };

    try {
      final paymentRef = db.collection(AppDBConstants.paymentCollection);
      await paymentRef.doc(invoice?.id).set(invoice!.toJson());
      //insertTransaction(metadata: type);
      return true;
    } catch (e) {
      Helpers.debugLog('Something went wrong while adding payment: $e');
      return false;
    }
  }

  Transaction? _transaction;
  Transaction? get transaction => _transaction;
  set transaction(Transaction? value) {
    _transaction = value;
    notifyListeners();
  }

  bool _isTopUp = false;
  bool get isTopUp => _isTopUp;
  set isTopUp(bool value) {
    _isTopUp = value;
    notifyListeners();
  }

  Future<bool> insertTransaction({
    Map<String, dynamic>? metadata,
  }) async {
    BuildContext? context = NavigationService.navigatorKey.currentContext;
    if (context == null) return false;
    var amount = invoice?.amount ?? context.read<CartController>().order?.price;
    String? image;
    var description = isTopUp ? 'Top up' : 'Withdraw';
    if (context.read<CartController>().order != null &&
        context.read<CartController>().order!.items != null) {
      image =
          context.read<CartController>().order?.items?.first.orderImages?.first;
      description = context.read<CartController>().order?.orderId ?? '';
    }

    transaction = Transaction.empty();
    Transaction();

    transaction = transaction!.copyWith(
      walletId: context.read<UserRepository>().wallet?.id,
      userId: context.read<UserRepository>().fbUser?.uid,
      shopId: context.read<UserRepository>().shop?.shopId,
      currency: 'KES',
      description: description,
      amount: amount,
      transactionId: invoice?.mpesaReference,
      id: const Uuid().v4(),
      type: invoice?.provider,
      status: invoice?.state,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      metadata: metadata,
      imageUrl: image,
      createdAt: DateTime.now(),
    );

    try {
      final transactionRef =
          db.collection(AppDBConstants.transactionCollection);
      await transactionRef.doc(transaction?.id).set(transaction!.toJson());
      return true;
    } catch (e) {
      Helpers.debugLog('Something went wrong while adding transaction: $e');
      return false;
    }
  }
}
