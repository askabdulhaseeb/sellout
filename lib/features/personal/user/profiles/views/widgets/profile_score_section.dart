import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/text_display/shadow_container.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import 'score_widget_bottomsheets/employment_details_bottomsheet.dart';
import 'score_widget_bottomsheets/supporter_bottom_sheet.dart';

class ProfileScoreSection extends StatelessWidget {
  const ProfileScoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final CurrentUserEntity? user = LocalAuth.currentUser;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: SizedBox(
        height: 35,
        child: Row(
          spacing: 4,
          children: <Widget>[
            Expanded(
              child: _ScoreButton(
                title: 'details'.tr(),
                count: '',
                onPressed: () {
                  showBottomSheet(
                    context: context,
                    builder: (BuildContext context) =>
                        const EmploymentDetailsBottomSheet(),
                  );
                },
              ),
            ),
            Expanded(
              child: _ScoreButton(
                title: 'supporting'.tr(),
                count: (user?.supporting.length ?? 0).toString(),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return SupporterBottomsheet(supporters: user?.supporting);
                  },
                ),
              ),
            ),
            Expanded(
              child: _ScoreButton(
                title: 'supporters'.tr(),
                count: (user?.supporters.length ?? 0).toString(),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return SupporterBottomsheet(supporters: user?.supporters);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreButton extends StatelessWidget {
  const _ScoreButton({
    required this.title,
    required this.count,
    required this.onPressed,
  });
  final String title;
  final String count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: ShadowContainer(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              count,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
