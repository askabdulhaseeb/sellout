import 'package:flutter/material.dart';

import '../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../core/domain/entity/business_entity.dart';
import 'section_details/score/business_page_score_bottom_sheet.dart';

class BusinessPageScoreSection extends StatelessWidget {
  const BusinessPageScoreSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: <Widget>[
          _Button(
            title: 'details'.tr(),
            onTap: () async {
              await showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return BusinessPageScoreBottomSheet(business: business);
                },
              );
            },
          ),
          const SizedBox(width: 8),
          _Button(title: 'supporting'.tr(), onTap: () {}),
          const SizedBox(width: 8),
          _Button(title: 'supporters'.tr(), onTap: () {}),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(8);
    const Color color = Colors.transparent;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: Border.all(
            // width: 0.2,
            color: Theme.of(context).disabledColor,
          ),
        ),
        child: Material(
          borderRadius: borderRadius,
          color: color,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
