import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/bottom_sheets/widgets/bottom_sheet_top_bar.dart';
import '../../../../../core/domain/entity/business_entity.dart';
import '../../../../../core/domain/entity/routine_entity.dart';
import '../../business_page_employee_list_section.dart';
import 'business_house_display_section.dart';

class BusinessPageScoreBottomSheet extends StatelessWidget {
  const BusinessPageScoreBottomSheet({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    return BottomSheetCore(
      title: '',
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    business.displayName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(CupertinoIcons.phone),
                      onPressed: () async {},
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.map_pin_ellipse),
                      onPressed: () async {},
                    ),
                  ],
                ),
              ],
            ),
            //
            Text(business.tagline ?? ''),
            Text(business.location!.address ?? ''),
            const SizedBox(height: 16),
            const Text(
              'staff',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ).tr(),
            BusinessPageEmployeeListSection(business: business),
            const Divider(),
            BusinessHoursDisplaySection(routine: business.routine ?? <RoutineEntity>[]),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
