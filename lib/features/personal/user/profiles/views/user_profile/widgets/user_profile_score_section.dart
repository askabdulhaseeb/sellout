import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../domain/entities/user_entity.dart';
import '../../widgets/score_widget_bottomsheets/supporter_bottom_sheet.dart';
import '../../widgets/subwidgets/support_button.dart';

class UserProfileScoreSection extends StatelessWidget {
  const UserProfileScoreSection({
    required this.user,
    this.isBlocked = false,
    this.onUnblock,
    this.isBusy = false,
    super.key,
  });
  final UserEntity? user;
  final bool isBlocked;
  final VoidCallback? onUnblock;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: SizedBox(
        height: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: IgnorePointer(
                child: _ScoreButton(
                  title: 'supporting'.tr(),
                  count: (user?.supportings?.length ?? 0).toString(),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
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
            ),
            const SizedBox(width: 8),
            Expanded(
              child: IgnorePointer(
                ignoring: isBlocked,
                child: _ScoreButton(
                  title: 'supporters'.tr(),
                  count: (user?.supporters?.length ?? 0).toString(),
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
            ),
            const SizedBox(width: 8),
            Expanded(
              child: isBlocked
                  ? SizedBox(
                      height: 35,
                      child: CustomElevatedButton(
                        margin: EdgeInsets.zero,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        title: 'unblock'.tr(),
                        textStyle: TextTheme.of(
                          context,
                        ).labelMedium?.copyWith(),
                        onTap: onUnblock ?? () {},
                        isLoading: isBusy,
                        isDisable: isBusy || onUnblock == null,
                        textColor: Theme.of(context).colorScheme.onError,
                        fontWeight: FontWeight.w500,
                        loadingWidget: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        ),
                      ),
                    )
                  : SupportButton(
                      supporterId: user?.uid ?? '',
                      supportColor: Theme.of(context).primaryColor,
                      supportingColor: Theme.of(context).colorScheme.secondary,
                      supportTextColor: Theme.of(context).colorScheme.onPrimary,
                      supportingTextColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary,
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
