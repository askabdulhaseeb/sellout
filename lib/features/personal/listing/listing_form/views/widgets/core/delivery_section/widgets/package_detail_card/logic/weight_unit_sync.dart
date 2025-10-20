import 'package:flutter/material.dart';

class WeightUnitSync {
  WeightUnitSync({
    required this.storageController,
    bool initialIsKg = true,
  }) : isKg = initialIsKg;

  final TextEditingController storageController; // stores KG only
  late final TextEditingController displayController;
  bool isKg;
  bool _syncing = false;

  void init() {
    displayController = TextEditingController(text: storageController.text);
    displayController.addListener(_onDisplayChanged);
    storageController.addListener(_onStorageChanged);
    _syncFromStorage();
  }

  void dispose() {
    displayController.removeListener(_onDisplayChanged);
    storageController.removeListener(_onStorageChanged);
    displayController.dispose();
  }

  void toggleUnit(bool toKg) {
    if (isKg == toKg) return;
    isKg = toKg;
    _syncFromStorage();
  }

  void _onStorageChanged() => _syncFromStorage();

  void _onDisplayChanged() {
    if (_syncing) return;
    _syncing = true;
    final String raw = displayController.text.trim();
    if (raw.isEmpty) {
      storageController.text = '';
    } else {
      final double? val = double.tryParse(raw.replaceAll(',', '.'));
      if (val != null) {
        final double kg = isKg ? val : (val / 2.20462);
        final String formattedKg = _format(kg);
        if (storageController.text != formattedKg) {
          storageController.text = formattedKg;
        }
      }
    }
    _syncing = false;
  }

  void _syncFromStorage() {
    if (_syncing) return;
    _syncing = true;
    final String rawKg = storageController.text.trim();
    if (rawKg.isEmpty) {
      displayController.text = '';
    } else {
      final double? kg = double.tryParse(rawKg.replaceAll(',', '.'));
      if (kg == null) {
        displayController.text = rawKg;
      } else {
        final double displayVal = isKg ? kg : (kg * 2.20462);
        final String formatted = _format(displayVal);
        if (displayController.text != formatted) {
          displayController.text = formatted;
          displayController.selection = TextSelection.fromPosition(
            TextPosition(offset: displayController.text.length),
          );
        }
      }
    }
    _syncing = false;
  }

  String _format(double value) {
    final String s =
        (value >= 10 ? value.toStringAsFixed(1) : value.toStringAsFixed(2))
            .replaceAll(RegExp(r"\.0+"), '');
    return s;
  }
}
