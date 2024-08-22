import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        DeliveryStatus,
        GlobalAppUtil,
        StyleColors,
        Transaction,
        AccountType,
        TransactionType;

class AppUtil {
  static String packageName = 'lukhu_pay';
  static Duration animationDuration = const Duration(milliseconds: 300);

  //Payment Url
  static String paymentUriApi =
      "https://us-central1-lukhu-dev.cloudfunctions.net/transactions/api/v1";

  static String mpesa = "/collections";
  static String verifyMpesa = '/';

  //Icons
  static String backButtonIcon = 'assets/images/arrow_square_left.png';
  static String copyIcon = 'assets/images/copy.png';
  static String flagIcon = 'assets/images/flag.png';
  static String filterIcon = 'assets/images/receipt_edit.png';
  static String filterSquare = 'assets/images/filter_square.png';
  static String dangerIcon = 'assets/images/danger.png';
  static String iconCircleCheck = 'assets/images/check_circle.png';

  static String walletIcon = 'assets/icons/empty-wallet.png';

  static String mpesaIcon = 'assets/images/mpesa.png';
  static String visaIcon = 'assets/images/visa_logo.png';
  static String masterIcon = 'assets/images/mastercard.png';
  static String callIcon = 'assets/images/call.png';

  static String arrowUp = 'assets/images/arrow_up.png';

  static String trashIcon = 'assets/images/trash.png';

  /// A list of maps for wallet options
  static List<Map<String, dynamic>> walletOptions = [
    {
      'name': 'Top Up',
      'image': 'assets/images/send_square.png',
      'route': 'top_up'
    },
    {
      'name': 'Withdraw',
      'image': 'assets/images/receive_square.png',
      'route': 'withdraw'
    },
    {
      'name': 'Analytics',
      'image': 'assets/images/chart.png',
      'route': 'analytics'
    },
  ];

  static String getPayIcon(AccountType value) {
    switch (value) {
      case AccountType.mpesa:
        return 'assets/images/mpesa.png';
      case AccountType.mastercard:
        return 'assets/images/mastercard.png';
      case AccountType.visa:
        return 'assets/images/visa_logo.png';
      default:
        return 'assets/images/mpesa.png';
    }
  }

  static List<Transaction> transactions = [
    Transaction(
        createdAt: DateTime.now(),
        id: '10',
        currency: 'KSh',
        description: 'Withdraw',
        amount: 1000,
        metadata: {
          'transaction': TransactionType.withdraw,
        },
        newBalance: '10,000'),
    Transaction(
        createdAt: DateTime.now(),
        id: '10',
        currency: 'KSh',
        description: 'Top-Up',
        status: '',
        amount: 3000,
        metadata: {
          'transaction': TransactionType.topup,
        },
        newBalance: '10,000'),
    Transaction(
      createdAt: DateTime.now(),
      id: '10',
      currency: 'KSh',
      description: 'Sold Item',
      amount: 800,
      status: '',
      metadata: {
        'type': DeliveryStatus.pending,
      },
      imageUrl:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZmFzaGlvbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
      newBalance: '10,000',
    ),
    Transaction(
      createdAt: DateTime.now(),
      id: '10',
      currency: 'KSh',
      description: 'Bought Item',
      amount: 800,
      status: '',
      metadata: {
        'type': DeliveryStatus.delivered,
      },
      imageUrl:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZmFzaGlvbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
      newBalance: '10,000',
    ),
  ];

  static List<Color> getTransactionColor(TransactionType? type) {
    var colors = <Color>[];

    switch (type) {
      case TransactionType.topup:
        colors = [StyleColors.shadeColor1, StyleColors.lukhuSuccess200];
        break;
      case TransactionType.withdraw:
        colors = [StyleColors.lukhuError90, StyleColors.lukhuError200];
        break;
      default:
        colors = [StyleColors.shadeColor1, StyleColors.lukhuSuccess200];
    }

    return colors;
  }

  static String transactionIcon(TransactionType? type) {
    switch (type) {
      case TransactionType.topup:
        return 'assets/images/top_up.png';
      case TransactionType.withdraw:
        return 'assets/images/withdraw.png';
      default:
        return 'assets/images/top_up.png';
    }
  }

  static String transactionOperator(TransactionType? type) {
    switch (type) {
      case TransactionType.topup:
        return '+';
      case TransactionType.withdraw:
        return '-';
      case TransactionType.other:
        return '+';
      default:
        return '';
    }
  }

  static TransactionType transactionType(Map<String, dynamic> statusType) {
    var value = statusType['transaction'] ?? "";
    switch (value) {
      case 'topup':
        return TransactionType.topup;
      case 'withdraw':
        return TransactionType.withdraw;

      default:
        return TransactionType.other;
    }
  }

  static DeliveryStatus statusType(Map<String, dynamic> status) {
    var value = status['type'] ?? "";

    switch (value) {
      case 'pending':
        return DeliveryStatus.pending;
      default:
        return DeliveryStatus.none;
    }
  }

  static List<Color> transactionTypeColor(
      Map<String, dynamic> data, Transaction transaction) {
    if (data.isEmpty) {
      return [StyleColors.shadeColor1, StyleColors.lukhuSuccess200];
    }
    return transaction.imageUrl == null
        ? getTransactionColor(transactionType(data))
        : GlobalAppUtil.deliveryTextColor(statusType(data))!;
  }

  static AccountType accountType(Map<String, dynamic> data) =>
      data['type'] == null || data.isEmpty
          ? AccountType.mpesa
          : data['type'] as AccountType;

  static List<Map<String, dynamic>> filterTransactions = [
    {
      'name': 'Top-Ups',
      'value': '',
      'isChecked': false,
    },
    {
      'name': 'Withdrawals',
      'value': '',
      'isChecked': false,
    },
    {
      'name': 'Pending Orders',
      'value': '',
      'isChecked': false,
    },
    {
      'name': 'Shipping Orders',
      'value': '',
      'isChecked': false,
    },
    {
      'name': 'Delivered Orders',
      'value': '',
      'isChecked': false,
    },
    {
      'name': 'Cancelled Orders',
      'value': '',
      'isChecked': false,
    }
  ];

  static List<Color> accountColor(AccountType type) {
    switch (type) {
      case AccountType.mastercard:
        return [
          const Color(0xffFF5F00),
          const Color(0xffFF5F00).withOpacity(.67),
        ];
      case AccountType.visa:
        return [
          StyleColors.lukhuBlue,
          StyleColors.lukhuBlue.withOpacity(.67),
        ];
      default:
        return [
          StyleColors.lukhuBlue,
          StyleColors.lukhuBlue.withOpacity(.67),
        ];
    }
  }

  static List<Map<String, dynamic>> keyPad = [
    {
      'name': '',
      'options': ['1', '2', '3']
    },
    {
      'name': '',
      'options': ['4', '5', '6']
    },
    {
      'name': '',
      'options': ['7', '8', '9']
    },
    {
      'name': '',
      'options': ['', '0', 'Del']
    },
  ];

  static String pickLast4Characters(String string) {
    // Get the length of the string.
    int length = string.length;

    // Check if the string is long enough to have 4 characters.
    if (length < 4) {
      // Return the original string if it is not long enough.
      return string;
    } else {
      // Return the last 4 characters of the string.
      return string.substring(length - 4, length);
    }
  }

  static List<Map<String, dynamic>> billingMethods = [
    {
      'account': 'Mpesa',
      'isChecked': false,
      'image': 'assets/images/mpesa.png',
      'type': AccountType.mpesa,
      'holder': '',
      'expiry': '',
      'card_number': ''
    },
    {
      'account': 'Visa',
      'isChecked': false,
      'image': 'assets/images/visa_logo.png',
      'type': AccountType.visa,
      'holder': '',
      'expiry': '',
      'card_number': ''
    },
    {
      'account': 'Mastercard',
      'isChecked': false,
      'image': 'assets/images/mastercard.png',
      'type': AccountType.mastercard,
      'holder': '',
      'expiry': '',
      'card_number': ''
    },
  ];

  static List<Map<String, dynamic>> summaryList = [
    {
      'name': 'Available Balance',
      'image': 'assets/images/tick_circle.png',
      'description': 'KSh 17,000',
      'color': const Color(0xff2F9803)
    },
    {
      'name': 'Pending Balance',
      'image': 'assets/images/clock.png',
      'description': 'KSh 7,000',
      'color': const Color(0xffF38707)
    },
    {
      'name': 'Withdrawals',
      'image': 'assets/images/receive_square_white.png',
      'description': 'KSh 25,000',
      'color': const Color(0xffC32021)
    },
    {
      'name': 'Top-ups',
      'image': 'assets/images/send_square_white.png',
      'description': 'KSh 5,000',
      'color': const Color(0xff0030CC)
    },
  ];
}
