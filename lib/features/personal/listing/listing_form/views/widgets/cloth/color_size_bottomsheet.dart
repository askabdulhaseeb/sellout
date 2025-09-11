import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/dropdowns/color_dropdown.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../../../../post/domain/entities/size_color/color_entity.dart';
import '../../../../../post/domain/entities/size_color/size_color_entity.dart';
import '../../../domain/entities/color_options_entity.dart';
import '../../providers/add_listing_form_provider.dart';
import 'size_dropdown.dart';

class SizeColorBottomSheet extends StatefulWidget {
  const SizeColorBottomSheet({super.key});

  @override
  State<SizeColorBottomSheet> createState() => _SizeColorBottomSheetState();
}

class _SizeColorBottomSheetState extends State<SizeColorBottomSheet> {
  String? selectedSize;
  ColorOptionEntity? selectedColor;
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
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          backgroundBlendMode: BlendMode.color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            BottomSheetHeader(
              onBack: () => Navigator.pop(context),
              onApply: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
            const Expanded(child: SizeColorListView()),
            const Divider(height: 32),
            SizeColorInputRow(
              selectedSize: selectedSize,
              selectedColor: selectedColor,
              quantityController: quantityController,
              onSizeChanged: (String? val) =>
                  setState(() => selectedSize = val),
              onColorChanged: (ColorOptionEntity? val) =>
                  setState(() => selectedColor = val),
              onAdd: () {
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
                  setState(() {
                    selectedSize = null;
                    selectedColor = null;
                    quantityController.clear();
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    required this.onBack,
    required this.onApply,
    super.key,
  });
  final VoidCallback onBack;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextButton(
          onPressed: onBack,
          child: Text('back'.tr(),
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
        Text('size_and_color'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: onApply,
          child: Text('apply'.tr(),
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ],
    );
  }
}

class SizeColorListView extends StatelessWidget {
  const SizeColorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (_, AddListingFormProvider provider, __) {
        if (provider.sizeColorEntities.isEmpty) return const SizedBox();

        return ListView.builder(
          itemCount: provider.sizeColorEntities.length,
          itemBuilder: (_, int index) {
            final SizeColorEntity sizeColorEntry =
                provider.sizeColorEntities[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sizeColorEntry.colors.map((ColorEntity colorEntity) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: ColorScheme.of(context).outlineVariant),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(sizeColorEntry.value)),
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: Color(int.parse(
                            '0xFF${colorEntity.code.replaceAll('#', '')}')),
                      ),
                      const SizedBox(width: 4),
                      Text(colorEntity.code),
                      const SizedBox(width: 8),
                      Text('${colorEntity.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
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
        );
      },
    );
  }
}

class SizeColorInputRow extends StatelessWidget {
  const SizeColorInputRow({
    required this.selectedSize,
    required this.selectedColor,
    required this.quantityController,
    required this.onSizeChanged,
    required this.onColorChanged,
    required this.onAdd,
    super.key,
  });

  final String? selectedSize;
  final ColorOptionEntity? selectedColor;
  final TextEditingController quantityController;
  final ValueChanged<String?> onSizeChanged;
  final ValueChanged<ColorOptionEntity?> onColorChanged;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final AddListingFormProvider formPro =
        Provider.of<AddListingFormProvider>(context, listen: false);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: SizeDropdown(
            formPro: formPro,
            selectedSize: selectedSize,
            onSizeChanged: onSizeChanged,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: ColorDropdown(
            validator: (bool? p0) => null,
            selectedColor: selectedColor,
            onColorChanged: (ColorOptionEntity? value) => onColorChanged,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: CustomTextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            hint: 'quantity'.tr(),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 8),
        AddButton(onAdd: onAdd),
      ],
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({
    required this.onAdd,
    super.key,
  });

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Text(
        'add'.tr(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
