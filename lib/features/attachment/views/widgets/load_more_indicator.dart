import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoadMoreIndicator extends StatelessWidget {
  const LoadMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(height: 12),
              Text(
                'load_more_photos'.tr(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
