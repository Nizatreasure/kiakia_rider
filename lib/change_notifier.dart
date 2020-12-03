import 'package:flutter/material.dart';

class AllChangeNotifiers extends ChangeNotifier {
  bool showProfilePicChangeLoader = false;
  void updateShowProfilePicChangeLoader(bool showProfilePicChangeLoader) {
    this.showProfilePicChangeLoader = showProfilePicChangeLoader;
    notifyListeners();
  }
}
