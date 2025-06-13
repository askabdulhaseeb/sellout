
import 'dart:async';
import 'package:flutter/material.dart';


class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    required this.queryController, required this.onQueryChanged, required this.onClearPressed, required this.hint, super.key,
  });

  final TextEditingController queryController;
  final Function(String) onQueryChanged;
  final VoidCallback onClearPressed;
  final String hint;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  Timer? _debounce;

  void _onChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onQueryChanged(query.trim());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.queryController,
      onChanged: _onChanged,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: widget.onClearPressed,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
