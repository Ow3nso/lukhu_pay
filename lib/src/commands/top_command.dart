import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        Helpers,
        InvoiceModel,
        MpesaModel,
        ShortMessageType,
        ShortMessages,
        TransactionType;
import 'package:lukhu_pay/src/commands/base_command.dart';

class TopUpCommand extends BaseCommand with CancellableCommandMixin {
  TopUpCommand(super.c);

  @override
  Future<void> execute([
    bool repeat = false,
    int wait = 10,
  ]) async {
    // paymentController.
    paymentController.verifyTransaction();
    insertPayment();
    if (repeat) {
      Future.delayed(Duration(seconds: wait)).then((value) {
        if (isCancelled) return;
        execute(true);
      });
    }
  }

  void insertPayment() {
    if (paymentController.isVerified) {
      cancel();
      accountController.isSuccess = true;
      accountController.isError = false;

      paymentController.insertPayment(false).then((value) {
        if (!value) {
          accountController.isError = true;
          ShortMessages.showShortMessage(
            message: 'Something happened. Please try again',
            type: ShortMessageType.info,
          );
        }
      });

      paymentController.insertTransaction(metadata: {
        'transaction': TransactionType.topup.name,
      }).then((value) {
        Helpers.debugLog('[INSERT TRANSACTION]: $value');
        userRepository.getUserWallet();
        transactionController.getTransactions(isRefreshMode: true);
        if (!value) {
          ShortMessages.showShortMessage(
            message: 'Something happened. Please try again',
            type: ShortMessageType.info,
          );
        }
      });
    }
  }

  @override
  Future<bool> clear() async {
    accountController.isError = false;
    accountController.isSuccess = false;
    paymentController.isPaymentComplete = false;
    paymentController.isVerified = false;
    keyPadController.keyPadCode = '0';
    paymentController.invoice = InvoiceModel.empty();
    paymentController.mpesaModel = MpesaModel.empty();
    paymentController.isTopUp = false;

    accountController.selectedMethod = {};

    return true;
  }
}
