import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        DeliveryStatus,
        InvoiceModel,
        MpesaModel,
        NavigationService,
        PaymentOrderView,
        ShortMessageType,
        ShortMessages,
        StringExtension;
import 'package:lukhu_pay/src/commands/base_command.dart';

class PaymentCommand extends BaseCommand with CancellableCommandMixin {
  PaymentCommand(super.c);

  @override
  Future<void> execute([
    bool repeat = false,
    int wait = 10,
  ]) async {
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

      cartController.addOrder();
      transactionController.missingPhoneController.text =
          cartController.order?.phoneNumber ?? '';
      cartController.showMissingDialog().then((value) {
        cartController.getOrderImage(cartController.order);
        if (value) {
          NavigationService.navigateGlobally(route: PaymentOrderView.routeName);
        }
      });
    }
  }

  Future<void> insert() async {
    cartController.order = cartController.order!.copyWith(
      name: transactionController.missingNameontroller.text.trim(),
      phoneNumber: transactionController.missingPhoneController.text
          .trim()
          .toLukhuNumber(),
    );

    paymentController.insertPayment(true).then((value) {
      cartController.insertOrder();
      if (!value) {
        accountController.isError = true;
        ShortMessages.showShortMessage(
          message: 'Something happened. Please try again',
          type: ShortMessageType.info,
        );
      }
    });

    paymentController.insertTransaction(metadata: {
      'type': DeliveryStatus.pending.name,
    }).then((value) {
      userRepository.getUserWallet();
      if (!value) {
        ShortMessages.showShortMessage(
          message: 'Something happened. Please try again',
          type: ShortMessageType.info,
        );
      }
    });
  }

  @override
  Future<bool> clear() async {
    accountController.isError = false;
    accountController.isSuccess = false;
    paymentController.isPaymentComplete = false;
    paymentController.isVerified = false;
    cartController.clearCart();
    accountController.reset();
    transactionController.init();
    accountController.updateEdit(shouldErase: true);
    paymentController.invoice = InvoiceModel.empty();
    paymentController.mpesaModel = MpesaModel.empty();

    accountController.selectedMethod = {};
    return true;
  }
}
