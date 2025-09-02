import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../personal/chats/create_chat/view/provider/create_private_chat_provider.dart';
import '../../../../../core/domain/entity/business_entity.dart';
import '../../../providers/business_page_provider.dart';

class BusinessPageServiceFilterSection extends StatefulWidget {
  const BusinessPageServiceFilterSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  State<BusinessPageServiceFilterSection> createState() =>
      _BusinessPageServiceFilterSectionState();
}

class _BusinessPageServiceFilterSectionState
    extends State<BusinessPageServiceFilterSection> {
  final TextEditingController _queryController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _queryController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value, BusinessPageProvider businessPro) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      businessPro.serviceQuery = value;
      businessPro.getServicesByQuery();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BusinessPageProvider, CreatePrivateChatProvider>(
      builder: (
        BuildContext context,
        BusinessPageProvider businessPro,
        CreatePrivateChatProvider chatPro,
        _,
      ) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 6,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: CustomTextFormField(
                  dense: true,
                  style: Theme.of(context).textTheme.bodySmall,
                  isExpanded: true,
                  contentPadding: const EdgeInsets.all(8),
                  controller: _queryController,
                  hint: 'search'.tr(),
                  onChanged: (value) => _onSearchChanged(value, businessPro),
                ),
              ),
              Flexible(
                flex: 1,
                child: CustomElevatedButton(
                  bgColor: Colors.transparent,
                  border: Border.all(color: Theme.of(context).primaryColor),
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(8),
                  isLoading: chatPro.isLoading,
                  onTap: () => chatPro.startPrivateChat(
                      context, widget.business.businessID ?? ''),
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).primaryColor),
                  title: 'request_quote'.tr(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
