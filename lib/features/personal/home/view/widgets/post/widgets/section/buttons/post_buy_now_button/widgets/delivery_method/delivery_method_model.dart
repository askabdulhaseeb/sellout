import 'package:flutter/foundation.dart';

class DeliveryMethodModel extends ChangeNotifier {
  int _selected = 0;
  int get selected => _selected;
  set selected(int v) {
    if (_selected != v) {
      _selected = v;
      notifyListeners();
    }
  }
}
