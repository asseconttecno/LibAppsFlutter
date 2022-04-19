import 'package:flutter/material.dart';

class PageManager extends ChangeNotifier {
  final PageController _pageController;
  int page = 0;
  PageManager(this._pageController);

  void setPage(int value){
    if(value == page){
      return;
    }
    page = value;
    _pageController.jumpToPage(value);
    notifyListeners();
  }
}