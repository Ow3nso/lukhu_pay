import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AccountType,
        BlurDialogBody,
        DefaultInputField,
        DefaultTextBtn,
        ReadContext,
        WatchContext;
import 'package:lukhu_pay/src/controller/accounts_controller.dart';
import 'package:lukhu_pay/util/app_util.dart';

import 'add_card.dart';
import 'credit_card.dart';

class CardsContainer extends StatelessWidget {
  const CardsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: size.width,
      child: ListView(
        children: [
          const SizedBox(height: 16),
          SizedBox(
            width: size.width,
            height: 140,
            child: RefreshIndicator(
              onRefresh: () async {
                context
                    .read<AccountsController>()
                    .getShopPaymentCards(isRefreshMode: true);
              },
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  const SizedBox(width: 16),
                  ...List.generate(
                    context
                        .watch<AccountsController>()
                        .getBankAccountCards(AccountType.card)
                        .keys
                        .length,
                    (index) {
                      var card = context.read<AccountsController>().dataModel(
                            index,
                            context
                                .watch<AccountsController>()
                                .getBankAccountCards(AccountType.card),
                          )!;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: CreditCard(
                          model: card,
                          onTap: () {
                            context
                                .read<AccountsController>()
                                .updateEdit(value: card);
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            padding:
                const EdgeInsets.only(top: 22, left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Card Details',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.scrim,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    )),
                    DefaultTextBtn(
                      label: 'Edit',
                      onTap: () {
                        _showEditCard(context);
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DefaultInputField(
                          onChange: (value) {},
                          hintText: 'Card Name',
                          readOnly: true,
                          keyboardType: TextInputType.name,
                          controller: context
                              .watch<AccountsController>()
                              .cardNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Card name must not be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DefaultInputField(
                          onChange: (value) {},
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Card number must not be empty';
                            }
                            return null;
                          },
                          controller: context
                              .watch<AccountsController>()
                              .cardNumberController,
                          hintText: 'Card Number',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: DefaultInputField(
                                onChange: (value) {},
                                hintText: 'CVV',
                                readOnly: true,
                                controller: context
                                    .watch<AccountsController>()
                                    .cardCvvController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Provide a valid cvv';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: DefaultInputField(
                                onChange: (value) {},
                                hintText: 'Month/Year',
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                controller: context
                                    .watch<AccountsController>()
                                    .cardExpiryController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Provide a valid cvv';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showEditCard(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BlurDialogBody(
          bottomDistance: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: AddCard(
              label: 'Delete Number',
              onTap: (value) {},
              assetIcon: AppUtil.trashIcon,
            ),
          ),
        );
      },
    );
  }
}
