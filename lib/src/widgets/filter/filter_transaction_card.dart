import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        CustomColors,
        DefaultButton,
        DefaultCheckbox,
        ReadContext,
        StyleColors,
        WatchContext;
import 'package:lukhu_pay/src/controller/transaction_controller.dart';
import 'package:lukhu_pay/util/app_util.dart';

class FIlterTransactionCard extends StatelessWidget {
  const FIlterTransactionCard({super.key});

  @override
  Widget build(BuildContext context) {
    var filters = context.watch<TransactionController>().filterTransactions;
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 540,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        border: Border.all(color: StyleColors.lukhuDividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: StyleColors.lukhuBlue0,
            radius: 28,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: StyleColors.lukhuBlue10,
              child: Image.asset(
                AppUtil.filterIcon,
                package: AppUtil.packageName,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              'Filter Transactions',
              style: TextStyle(
                color: Theme.of(context).colorScheme.scrim,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a status below to filter your orders',
            style: TextStyle(
              color: StyleColors.lukhuGrey80,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                var option = filters[index];
                return DefaultCheckbox(
                  value: option['isChecked'],
                  onChanged: (value) {
                    context.read<TransactionController>().chooseOption(index);
                  },
                  activeColor: StyleColors.lukhuBlue10,
                  checkedColor: StyleColors.lukhuBlue70,
                  title: Text(option['name'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.scrim,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )),
                );
              },
              itemCount: filters.length,
            ),
          ),
          DefaultButton(
            label: 'View',
            color: Theme.of(context).extension<CustomColors>()?.neutral,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () {
              Navigator.of(context).pop();
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
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
