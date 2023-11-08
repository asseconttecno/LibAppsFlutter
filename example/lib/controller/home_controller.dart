import 'package:flutter/cupertino.dart';

class HomeController extends ChangeNotifier {
  static PageController pageController = PageController();
  int page = 0;
  int? filtro;

  void setPage(int value) {
    page = value;
    pageController.jumpToPage(value);
    notifyListeners();
  }
}
