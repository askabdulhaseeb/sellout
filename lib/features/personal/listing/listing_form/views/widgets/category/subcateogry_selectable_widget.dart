import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../core/widgets/loader.dart';
import '../../../domain/entities/listing_entity.dart';
import '../../../domain/entities/sub_category_entity.dart';
import '../../providers/add_listing_form_provider.dart';
import 'category_selection_bottom_sheet.dart';

class SubCategorySelectableWidget extends StatefulWidget {
  const SubCategorySelectableWidget({
    required this.listType,
    required this.subCategory,
    required this.onSelected,
    super.key,
  });

  final ListingType? listType;
  final SubCategoryEntity? subCategory;
  final void Function(SubCategoryEntity?) onSelected;

  @override
  State<SubCategorySelectableWidget> createState() =>
      _SubCategorySelectableWidgetState();
}

class _SubCategorySelectableWidgetState
    extends State<SubCategorySelectableWidget> {
  @override
  void initState() {
    super.initState();
    // Fetch categories when the widget is initialized
    final AddListingFormProvider provider =
        Provider.of<AddListingFormProvider>(context, listen: false);
    if (provider.listings.isEmpty) {
      provider.fetchCategories();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AddListingFormProvider>(
      builder: (BuildContext context, AddListingFormProvider provider,
          Widget? child) {
        if (provider.isLoading) {
          return const Loader(); // Show loader while data is being fetched
        }
        if (provider.listings.isEmpty) {
          return Center(child: Text('something_wrong'.tr()));
        }
        final List<ListingEntity> selectedList = provider.listings
            .where((ListingEntity element) => element.type == widget.listType)
            .toList();
        return _buildCategorySelector(selectedList, context);
      },
    );
  }

  Widget _buildCategorySelector(
      List<ListingEntity> selectedList, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'category',
          style: TextStyle(fontWeight: FontWeight.w500),
        ).tr(),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => _handleCategorySelection(selectedList, context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.subCategory?.title ?? 'select_sub_category'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.subCategory == null ? Colors.grey : null,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleCategorySelection(
      List<ListingEntity> selectedList, BuildContext context) async {
    if (selectedList.isEmpty) {
      AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
      return;
    }

    final SubCategoryEntity? selectCat = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => CategorySelectionBottomSheet(
        subCategories: selectedList.first.subCategory,
      ),
    );

    if (selectCat != null) {
      widget.onSelected(selectCat);
    }
  }
}
