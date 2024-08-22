import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        CustomColors,
        GlassmorphicContainer,
        NumberFormat,
        ReadContext,
        UserRepository,
        WatchContext;
import 'package:lukhu_pay/src/controller/wallet_controller.dart';

import 'wallet_text.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GlassmorphicContainer(
      height: 160,
      borderRadius: 8,
      blur: 2,
      alignment: Alignment.center,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFffffff).withOpacity(0.2),
            const Color(0xFFFFFFFF).withOpacity(0.05),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFffffff).withOpacity(0.1),
          const Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      width: size.width,
      border: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 22, bottom: 14),
            child: Column(
              children: [
                Text(
                  'Available  Balance',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                WalletText(
                  description: NumberFormat.currency(
                    locale: 'en_US',
                    symbol: 'KES ',
                  ).format(context
                          .watch<UserRepository>()
                          .wallet
                          ?.availableBalance ??
                      0),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                  show: context.watch<WalletController>().showBalance,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            padding: const EdgeInsets.only(
              left: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pending Balance',
                      style: TextStyle(
                        color: Theme.of(context)
                            .extension<CustomColors>()
                            ?.sourceNeutral,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    WalletText(
                      description: NumberFormat.currency(
                        locale: 'en_US',
                        symbol: 'KES ',
                      ).format(context
                              .watch<UserRepository>()
                              .wallet
                              ?.pendingBalance ??
                          0),
                      style: TextStyle(
                        color: Theme.of(context)
                            .extension<CustomColors>()
                            ?.sourceNeutral,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      show: context.watch<WalletController>().showBalance,
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    context.watch<WalletController>().showBalance
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Theme.of(context).extension<CustomColors>()?.neutral,
                  ),
                  onPressed: () {
                    context.read<WalletController>().showBalance =
                        !context.read<WalletController>().showBalance;
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
