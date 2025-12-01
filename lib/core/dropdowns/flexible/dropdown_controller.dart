import 'package:flutter/material.dart';

class DropdownController<T> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  T? selected;
  String search = '';
  bool loading = false;
  List<T> items = <T>[];

  void dispose() {
    searchController.dispose();
    focusNode.dispose();
  }
}
