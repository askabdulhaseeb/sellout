import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'You_have_been_added_group'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Accept button
              Expanded(
                child: CustomElevatedButton(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  isLoading: false,
                  title: 'accept'.tr(),
                  onTap: () => pro.acceptGroupInvite(context),
                  bgColor: Theme.of(context).primaryColor,
                  textStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(width: 6),
              // Decline button
              Expanded(
                child: CustomElevatedButton(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  isLoading: false,
                  title: 'decline'.tr(),
                  onTap: () {},
                  bgColor: Colors.transparent,
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 1.5),
                  textStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
