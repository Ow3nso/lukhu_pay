import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        CardUtil,
        CustomColors,
        DefaultBackButton,
        DefaultButton,
        DefaultInputField,
        DefaultSwitch,
        GlobalAppUtil,
        ReadContext,
        ShortMessages,
        StyleColors,
        UserRepository,
        WatchContext;
import 'package:lukhu_pay/src/controller/accounts_controller.dart';

import '../../../util/app_util.dart';
import '../../../util/text_formatter.dart';

class AddCard extends StatelessWidget {
  const AddCard({super.key, this.onTap, required this.label, this.assetIcon});
  final void Function(Object?)? onTap;
  final String label;
  final String? assetIcon;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var controller = context.watch<AccountsController>();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AnimatedPadding(
        duration: AppUtil.animationDuration,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: size.width,
          height: 595,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            border: Border.all(color: StyleColors.lukhuDividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.only(top: 20, left: 16),
          child: Form(
            key: controller.cardFormKey,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4, bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        'Add Card',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.scrim,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      DefaultBackButton(
                        assetIcon: GlobalAppUtil.closeIcon,
                        packageName: GlobalAppUtil.productListingPackageName,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    'Enter your card details below',
                    style: TextStyle(
                        color: StyleColors.lukhuGrey80,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: DefaultInputField(
                    onChange: (p0) {},
                    label: 'Name on card',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    controller: controller.cardNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: DefaultInputField(
                    onChange: (value) {
                      if (value!.isNotEmpty) {
                        controller.cardType =
                            CardUtil.getCardTypeFromNumber(value);
                      }
                    },
                    label: 'Card number',
                    validator: CardUtil.validateCardNum,
                    prefix: CardUtil.getCardIcon(controller.cardType),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      CardNumberInputFormatter(),
                      LengthLimitingTextInputFormatter(19)
                    ],
                    controller: context
                        .watch<AccountsController>()
                        .cardNumberController,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: DefaultInputField(
                            label: 'CVV',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onChange: (value) {},
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            controller: context
                                .watch<AccountsController>()
                                .cardCvvController,
                            validator: CardUtil.validateCVV,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: DefaultInputField(
                            onChange: (value) {},
                            label: 'Expiry',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              CardMonthInputFormatter()
                            ],
                            controller: context
                                .watch<AccountsController>()
                                .cardExpiryController,
                            validator: CardUtil.validateDate,
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 32),
                  child: DefaultSwitch(
                    onChanged: (value) {
                      context.read<AccountsController>().useCardAsDefault =
                          value ?? false;
                    },
                    activeColor: StyleColors.lukhuBlue,
                    checkedColor: StyleColors.lukhuBlue0,
                    value: context.watch<AccountsController>().useCardAsDefault,
                    title: Text(
                      'Use card as default',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.scrim,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: DefaultButton(
                    label: label,
                    color: assetIcon != null
                        ? StyleColors.lukhuError
                        : Theme.of(context).extension<CustomColors>()?.neutral,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    asssetIcon: assetIcon,
                    packageName: AppUtil.packageName,
                    loading: context.watch<AccountsController>().isUploading,
                    onTap: () {
                      _addCard(context);
                    },
                    width: size.width - 32,
                    height: 40,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: DefaultButton(
                    label: 'Cancel',
                    color: Theme.of(context).colorScheme.onPrimary,
                    textColor: Theme.of(context).colorScheme.scrim,
                    boarderColor: StyleColors.lukhuDividerColor,
                    onTap: context.watch<AccountsController>().isUploading
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    width: size.width - 32,
                    height: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addCard(BuildContext context) async {
    var controller = context.read<AccountsController>();
    final userRepo = context.read<UserRepository>();
    if (controller.cardFormKey.currentState!.validate()) {
      // Map<String, dynamic> data = {
      //   'account': controller.cardNumberController.text,
      //   'isChecked': true,
      //   'image': '',
      //   'type': AccountType.card,
      //   'holder': controller.cardNameController.text,
      //   'expiry': controller.cardExpiryController.text,
      //   'card_number': controller.cardNumberController.text,
      // };

      try {
        controller
            .submitPaymentModel(
          shopId: userRepo.shop?.shopId,
          userId: userRepo.fbUser?.uid,
        )
            .then((value) {
          if (value) {
            if (onTap != null) {
              controller.cardNameController.clear();
              controller.cardExpiryController.clear();
              controller.cardCvvController.clear();
              controller.cardNumberController.clear();
              controller.cardFormKey = GlobalKey();
              onTap!(controller.paymentModel);
            }
          } else {
            Navigator.of(context).pop();
          }
        });
      } catch (e) {
        ShortMessages.showShortMessage(message: "Something happened!");
      }
    }
  }
}
