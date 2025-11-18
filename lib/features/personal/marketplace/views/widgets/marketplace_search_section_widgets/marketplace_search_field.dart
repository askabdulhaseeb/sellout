import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/custom_textformfield.dart';
import '../../providers/marketplace_provider.dart';

class MarketplaceSearchField extends StatefulWidget {
  const MarketplaceSearchField({super.key});

  @override
  State<MarketplaceSearchField> createState() => _MarketplaceSearchFieldState();
}

class _MarketplaceSearchFieldState extends State<MarketplaceSearchField> {
  Timer? _debounce;
  String _lastQuery = '';

  void _onSearchChanged(MarketPlaceProvider provider, String query) {
    if (_lastQuery == query) return;
    _lastQuery = query;
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      provider.loadPosts();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketPlaceProvider>(
      builder: (BuildContext context, MarketPlaceProvider pro, Widget? child) =>
          Expanded(
        child: CustomTextFormField(
          autoFocus: false,
          onChanged: (String value) => _onSearchChanged(pro, value),
          controller: pro.queryController,
          hint: 'search_prodcuts_here'.tr(),
          prefixIcon: const Icon(CupertinoIcons.search),
          suffixIcon: (pro.isLoading && pro.queryController.text.isNotEmpty)
              ? const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
