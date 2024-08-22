import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart';

class PlanController extends ChangeNotifier {
  List<Map<String, dynamic>> get plans => GlobalAppUtil.plans;

  PlanController() {
    selectedPlan = plans.first;
  }

  /// The function toggles the status of a plan at a given index and notifies listeners.
  ///
  /// Args:
  ///   index (int): The index parameter is an integer that represents the position of the plan in the
  /// plans array that needs to be toggled.
  void togglePlan(int index) {
    for (var plan in plans) {
      plan['status'] = false;
    }

    plans[index]['status'] = true;
    selectedPlan = plans[index];
    notifyListeners();
  }

  Map<String, dynamic> _selectedPlan = {};
  Map<String, dynamic> get selectedPlan => _selectedPlan;
  set selectedPlan(Map<String, dynamic> value) {
    _selectedPlan = value;
    notifyListeners();
  }
}
