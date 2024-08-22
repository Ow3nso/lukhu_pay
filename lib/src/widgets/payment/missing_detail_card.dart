import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        DefaultButton,
        DefaultInputField,
        DefaultPrefix,
        ReadContext,
        StyleColors,
        TransactionController,
        WatchContext;
import 'package:lukhu_pay/util/app_util.dart';

class MissingDetailsCard extends StatelessWidget {
  const MissingDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AnimatedPadding(
        duration: AppUtil.animationDuration,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 370,
          padding: const EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
            color: StyleColors.lukhuWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: StyleColors.lukhuDividerColor,
            ),
          ),
          child: Form(
            key: context.watch<TransactionController>().missingDetailsFormKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Text(
                    'Add Missing Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: StyleColors.lukhuDark1,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Text(
                    'Add the missing information below to complete your customer’s order',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: StyleColors.greyWeak1,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                DefaultInputField(
                  controller: context
                      .watch<TransactionController>()
                      .missingNameontroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name cannot be empty.';
                    }
                    return null;
                  },
                  label: 'Name',
                  onChange: (value) {},
                  keyboardType: TextInputType.name,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 16),
                  child: DefaultInputField(
                    label: 'Phone Number',
                    controller: context
                        .watch<TransactionController>()
                        .missingPhoneController,
                    textInputFormatter: [LengthLimitingTextInputFormatter(10)],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone number cannot be empty.';
                      }
                      return null;
                    },
                    onChange: (value) {},
                    keyboardType: TextInputType.phone,
                    prefix: const DefaultPrefix(text: '+254'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DefaultButton(
                    label: 'Submit',
                    color: StyleColors.lukhuBlue,
                    actionDissabledColor: StyleColors.lukhuDisabledButtonColor,
                    onTap: () {
                      context
                          .read<TransactionController>()
                          .updateMissingDetails();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
