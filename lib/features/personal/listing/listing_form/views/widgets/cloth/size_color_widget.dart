import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/inputs/custom_textformfield.dart';
import '../../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../providers/add_listing_form_provider.dart';
import 'color_size_bottomsheet.dart';

class AddListingSizeColorWidget extends StatelessWidget {
  const AddListingSizeColorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showBottomSheet(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (_) => const SizeColorBottomSheet(),
        );
      },
      child: Consumer<AddListingFormProvider>(
        builder:
            (
              BuildContext context,
              AddListingFormProvider provider,
              Widget? child,
            ) => IgnorePointer(
              child: CustomTextFormField(
                labelText: 'select_size_color'.tr(),
                readOnly: true,
                hint: 'select_size_color'.tr(),
                controller: TextEditingController(
                  text: provider.sizeColorEntities.isEmpty
                      ? ''
                      : provider.sizeColorEntities
                            .map((SizeColorEntity e) => e.value)
                            .join(', '),
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ),
      ),
    );
  }
}
