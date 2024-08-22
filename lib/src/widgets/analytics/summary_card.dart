import 'package:flutter/material.dart';
import 'package:lukhu_pay/util/app_util.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: data['color'], borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(
        left: 12,
        top: 14,
        right: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                data['name'],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              )),
              Image.asset(
                data['image'],
                package: AppUtil.packageName,
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  data['description'],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
