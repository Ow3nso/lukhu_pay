import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show CircularCheckbox, StyleColors;

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
    this.show = true,
  });
  final bool isSelected;
  final Map<String, dynamic> item;
  final void Function()? onTap;
  final bool show;

  @override
  Widget build(BuildContext context) {
    var price = item['price'] == 0 ? "Free" : "KSh ${item['price']} Monthly";
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: isSelected ? StyleColors.lukhuBlue0 : StyleColors.lukhuWhite,
            border: Border.all(
              color: StyleColors.lukhuDividerColor,
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Image.asset(
              item['image'],
              package: item['package'],
              height: 48,
              width: 48,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['title'],
                          style: TextStyle(
                            color: StyleColors.lukhuDark1,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (show)
                        CircularCheckbox(
                          onTap: () {},
                          isChecked: isSelected,
                        )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 9, bottom: 8),
                    child: Text(
                      item['description'],
                      style: TextStyle(
                        color: StyleColors.lukhuDark1,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    price,
                    style: TextStyle(
                      color: StyleColors.lukhuBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
