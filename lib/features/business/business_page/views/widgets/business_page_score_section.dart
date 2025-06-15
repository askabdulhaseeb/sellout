import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../personal/user/profiles/views/widgets/score_widget_bottomsheets/employyement_details_bottomsheet.dart';
import '../../../../personal/user/profiles/views/widgets/subwidgets/support_button.dart';
import '../../../../personal/user/profiles/views/widgets/score_widget_bottomsheets/supporter_bottom_sheet.dart';
import '../../../core/domain/entity/business_entity.dart';

class BusinessPageScoreSection extends StatelessWidget {
  const BusinessPageScoreSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    // final bool isMe = business.businessID == (LocalAuth.uid ?? '-');
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: SizedBox(
          height: 35,
          child: Row(
            children: <Widget>[
              Expanded(
                child: _ScoreButton(
                  count: '',
                  title: 'details'.tr(),
                  onPressed: () async {
                    showBottomSheet(
                      context: context,
                      builder: (BuildContext context) =>
                          const EmploymentDetailsBottomSheet(),
                    );
                  },
                ),
              ),
              // Expanded(
              //   child: _ScoreButton(
              //     title: 'supporting'.tr(),
              //     count: (business.supportings?.length ?? 0).toString(),
              //     onPressed: () => showModalBottomSheet(
              //       context: context,
              //       shape: const RoundedRectangleBorder(
              //         borderRadius:
              //             BorderRadius.vertical(top: Radius.circular(16)),
              //       ),
              //       isScrollControlled: true,
              //       builder: (BuildContext context) {
              //         return SupporterBottomsheet(
              //           supporters: business.supportings,
              //           issupporter: false,
              //         );
              //       },
              //     ),
              //   ),
              // ),
              Expanded(
                child: _ScoreButton(
                  title: 'supporters'.tr(),
                  count: (business.supporters?.length ?? 0).toString(),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return SupporterBottomsheet(
                        supporters: business.supporters,
                        issupporter: true,
                      );
                    },
                  ),
                ),
              ),
              // if(!isMe)
              Expanded(
                  child: SupportButton(
                supporterId: business.businessID ?? '',
                supportColor: AppTheme.primaryColor,
                supportingColor: AppTheme.secondaryColor,
                supportTextColor: ColorScheme.of(context).onPrimary,
                supportingTextColor: ColorScheme.of(context).onPrimary,
              ))
            ],
          ),
        ));
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
