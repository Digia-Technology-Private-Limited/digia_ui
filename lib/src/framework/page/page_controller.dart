import 'package:flutter/material.dart';

class DUIPageController extends ChangeNotifier {
  DUIPageController();

  void rebuild() {
    notifyListeners();
  }
}
