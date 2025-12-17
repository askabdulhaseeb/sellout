import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/shadow_container.dart';
import '../../../domain/entities/user_entity.dart';
import '../../widgets/score_widget_bottomsheets/supporter_bottom_sheet.dart';
import '../../widgets/subwidgets/support_button.dart';

class UserProfileScoreSection extends StatelessWidget {
  const UserProfileScoreSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: SizedBox(
        height: 35,
        child: Row(
          spacing: 4,
          children: <Widget>[
            Expanded(
              child: _ScoreButton(
                title: 'supporting'.tr(),
                count: (user?.supportings?.length ?? 0).toString(),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return SupporterBottomsheet(
                      supporters: user?.supportings,
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: _ScoreButton(
                title: 'supporters'.tr(),
                count: (user?.supporters?.length ?? 0).toString(),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return SupporterBottomsheet(
                      supporters: user?.supporters,
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: SupportButton(
                supporterId: user?.uid ?? '',
                supportColor: Theme.of(context).primaryColor,
                supportingColor: Theme.of(context).colorScheme.secondary,
                supportTextColor: ColorScheme.of(context).onPrimary,
                supportingTextColor: ColorScheme.of(context).onPrimary,
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
