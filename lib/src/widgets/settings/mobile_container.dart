import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show BlurDialogBody, GlobalAppUtil, ReadContext, WatchContext, AccountType;
import 'package:lukhu_pay/src/controller/accounts_controller.dart';

import '../../../util/app_util.dart';
import 'account_card.dart';
import 'add_number.dart';

class MobileContainer extends StatelessWidget {
  const MobileContainer({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: RefreshIndicator(
          onRefresh: () async {
            context
                .read<AccountsController>()
                .getShopPaymentCards(isRefreshMode: true);
          },
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemBuilder: (context, index) {
              var account = context.read<AccountsController>().dataModel(index,
                  context.watch<AccountsController>().getPhoneAccounts())!;
              return AccountTile(
                model: account,
                image: AppUtil.getPayIcon(account.type ?? AccountType.mpesa),
                packageName: GlobalAppUtil.productListingPackageName,
                data: account.toJson(),
                onTap: () {
                  context.read<AccountsController>().selectedAccount = index;
                  _showAddNumber(
                    context,
                  );
                },
              );
            },
            itemCount: context
                .watch<AccountsController>()
                .getPhoneAccounts()
                .keys
                .length,
          ),
        ),
      ),
    );
  }

  void _showAddNumber(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BlurDialogBody(
          bottomDistance: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: AddNumber(
              label: 'Delete Number',
              assetIcon: AppUtil.trashIcon,
              onTap: (value) {},
            ),
          ),
        );
      },
    );
  }
}
