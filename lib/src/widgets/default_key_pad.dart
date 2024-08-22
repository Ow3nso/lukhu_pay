import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        CustomColors,
        DefaultButton,
        PaymentController,
        StyleColors,
        WatchContext;
import 'package:lukhu_pay/util/app_util.dart';

class DefaultKeyPad extends StatelessWidget {
  const DefaultKeyPad({
    super.key,
    required this.label,
    this.onConfirm,
    this.onTap,
    this.onDelete,
  });
  final String label;
  final void Function()? onConfirm;
  final void Function(String)? onTap;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var keyPads = AppUtil.keyPad;
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.onPrimary),
      width: size.width,
      //height: 380,
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: keyPads.length,
            itemBuilder: (context, index) {
              var options = keyPads[index]['options'] == null
                  ? []
                  : keyPads[index]['options'] as List;

              return Row(
                children: List.generate(options.length, (i) {
                  return Expanded(
                      child: InkWell(
                    onTap: options[i].toString() == ''
                        ? null
                        : () {
                            if (onTap != null) {
                              if (options[i].toString() == 'Del') {
                                onDelete!();
                              } else {
                                onTap!(options[i].toString());
                              }
                            }
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: options[i].toString() == 'Del'
                          ? const Icon(Icons.backspace_outlined)
                          : Text(
                              options[i].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 21,
                                color: Theme.of(context).colorScheme.scrim,
                              ),
                            ),
                    ),
                  ));
                }),
              );
            },
          ),
          DefaultButton(
            onTap: onConfirm,
            loading: context.watch<PaymentController>().isLoading,
            label: label,
            width: size.width - 32,
            height: 40,
            actionDissabledColor: StyleColors.lukhuDisabledButtonColor,
            color: Theme.of(context).extension<CustomColors>()?.neutral,
          ),
          const SizedBox(
            height: 60,
          )
        ],
      ),
    );
  }
}
