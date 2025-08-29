import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/nav_bar/business_bottom_nav_bar_type.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../personal/chats/create_chat/view/provider/create_private_chat_provider.dart';
import '../../../../../core/domain/entity/business_entity.dart';

class BusinessPageServiceFilterSection extends StatelessWidget {
  const BusinessPageServiceFilterSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    final CreatePrivateChatProvider pro =
        Provider.of<CreatePrivateChatProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 4,
        children: <Widget>[
          Expanded(
            child: CustomTextFormField(
              dense: true,
              style: Theme.of(context).textTheme.bodySmall,
              isExpanded: true,
              contentPadding: const EdgeInsets.all(8),
              controller: TextEditingController(),
              hint: 'search'.tr(),
              onChanged: (String value) {},
            ),
          ),
          Expanded(
            child: CustomElevatedButton(
              bgColor: Colors.transparent,
              border: Border.all(color: Theme.of(context).primaryColor),
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(8),
              isLoading: pro.isLoading,
              onTap: () =>
                  pro.startPrivateChat(context, business.businessID ?? ''),
              textStyle: TextTheme.of(context)
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).primaryColor),
              title: 'request_quote'.tr(),
            ),
          )
        ],
      ),
    );
  }
}
