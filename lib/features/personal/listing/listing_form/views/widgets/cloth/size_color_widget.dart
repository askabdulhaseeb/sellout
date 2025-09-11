import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'color_size_bottomsheet.dart';

class AddListingSizeColorWidget extends StatelessWidget {
  const AddListingSizeColorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final AddListingFormProvider pro =
    //     Provider.of<AddListingFormProvider>(context);
    return InkWell(
      onTap: () {
        showBottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            context: context,
            builder: (BuildContext context) => const SizeColorBottomSheet());
      },
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'select_size_color'.tr(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                width: double.infinity,
                // margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: ColorScheme.of(context).outlineVariant)),
                height: 50,
                child: Text(
                  'tap_to_select'.tr(),
                  style: TextTheme.of(context)
                      .bodyMedium
                      ?.copyWith(color: ColorScheme.of(context).outline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
