import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        CustomColors,
        DefaultButton,
        DefaultInputField,
        DefaultSwitch,
        Helpers,
        ReadContext,
        ShortMessages,
        StyleColors,
        UserRepository,
        WatchContext;
import 'package:lukhu_pay/src/controller/accounts_controller.dart';

import '../../../util/app_util.dart';

class AddNumber extends StatelessWidget {
  const AddNumber({
    super.key,
    required this.label,
    this.onTap,
    this.assetIcon,
  });
  final void Function(Object?)? onTap;
  final String label;
  final String? assetIcon;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var controller = context.watch<AccountsController>();
    return AnimatedPadding(
      duration: AppUtil.animationDuration,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        width: size.width,
        height: 366,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          border: Border.all(color: StyleColors.lukhuDividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Form(
          key: controller.phoneFormKey,
          child: Column(
            children: [
              Text(
                'Add mobile money number',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.scrim,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              DefaultInputField(
                onChange: (value) {},
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                label: 'Phone Number',
                hintText: '0712 345 678',
                controller: context.watch<AccountsController>().phoneController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Phone cannot be empty';
                  }

                  if (value.length != 10) {
                    return "Phone must be at least 10 characters.";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 32),
                child: DefaultSwitch(
                  onChanged: (value) {
                    context.read<AccountsController>().usePhoneAsDefault =
                        value ?? false;
                  },
                  activeColor: StyleColors.lukhuBlue,
                  checkedColor: StyleColors.lukhuBlue0,
                  value: context.watch<AccountsController>().usePhoneAsDefault,
                  title: Text(
                    'Use number as default',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.scrim,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              DefaultButton(
                label: label,
                loading: context.watch<AccountsController>().isUploading,
                color: assetIcon != null
                    ? StyleColors.lukhuError
                    : Theme.of(context).extension<CustomColors>()?.neutral,
                textColor: Theme.of(context).colorScheme.onPrimary,
                asssetIcon: assetIcon,
                packageName: AppUtil.packageName,
                onTap: () {
                  _addPhone(context);
                },
                width: size.width - 32,
                height: 40,
              ),
              const SizedBox(height: 12),
              DefaultButton(
                label: 'Cancel',
                color: Theme.of(context).colorScheme.onPrimary,
                textColor: Theme.of(context).colorScheme.scrim,
                boarderColor: StyleColors.lukhuDividerColor,
                onTap: () {
                  Navigator.of(context).pop();
                },
                width: size.width - 32,
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addPhone(BuildContext context) async {
    var controller = context.read<AccountsController>();
    final userRepo = context.read<UserRepository>();
    if (controller.phoneFormKey.currentState!.validate()) {
      try {
        controller
            .submitPaymentModel(
          shopId: userRepo.shop?.shopId,
          userId: userRepo.fbUser?.uid,
        )
            .then((value) {
          if (value) {
            if (onTap != null) {
              controller.phoneController.clear();
              controller.phoneFormKey = GlobalKey();
              onTap!(controller.paymentModel);
            }
          } else {
            Navigator.of(context).pop();
          }
        });
      } catch (e) {
        Helpers.debugLog('An error occurred while adding phone: $e');
        ShortMessages.showShortMessage(
            message: "An error occurred while adding phone");
      }
    }
  }
}
