import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AppBarType,
        BlurDialogBody,
        BottomCard,
        WatchContext,
        DefaultBackButton,
        DefaultMessage,
        LuhkuAppBar,
        ReadContext,
        StyleColors,
        HourGlass;
import 'package:lukhu_pay/src/controller/accounts_controller.dart';

import '../../util/app_util.dart';
import '../widgets/settings/add_card.dart';
import '../widgets/settings/add_number.dart';
import '../widgets/settings/cards_container.dart';
import '../widgets/settings/mobile_container.dart';

class PaySettingsPage extends StatefulWidget {
  const PaySettingsPage({super.key});
  static const routeName = 'pay_settings';

  @override
  State<PaySettingsPage> createState() => _PaySettingsPageState();
}

class _PaySettingsPageState extends State<PaySettingsPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late TabController tabController;
  final pageController = PageController();

  void _setPage(int index) {
    setState(() {
      _selectedIndex = index;

      tabController.animateTo(index);
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: LuhkuAppBar(
          appBarType: AppBarType.other,
          backAction: const DefaultBackButton(),
          bottomHeight: kTextTabBarHeight,
          centerTitle: true,
          title: Text(
            'Settings',
            style: TextStyle(
              color: Theme.of(context).colorScheme.scrim,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          bottom: TabBar(
            controller: tabController,
            onTap: (index) {
              _setPage(index);
              if (context.read<AccountsController>().paymentDetail.isNotEmpty) {
                pageController.jumpToPage(index);
              }
            },
            indicatorColor: Theme.of(context).colorScheme.scrim,
            labelColor: Theme.of(context).colorScheme.scrim,
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            unselectedLabelColor: Theme.of(context).colorScheme.scrim,
            unselectedLabelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            tabs: const [
              Tab(
                text: 'Mobile Money',
              ),
              Tab(
                text: 'Cards',
              ),
            ],
          ),
        ),
        body: SizedBox(
          child: FutureBuilder(
            future: context.read<AccountsController>().getShopPaymentCards(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                if (context.watch<AccountsController>().paymentDetail.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: DefaultMessage(
                      title: 'You don\'t have customer payment details yet',
                      assetImage: AppUtil.walletIcon,
                      packageName: AppUtil.packageName,
                      color: StyleColors.lukhuError10,
                      description:
                          'Add ${_selectedIndex == 0 ? 'Number' : 'Card'} to your store by tapping the button below',
                      label: _selectedIndex == 0 ? 'Add Number' : 'Add Card',
                      onTap: () {
                        context.read<AccountsController>().isAddingPhone =
                            _selectedIndex == 0;
                        if (_selectedIndex == 0) {
                          _showAddNumber();
                        } else {
                          _showAddCard();
                        }
                      },
                    ),
                  );
                }
                return PageView.builder(
                  controller: pageController,
                  itemBuilder: (context, index) => _views[index],
                  itemCount: _views.length,
                  onPageChanged: (index) {
                    _setPage(index);
                  },
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultMessage(
                    title: 'Error',
                    assetImage: AppUtil.walletIcon,
                    packageName: AppUtil.packageName,
                    color: StyleColors.lukhuError10,
                    description: snapshot.error.toString(),
                    label: 'Try again',
                    onTap: () {
                      context.read<AccountsController>().getShopPaymentCards();
                    },
                  ),
                );
              }

              return const Center(
                  child: SizedBox(
                height: 40,
                width: 40,
                child: HourGlass(),
              ));
            },
          ),
        ),
        bottomSheet: MediaQuery.of(context).viewInsets.bottom > 0
            ? null
            : context.watch<AccountsController>().paymentDetail.isNotEmpty
                ? BottomCard(
                    height: 150,
                    label: _selectedIndex == 0 ? 'Add Number' : 'Add Card',
                    onTap: () {
                      context.read<AccountsController>().isAddingPhone =
                          _selectedIndex == 0;
                      if (_selectedIndex == 0) {
                        _showAddNumber();
                      } else {
                        context.read<AccountsController>().updateEdit(
                              shouldErase: true,
                            );
                        _showAddCard();
                      }
                    },
                  )
                : null,
      ),
    );
  }

  void _showAddNumber() {
    showDialog(
      context: context,
      builder: (context) {
        return BlurDialogBody(
          bottomDistance: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: AddNumber(
              label: 'Add Number',
              onTap: (value) {
                Navigator.of(context).pop();
                if (value != null) {}
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddCard() {
    showDialog(
      context: context,
      builder: (context) {
        return BlurDialogBody(
          bottomDistance: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: AddCard(
              label: 'Add Number',
              onTap: (value) {
                Navigator.of(context).pop();
                if (value != null) {}
              },
            ),
          ),
        );
      },
    );
  }

  List<Widget> get _views => [const MobileContainer(), const CardsContainer()];
}
