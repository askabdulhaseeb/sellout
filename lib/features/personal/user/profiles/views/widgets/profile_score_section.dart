import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../domain/entities/user_entity.dart';
import 'subwidgets/support_button.dart';
import 'subwidgets/supporter_bottom_sheet.dart';

class ProfileScoreSection extends StatelessWidget {
  const ProfileScoreSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) { 
    final bool isMe = user?.uid == (LocalAuth.uid ?? '-');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
          height: 35,
          child: Row(
            children: <Widget>[
          if(isMe)    Expanded(
                child: _ScoreButton(
                  title: 'details'.tr(),
                  count: '',
                  onPressed: () {},
                ),
              ),
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
                        issupporter: false,
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
                        supporters:user?.supporters,
                        issupporter: true,
                      );
                    },
                  ),
                ),
              ),
              if(!isMe)Expanded(child:  SupportButton(supporterId: user?.uid ?? '',supportColor: AppTheme.primaryColor,supportingColor: AppTheme.secondaryColor,supportTextColor:ColorScheme.of(context).onPrimary ,supportingTextColor:ColorScheme.of(context).onPrimary ,))
            ],
          )),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).disabledColor,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                count,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
