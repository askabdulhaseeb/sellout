import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    required this.titleKey,
    super.key,
  });
  final String titleKey;

  @override
  Widget build(BuildContext context) {
    return Text(titleKey.tr(),
        overflow: TextOverflow.ellipsis,
        style: TextTheme.of(context)
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w500, fontSize: 18));
  }
}
