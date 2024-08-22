import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AccountType,
        AppDBConstants,
        FirebaseFirestore,
        Helpers,
        NavigationService,
        PaymentFields,
        PaymentModel,
        ReadContext,
        ShortMessages,
        StringExtension,
        TransactionType,
        UserRepository,
        Uuid;
// WatchContext;
import 'package:lukhu_pay/util/app_util.dart';

class AccountsController extends ChangeNotifier {
  // List<Map<String, dynamic>> mpesaAccounts = [];
  final db = FirebaseFirestore.instance;

  AccountsController() {
    getShopPaymentCards();
  }

  //Add Card controller
  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardCvvController = TextEditingController();
  TextEditingController cardExpiryController = TextEditingController();

  GlobalKey<FormState> cardFormKey = GlobalKey();

  bool _useCardAsDefault = false;
  bool get useCardAsDefault => _useCardAsDefault;

  set useCardAsDefault(bool value) {
    _useCardAsDefault = value;

    notifyListeners();
  }

  AccountType? _cardType;
  AccountType? get cardType => _cardType;
  set cardType(AccountType? value) {
    _cardType = value;
    notifyListeners();
  }

  //Add Phone controller
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> phoneFormKey = GlobalKey();

  bool _usePhoneAsDefault = false;
  bool get usePhoneAsDefault => _usePhoneAsDefault;

  set usePhoneAsDefault(bool value) {
    _usePhoneAsDefault = value;
    if (selectedAccount != null) {}
    notifyListeners();
  }

  PaymentModel? _paymentModel;
  PaymentModel? get paymentModel => _paymentModel;
  set paymentModel(PaymentModel? value) {
    _paymentModel = value;
    notifyListeners();
  }

  Map<String, PaymentModel> _paymentDetail = {};
  Map<String, PaymentModel> get paymentDetail => _paymentDetail;
  set paymentDetail(Map<String, PaymentModel> value) {
    _paymentDetail = value;
    notifyListeners();
  }

  Map<String, Map<String, PaymentModel>> storePaymentDetails = {};

  void updateEdit({PaymentModel? value, bool shouldErase = false}) {
    if (shouldErase) {
      cardNameController = TextEditingController();
      cardNumberController = TextEditingController();
      cardExpiryController = TextEditingController();
      notifyListeners();
      return;
    }
    if (value?.type != AccountType.mpesa) {
      cardNameController.text = value?.name ?? "";
      cardNumberController.text = value?.account ?? "";
      cardExpiryController.text = value?.expiryDate ?? "";
    }

    notifyListeners();
  }

  bool _isUploading = false;
  bool get isUploading => _isUploading;
  set isUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }

  bool _isAddingPhone = false;
  bool get isAddingPhone => _isAddingPhone;
  set isAddingPhone(bool value) {
    _isAddingPhone = value;
    notifyListeners();
  }

  Future<bool> submitPaymentModel({
    String? shopId,
    String? userId,
  }) async {
    isUploading = true;
    bool exists = await checkIfPayModelExists(
      account: isAddingPhone
          ? phoneController.text.toLukhuNumber()
          : cardNumberController.text,
    );
    if (exists) {
      isUploading = false;
      ShortMessages.showShortMessage(
        message:
            "${!isAddingPhone ? 'Card Number' : 'Phone Number'} already exists.",
      );
      return false;
    }
    final id = const Uuid().v4();
    paymentModel = PaymentModel.empty();
    paymentModel = paymentModel!.copyWith(
      name: isAddingPhone ? "" : cardNameController.text,
      id: id,
      userId: userId,
      shopId: shopId,
      type: isAddingPhone ? AccountType.mpesa : cardType,
      cvv: "",
      expiryDate: isAddingPhone ? "" : cardExpiryController.text.trim(),
      account: isAddingPhone
          ? phoneController.text.toLukhuNumber().trim()
          : cardNumberController.text.trim(),
    );

    final modelData = paymentModel!.toJson();
    if (!isPaymentModelValid(data: modelData)) {
      isUploading = false;
      ShortMessages.showShortMessage(
        message: "Please enter valid payment details",
      );
      return false;
    }
    paymentModel = PaymentModel.fromJson(modelData);
    return saveDetail();
  }

  Future<bool> saveDetail() async {
    try {
      final paymentModelRef = db
          .collection(AppDBConstants.paymentDetailCollection)
          .doc(paymentModel!.id);

      await paymentModelRef.set(paymentModel!.toJson());
      isUploading = false;
      ShortMessages.showShortMessage(message: "Added successfully!");
      getShopPaymentCards(isRefreshMode: true);
      return true;
    } catch (e) {
      ShortMessages.showShortMessage(
        message:
            'An error occured while adding your customer\'s payment detail, please try again.',
      );
      isUploading = false;
    }
    isUploading = false;
    return false;
  }

  /// The function `getPhoneAccounts` returns a map of phone accounts filtered by the specified account
  /// type.
  ///
  /// Args:
  ///   value (AccountType): The parameter "value" is of type AccountType. It is used to filter the
  /// paymentDetail values based on the account type.
  ///
  /// Returns:
  ///   The method is returning a map of type `Map<String, PaymentModel>`.
  Map<String, PaymentModel> getPhoneAccounts() {
    var cardCollection = <String, PaymentModel>{};

    cardCollection = {
      for (var e in paymentDetail.values.toList())
        if (e.type == AccountType.mpesa) e.id!: e
    };

    return cardCollection;
  }

  Map<String, PaymentModel> _selectedMethod = {};
  Map<String, PaymentModel> get selectedMethod => _selectedMethod;
  set selectedMethod(Map<String, PaymentModel> value) {
    _selectedMethod = value;
    notifyListeners();
  }

  bool isPaymodelSelected(String value) => selectedMethod.keys.contains(value);

  Future<void> toggleSelectedMethod(String value) async {
    selectedMethod = {};
    if (paymentDetail[value] != null) {
      selectedMethod[value] = paymentDetail[value]!;
    }
    notifyListeners();
  }

  Map<String, PaymentModel> getUserAccountsByType(AccountType value) {
    var cardCollection = <String, PaymentModel>{};
    cardCollection = {
      for (var e in paymentDetail.values.toList())
        if (e.type == value) e.id!: e
    };

    return cardCollection;
  }

  /// The function `getBankAccountCards` returns a map of payment cards associated with a specific
  /// account type, excluding any cards associated with the "mpesa" account type.
  ///
  /// Args:
  ///   value (AccountType): The parameter "value" is of type "AccountType".
  ///
  /// Returns:
  ///   The method `getBankAccountCards` returns a `Map<String, PaymentModel>`.
  Map<String, PaymentModel> getBankAccountCards(AccountType value) {
    var cardCollection = <String, PaymentModel>{};

    cardCollection = {
      for (var e in paymentDetail.values.toList())
        if (e.type != AccountType.mpesa) e.id!: e
    };

    return cardCollection;
  }

  /// The function `dataModel` returns a `PaymentModel` object from a given index and a map of
  /// `PaymentModel` objects.
  ///
  /// Args:
  ///   index (int): The index parameter is an integer value that represents the position or index of the
  /// desired payment model in the map.
  ///   value (Map<String, PaymentModel>): The value parameter is a Map object that contains PaymentModel
  /// objects.
  ///
  /// Returns:
  ///   The method is returning a PaymentModel object.
  PaymentModel? dataModel(int index, Map<String, PaymentModel> value) {
    return value[_dataKey(index, value)];
  }

  /// The function `_dataKey` returns the key at a specific index in a given map.
  ///
  /// Args:
  ///   index (int): The index parameter is an integer representing the position of the key in the map.
  ///   value (Map<String, PaymentModel>): A Map object with String keys and PaymentModel values.
  ///
  /// Returns:
  ///   The method is returning a string value.
  String _dataKey(int index, Map<String, PaymentModel> value) {
    return value.keys.elementAt(index);
  }

  /// The function checks if a payment model exists for a given account in a database collection.
  ///
  /// Args:
  ///   account (String): The `account` parameter is a required string that represents the account for
  /// which we want to check if a pay model exists.
  ///
  /// Returns:
  ///   a `Future<bool>`.
  Future<bool> checkIfPayModelExists({required String account}) async {
    try {
      final paymodelRef = await db
          .collection(AppDBConstants.paymentDetailCollection)
          .where(PaymentFields.account, isEqualTo: account)
          .get();
      if (paymodelRef.docs.isNotEmpty) {
        return true;
      }
    } catch (e) {
      ShortMessages.showShortMessage(
          message: "Something happened. Please try again");
      isUploading = false;
    }
    return false;
  }

  /// The function checks if all required fields in a payment model are present and not empty.
  ///
  /// Args:
  ///   data (Map<String, dynamic>): A map containing key-value pairs where the keys represent field
  /// names and the values represent the corresponding field values.
  ///
  /// Returns:
  ///   a boolean value. It returns true if all the required fields in the "data" map are not null or
  /// empty, and false otherwise.
  bool isPaymentModelValid({required Map<String, dynamic> data}) {
    for (final field in requiredAccountFields) {
      if (data[field] == null || data[field] == '') {
        return false;
      }
    }
    return true;
  }

  /// The function `deletePaymentModel` checks if a payment model exists and if it does, it does
  /// nothing, otherwise it logs an error message and returns false.
  ///
  /// Returns:
  ///   a Future<bool> with the value of false.
  Future<bool> deletePaymentModel() async {
    bool exists =
        await checkIfPayModelExists(account: cardNumberController.text);

    try {
      if (exists) {}
    } catch (e) {
      Helpers.debugLog('Error occurred while deleting document: $e');
      ShortMessages.showShortMessage(
        message: "Something happened to the document. Please try again.",
      );
    }
    return false;
  }

  final List<String> requiredAccountFields = [
    PaymentFields.account,
    PaymentFields.shopId,
    PaymentFields.userId,
  ];

  Future<bool> getShopPaymentCards({
    bool isRefreshMode = false,
  }) async {
    BuildContext? context = NavigationService.navigatorKey.currentContext;
    if (context == null) return false;

    var shopId = context.read<UserRepository>().shop?.shopId;

    if (storePaymentDetails[shopId] != null && !isRefreshMode) return true;
    try {
      var paymentDetailDocs = await db
          .collection(AppDBConstants.paymentDetailCollection)
          .where(PaymentFields.shopId, isEqualTo: shopId)
          .orderBy(PaymentFields.createdAt, descending: true)
          .limit(10)
          .get();

      if (paymentDetailDocs.docs.isNotEmpty) {
        paymentDetail = {
          for (var doc in paymentDetailDocs.docs)
            doc.id: PaymentModel.fromJson(doc.data())
        };
        storePaymentDetails[shopId!] = paymentDetail;

        return true;
      }
    } catch (e) {
      Helpers.debugLog('An error occurred while fetching payment details: $e');
    }
    return false;
  }

  void chooseDefaultPhone(
    bool value,
  ) {}

  int? _selectedAccount;
  int? get selectedAccount => _selectedAccount;
  set selectedAccount(int? value) {
    _selectedAccount = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> billingMethods = AppUtil.billingMethods;

  List<Map<String, dynamic>> withdrawBillingMethods([TransactionType? value]) {
    var methods = billingMethods;
    if (value != null) {
      methods = billingMethods
          .where(
              (element) => element['type'] as AccountType == AccountType.mpesa)
          .toList();

      methods[0]['isCHecked'] = true;
    }
    return methods;
  }

  void pickbilling(
    int index,
  ) {
    reset();
    billingMethods[index]['isChecked'] = !billingMethods[index]['isChecked'];

    notifyListeners();
  }

  List<Map<String, dynamic>> checkedBillingMethods = [];

  void reset() {
    isSuccess = false;
    isError = false;
    for (var billing in billingMethods) {
      billing['isChecked'] = false;
    }
    checkedBillingMethods = [];
    selectedPayMethod = {};
    selectedMethod = {};
    notifyListeners();
  }

  int _count = 0;
  int get count => _count;
  set count(int value) {
    _count = value;
    notifyListeners();
  }

  /// It returns a Timer object that calls the function func every duration milliseconds.
  ///
  /// Args:
  ///   duration (Duration): The duration of the timer.
  ///   func: The function to be called when the timer expires.
  Timer interval(Duration duration, Function(Timer) func) {
    Timer function() {
      Timer timer = Timer(duration, function);
      func(timer);
      return timer;
    }

    return Timer(duration, function);
  }

  /// It starts a timer that runs for 4 seconds, and then calls a callback function
  ///
  /// Args:
  ///   callback (void Function()): The function to be called after the timer is complete.
  void startTimer(void Function() callback) async {
    showGlow = true;
    var i = 0;
    interval(const Duration(milliseconds: 1000), (time) {
      i++;
      if (kDebugMode) {
        print('[TIME]====$i');
      }
      if (i == 4) {
        time.cancel();
        showGlow = false;
        isSuccess = true;
        // isError = true;
        callback();
      }
    });
  }

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;
  set isSuccess(bool value) {
    _isSuccess = value;
    notifyListeners();
  }

  bool _isError = false;
  bool get isError => _isError;
  set isError(bool value) {
    _isError = value;
    notifyListeners();
  }

  bool _showGlow = false;
  bool get showGlow => _showGlow;
  set showGlow(bool value) {
    _showGlow = value;
    notifyListeners();
  }

  bool get isPaymentSelected => selectedPayMethod.isNotEmpty;

  Map<String, dynamic> selectedPayMethod = {};

  void setPaymentMethod() {}
}
