import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AppBarType,
        CustomColors,
        DefaultBackButton,
        LuhkuAppBar,
        NavigationService,
        ReadContext;
import 'package:lukhu_pay/util/app_util.dart';

import '../../lukhu_pay.dart';
import '../widgets/transactions/transactions_container.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});
  static const routeName = 'wallet';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var args = ModalRoute.of(context)!.settings.arguments;
    final showButton = args != null;
    return Scaffold(
      appBar: LuhkuAppBar(
        appBarType: AppBarType.other,
        backAction: showButton
            ? DefaultBackButton(
                assetIcon: AppUtil.backButtonIcon,
                packageName: AppUtil.packageName,
              )
            : null,
        color: Theme.of(context).extension<CustomColors>()?.neutral,
        title: Text(
          'Your Wallet',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              /// Navigating to the PaySettingsPage.
              NavigationService.navigate(context, PaySettingsPage.routeName);
            },
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: RefreshIndicator(
          onRefresh: () async {
            context
                .read<TransactionController>()
                .getTransactions(isRefreshMode: true);
          },
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).extension<CustomColors>()?.neutral,
                ),
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                  children: [
                    const BalanceCard(
                      userId: '',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 21),
                      child: Row(
                        children: List.generate(AppUtil.walletOptions.length,
                            (index) {
                          var option = AppUtil.walletOptions[index];
                          return Expanded(
                            child: WalletOption(
                              option: option,
                              onTap: () {
                                NavigationService.navigate(
                                  context,
                                  option['route'],
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
              const TransactionsContainer()
            ],
          ),
        ),
      ),
    );
  }
}
