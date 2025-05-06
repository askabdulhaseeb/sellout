import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../post/domain/entities/size_color/color_entity.dart';
import '../../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../../domain/entities/color_options_entity.dart';
import '../../providers/add_listing_form_provider.dart';

class SizeColorBottomSheet extends StatefulWidget {
  const SizeColorBottomSheet({super.key});

  @override
  SizeColorBottomSheetState createState() => SizeColorBottomSheetState();
}

class SizeColorBottomSheetState extends State<SizeColorBottomSheet> {
  // Local state for current dropdown selections and quantity input.
  String? selectedSize;
  String? selectedColor;
  final TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider provider =
        Provider.of<AddListingFormProvider>(context, listen: false);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'back'.tr(),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                Text(
                  'size_and_color'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'apply'.tr(),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<AddListingFormProvider>(
              builder: (BuildContext context, AddListingFormProvider provider,
                  Widget? child) {
                if (provider.sizeColorEntities.isEmpty) {
                  return const SizedBox();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: provider.sizeColorEntities.length,
                    itemBuilder: (BuildContext context, int index) {
                      final SizeColorEntity sizeColorEntry =
                          provider.sizeColorEntities[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: sizeColorEntry.colors
                            .map((ColorEntity colorEntity) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              backgroundBlendMode: BlendMode.color,
                              border: Border.all(
                                  color:
                                      ColorScheme.of(context).outlineVariant),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // Display the size value from the entry.
                                Text(sizeColorEntry.value),
                                // Display the color code and quantity.
                                Row(
                                  spacing: 2,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Color(int.parse(
                                          '0xFF${colorEntity.code.replaceAll('#', '')}')),
                                    ),
                                    Text(colorEntity.code),
                                  ],
                                ),
                                Text(colorEntity.quantity.toString()),
                                // Delete button to remove a specific color from the size.
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    provider.removeColorFromSize(
                                      size: sizeColorEntry.value,
                                      color: colorEntity.code,
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                );
              },
            ),
            const Divider(height: 32),
            // --- Input Row for Adding a New Size/Color Entry ---
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: <Widget>[
                  // --- Size Dropdown ---
                  Expanded(
                    child: CustomDropdown<String>(
                      title: '',
                      validator: (_) => null,
                      hint: 'size'.tr(),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      selectedItem: selectedSize,
                      items: <String>['XS', 'S', 'M', 'L']
                          .map((String s) => DropdownMenuItem<String>(
                                value: s,
                                child: Text(
                                  s,
                                ),
                              ))
                          .toList(),
                      onChanged: (String? val) {
                        setState(() {
                          selectedSize = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  // --- Color Dropdown ---
                  SizedBox(
                    width: 100,
                    child: Consumer<AddListingFormProvider>(
                      builder: (BuildContext context,
                          AddListingFormProvider provider, Widget? child) {
                        return FutureBuilder<List<ColorOptionEntity>>(
                          future: provider.colorOptions(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ColorOptionEntity>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final List<ColorOptionEntity> colorOptionsList =
                                snapshot.data!;
                            return CustomDropdown<String>(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 0),
                              hint: 'color'.tr(),
                              selectedItem: selectedColor,
                              title: '',
                              validator: (_) => null,
                              items: colorOptionsList
                                  .map((ColorOptionEntity color) =>
                                      DropdownMenuItem<String>(
                                        value: color.value,
                                        child: Row(
                                          spacing: 1,
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 8,
                                              backgroundColor: Color(int.parse(
                                                  '0xFF${color.value.replaceAll('#', '')}')),
                                            ),
                                            Expanded(
                                                child: Text(color.label,
                                                    maxLines: 2,
                                                    style: TextTheme.of(context)
                                                        .labelSmall)),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedColor = newValue;
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  // --- Quantity TextField ---
                  Expanded(
                    child: CustomTextFormField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        hint: 'quantity'.tr()),
                  ),
                  const SizedBox(width: 10),
                  // --- Add Button ---
                  GestureDetector(
                    onTap: () {
                      if (selectedSize != null &&
                          selectedColor != null &&
                          quantityController.text.isNotEmpty) {
                        final int quantity =
                            int.tryParse(quantityController.text) ?? 1;
                        provider.addOrUpdateSizeColorQuantity(
                          size: selectedSize!,
                          color: selectedColor!,
                          quantity: quantity,
                        );
                        // Clear local state after adding.
                        setState(() {
                          selectedSize = null;
                          selectedColor = null;
                          quantityController.clear();
                        });
                      }
                    },
                    child: Text(
                      'add'.tr(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
