import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../providers/chat_provider.dart';

class GroupInviteActionWidget extends StatelessWidget {
  const GroupInviteActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatProvider pro = Provider.of<ChatProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: ColorScheme.of(context).surfaceContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'You_have_been_added_group'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomElevatedButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                isLoading: false,
                borderRadius: BorderRadius.circular(30),
                textStyle: TextTheme.of(context)
                    .bodySmall
                    ?.copyWith(color: ColorScheme.of(context).onPrimary),
                bgColor: AppTheme.primaryColor,
                title: 'accept'.tr(),
                onTap: () {
                  pro.acceptGroupInvite(context);
                },
              ),
              CustomElevatedButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                isLoading: false,
                borderRadius: BorderRadius.circular(30),
                textStyle: TextTheme.of(context)
                    .bodySmall
                    ?.copyWith(color: AppTheme.secondaryColor),
                bgColor: Colors.transparent,
                border: Border.all(color: AppTheme.secondaryColor),
                title: 'decline'.tr(),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
