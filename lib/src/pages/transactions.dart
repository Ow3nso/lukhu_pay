import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AppBarType,
        BlurDialogBody,
        DefaultBackButton,
        DefaultMessage,
        HourGlass,
        LuhkuAppBar,
        ReadContext,
        StyleColors,
        Transaction,
        WatchContext;
import 'package:lukhu_pay/src/controller/transaction_controller.dart';

import '../widgets/filter/filter_button.dart';
import '../widgets/filter/filter_transaction_card.dart';
import '../widgets/transactions/transaction_card.dart';
import '../widgets/transactions/transaction_detail.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});
  static const routeName = 'transactions';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: LuhkuAppBar(
        appBarType: AppBarType.other,
        backAction: const DefaultBackButton(),
        title: Text(
          'Transactions',
          style: TextStyle(
            color: Theme.of(context).colorScheme.scrim,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilterButton(
              onTap: () {
                _showFilterTransactions(context);
              },
            ),
          )
        ],
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
              future: context.read<TransactionController>().getTransactions(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (context
                      .watch<TransactionController>()
                      .shopTransaction
                      .keys
                      .isEmpty) {
                    return DefaultMessage(
                      title: 'You don\'t have a transactions at the moment',
                      description: '${snapshot.error ?? ''}',
                      label: 'Refresh',
                      onTap: () {
                        context.read<TransactionController>().getTransactions();
                      },
                    );
                  }
                  return ListView(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: context
                            .watch<TransactionController>()
                            .shopTransaction
                            .keys
                            .length,
                        itemBuilder: (context, index) {
                          var valueTransaction = transaction(
                              index,
                              context
                                  .watch<TransactionController>()
                                  .shopTransaction);
                          return TransactionCard(
                            show: false,
                            transaction: valueTransaction!,
                            onTap: () {
                              _showTransactionDetail(context, valueTransaction);
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            Divider(color: StyleColors.lukhuGrey10),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return DefaultMessage(
                    title:
                        'An error occurred. Please tap the button to fetch transactions',
                    description: '${snapshot.error ?? ''}',
                    label: 'Refresh',
                    onTap: () {
                      context.read<TransactionController>().getTransactions();
                    },
                  );
                }

                return const Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: HourGlass(),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Transaction? transaction(int index, Map<String, Transaction> value) {
    return value[_transactionKey(index, value)];
  }

  String _transactionKey(int index, Map<String, Transaction> value) {
    return value.keys.elementAt(index);
  }

  void _showFilterTransactions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const BlurDialogBody(
        bottomDistance: 80,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: FIlterTransactionCard(),
        ),
      ),
    );
  }

  void _showTransactionDetail(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (ctx) => BlurDialogBody(
        child: TransactionDetail(
          transactions: transaction,
        ),
      ),
    );
  }
}
