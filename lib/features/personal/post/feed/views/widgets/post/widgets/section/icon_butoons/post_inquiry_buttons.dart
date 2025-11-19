import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../chats/chat/domain/params/post_inquiry_params.dart';
import '../../../../../../../../chats/chat/views/providers/chat_provider.dart';
import '../../../../../../../../chats/chat_dashboard/domain/entities/chat/chat_entity.dart';
import '../../../../../../../../chats/chat_dashboard/domain/usecase/create_inquiry_chat_usecase.dart';
import '../../../../../../../domain/entities/post/post_entity.dart';

class CreatePostInquiryChatButton extends StatelessWidget {
  const CreatePostInquiryChatButton({
    required this.post,
    super.key,
  });

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    debugPrint('CreatePostInquiryChatButton build for post: \\${post.postID}');
    return GestureDetector(
      onTap: () {
        debugPrint('Inquiry button tapped for post: \\${post.postID}');
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => _PostInquiryDialog(post: post),
        );
      },
      child: const CustomSvgIcon(assetPath: AppStrings.selloutOrderChatIcon),
    );
  }
}

class _PostInquiryDialog extends StatefulWidget {
  const _PostInquiryDialog({required this.post});
  final PostEntity post;

  @override
  State<_PostInquiryDialog> createState() => _PostInquiryDialogState();
}

class _PostInquiryDialogState extends State<_PostInquiryDialog> {
  int? selectedOption = 0;
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  static const List<String> itemOptions = <String>[
    'inquiry_item_stock',
    'inquiry_item_pictures',
    'inquiry_item_final_price',
    'inquiry_item_delivery_time',
    'inquiry_other',
  ];

  static const List<String> propertyOptions = <String>[
    'inquiry_property_available',
    'inquiry_property_visit',
    'inquiry_property_negotiable',
    'inquiry_property_pets',
    'inquiry_other',
  ];

  static const List<String> vehicleOptions = <String>[
    'inquiry_vehicle_accident_free',
    'inquiry_vehicle_service_history',
    'inquiry_vehicle_test_drive',
    'inquiry_vehicle_known_issues',
    'inquiry_other',
  ];

  static const List<String> clothFootOptions = <String>[
    'inquiry_cloth_foot_size',
    'inquiry_cloth_foot_new_preowned',
    'inquiry_cloth_foot_returns',
    'inquiry_cloth_foot_machine_washable',
    'inquiry_other',
  ];

  static const List<String> foodDrinkOptions = <String>[
    'inquiry_food_ingredients',
    'inquiry_food_fresh_frozen',
    'inquiry_food_shelf_life',
    'inquiry_other',
  ];

  static const List<String> petOptions = <String>[
    'inquiry_pet_vaccinated',
    'inquiry_pet_pictures',
    'inquiry_pet_delivery',
    'inquiry_pet_age_breed',
    'inquiry_other',
  ];

  List<String> get options {
    switch (widget.post.type) {
      case ListingType.items:
        return itemOptions;
      case ListingType.property:
        return propertyOptions;
      case ListingType.vehicle:
        return vehicleOptions;
      case ListingType.clothAndFoot:
        return clothFootOptions;
      case ListingType.foodAndDrink:
        return foodDrinkOptions;
      case ListingType.pets:
        return petOptions;
    }
  }

  String get inquiryText {
    if (selectedOption == 4) {
      debugPrint(
          'InquiryText: Other selected, text: \\${_controller.text.trim()}');
      return _controller.text.trim();
    }
    if (selectedOption != null) {
      debugPrint('InquiryText: Option selected: \\${options[selectedOption!]}');
      return options[selectedOption!].tr();
    }
    debugPrint('InquiryText: No option selected');
    return '';
  }

  Future<void> _sendInquiry(BuildContext context) async {
    final String text = inquiryText;

    if (text.isEmpty) {
      debugPrint('SendInquiry: Text is empty, aborting.');
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'somthing_wrong'.tr());
      }
      return;
    }

    if (mounted) setState(() => _isLoading = true);
    debugPrint(
        'SendInquiry: Sending inquiry for post: \\${widget.post.postID}, text: \\$text');

    try {
      final CreateInquiryChatUseacse usecase =
          CreateInquiryChatUseacse(locator());
      final DataState<ChatEntity> result = await usecase(
          PostInquiryParams(postId: widget.post.postID, text: text));

      if (result.entity != null) {
        debugPrint(
            'SendInquiry: Inquiry sent successfully for post: \\${widget.post.postID}');
        if (context.mounted) {
          final ChatEntity? chatEntity = result.entity;
          if (chatEntity != null) {
            Provider.of<ChatProvider>(context, listen: false)
                .openChat(context, chatEntity);
          } else {
            AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
          }
        }
      } else {
        debugPrint(
            'SendInquiry: Inquiry result.entity is null for post: \\${widget.post.postID}');
        if (context.mounted) {
          AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
        }
      }
    } catch (_) {
      debugPrint(
          'SendInquiry: Error sending inquiry for post: \\${widget.post.postID}');
      if (context.mounted) {
        AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      }
    } finally {
      debugPrint('SendInquiry: Setting loading to false');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double dialogMaxWidth =
        MediaQuery.of(context).size.width * 0.9; // responsive

    debugPrint('_PostInquiryDialog build for post: \\${widget.post.postID}');
    return AlertDialog(
      title: Text('inquiry_post_title'.tr()),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogMaxWidth),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('inquiry_post_question'.tr()),
              const SizedBox(height: 12),

              /// OPTIONS
              ...List<Widget>.generate(
                options.length,
                (int i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ShadowContainer(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    showShadow: false,
                    child: RadioListTile<int>(
                      value: i,
                      groupValue: selectedOption,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      title: Text(options[i].tr()),
                      onChanged: (int? val) {
                        debugPrint(
                            'RadioListTile changed: selectedOption = \\$val');
                        setState(() => selectedOption = val);
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
              ),

              /// “Other” text field
              if (selectedOption == 4)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextField(
                    controller: _controller,
                    maxLength: 500,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'inquiry_post_hint'.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

      /// ACTIONS
      actions: <Widget>[
        CustomElevatedButton(
          bgColor: Colors.transparent,
          textColor: Theme.of(context).primaryColor,
          border: Border.all(color: Theme.of(context).primaryColor),
          onTap: () {
            debugPrint('Cancel button tapped in inquiry dialog');
            Navigator.of(context).pop();
          },
          title: 'cancel'.tr(),
          isLoading: false,
        ),
        CustomElevatedButton(
          isLoading: _isLoading,
          onTap: () {
            debugPrint('Send button tapped in inquiry dialog');
            _sendInquiry(context);
          },
          title: 'send'.tr(),
        ),
      ],
    );
  }
}
