import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../../../../core/widgets/shadow_container.dart';
import '../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../chats/chat/domain/params/post_inquiry_params.dart';
import '../../../../../../../../chats/chat/domain/usecase/create_post_inquiry_usecase.dart';
import '../../../../../../../domain/entities/post/post_entity.dart';

class _PostInquiryDialog extends StatefulWidget {
  const _PostInquiryDialog({required this.post});
  final PostEntity post;

  @override
  State<_PostInquiryDialog> createState() => _PostInquiryDialogState();
}

class _PostInquiryDialogState extends State<_PostInquiryDialog> {
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

  int? selectedOption = 0;
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

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
      return _controller.text.trim();
    } else if (selectedOption != null) {
      return options[selectedOption!].tr();
    }
    return '';
  }

  Future<void> _sendInquiry(BuildContext context) async {
    if (inquiryText.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final CreatePostInquiryUsecase createPostInquiryUsecase =
          CreatePostInquiryUsecase(locator());

      final PostInquiryParams params = PostInquiryParams(
        postId: widget.post.postID,
        text: inquiryText,
          

      );

      await createPostInquiryUsecase.call(params);
      if (context.mounted) Navigator.of(context).pop();
    } catch (e) {
      AppSnackBar.showSnackBar(context, 'somthing_wrong'.tr());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('inquiry_post_title'.tr()),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('inquiry_post_question'.tr()),
              const SizedBox(height: 12),
              ...List.generate(
                options.length,
                (int i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ShadowContainer(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    showShadow: false,
                    borderRadius: BorderRadius.circular(8),
                    child: RadioListTile<int>(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      dense: true,
                      value: i,
                      groupValue: selectedOption,
                      title: Text(options[i].tr()),
                      onChanged: (int? val) {
                        setState(() {
                          selectedOption = val;
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tileColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
              if (selectedOption == 4)
                TextField(
                  controller: _controller,
                  maxLength: 500,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'inquiry_post_hint'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        CustomElevatedButton(
          bgColor: Colors.transparent,
          textColor: ColorScheme.of(context).primary,
          border: Border.all(color: ColorScheme.of(context).primary),
          onTap: () => Navigator.of(context).pop(),
          title: 'cancel'.tr(),
          isLoading: false,
        ),
        CustomElevatedButton(
            isLoading: _isLoading,
            onTap: () => _sendInquiry(context),
            title: 'send'.tr()),
      ],
    );
  }
}
