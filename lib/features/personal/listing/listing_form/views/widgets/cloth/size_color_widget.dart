import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../post/domain/entities/size_color/color_entity.dart';
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
          builder: (BuildContext context) => const SizeColorBottomSheet(),
        );
      },
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'select_size_color'.tr(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),

              /// Consumer to rebuild when provider updates
              Consumer<AddListingFormProvider>(
                builder:
                    (BuildContext context, AddListingFormProvider provider, _) {
                  final List<SizeColorEntity> entries =
                      provider.sizeColorEntities;

                  if (entries.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(14),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ColorScheme.of(context).outlineVariant,
                        ),
                      ),
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'tap_to_select'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: ColorScheme.of(context).outline,
                            ),
                      ),
                    );
                  }

                  /// Build a combined list of (size, color) tiles
                  final List<Map<String, dynamic>> sizeColorTiles = [];
                  for (final SizeColorEntity sizeEntry in entries) {
                    for (final ColorEntity color in sizeEntry.colors) {
                      sizeColorTiles.add({
                        'size': sizeEntry.value,
                        'colorCode': color.code,
                      });
                    }
                  }

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorScheme.of(context).outlineVariant,
                      ),
                    ),
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: sizeColorTiles.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 4),
                      itemBuilder: (BuildContext context, int index) {
                        final String size = sizeColorTiles[index]['size'];
                        final String colorCode =
                            sizeColorTiles[index]['colorCode'];
                        Color tileColor =
                            Theme.of(context).colorScheme.surfaceVariant;

                        try {
                          tileColor = Color(int.parse(
                              colorCode.replaceAll('#', '0xFF'))); // hex to int
                        } catch (_) {}

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: tileColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              size,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
