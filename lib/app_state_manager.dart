import 'dart:async';
import 'package:flutter/material.dart';

class FeedsTab {
  static const int allFeeds = 0;
  static const int unread = 1;
  static const int starred = 2;
}

class AppStateManager extends ChangeNotifier {
  bool _initialized = false;
  int _selectedTab = FeedsTab.allFeeds;

  bool get isInitialized => _initialized;
  int get selectedTab => _selectedTab;

  void initializedApp() {
    Timer(const Duration(milliseconds: 2000), () {
      _initialized = true;
      notifyListeners();
    });
  }

  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }

  void goToStarred() {
    _selectedTab = FeedsTab.starred;
    notifyListeners();
  }
}

final AppStateManager appStateManager = AppStateManager();
