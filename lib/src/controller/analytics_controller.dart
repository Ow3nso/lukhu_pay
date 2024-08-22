import 'package:flutter/material.dart';
import 'package:lukhu_pay/util/app_util.dart';

class AnalyticsController extends ChangeNotifier {
  List<String> durations = [
    'Today',
    'Yesterday',
    'This Week',
    'Last 7 Days',
    'Last 30 Days',
    'Last 6 Months',
    'Last 1 Year',
    'Custom Date Range'
  ];

  String _selectedDuration = 'This Week';
  String get selectedDuration => _selectedDuration;

  set selectedDuration(String value) {
    _selectedDuration = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> summaryList = AppUtil.summaryList;
}
