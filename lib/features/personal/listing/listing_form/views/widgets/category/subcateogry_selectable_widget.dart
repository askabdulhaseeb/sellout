import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/enums/listing/core/listing_type.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../core/widgets/loader.dart';

import '../../../data/sources/remote/listing_api.dart';
import '../../../domain/entities/listing_entity.dart';
import '../../../domain/entities/sub_category_entity.dart';
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
  late Future<List<ListingEntity>> _listingsFuture;

  @override
  void initState() {
    super.initState();
    // Initialize future ONCE to prevent re-triggering
    _listingsFuture = ListingAPI().listing();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListingEntity>>(
      future: _listingsFuture,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<ListingEntity>> snapshot,
      ) {
        // Early return for loading/error states
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          AppLog.error(
            'SubCategorySelectableWidget: ${snapshot.error}',
            name: 'SubCategorySelectableWidget.build',
            error: snapshot.error,
          );
          return Center(child: Text('something_wrong'.tr()));
        }
        // Cache filtered data to avoid recalculating
        final List<ListingEntity> selectedList = snapshot.data!
            .where((ListingEntity element) =>
                element.type == widget.listType || kDebugMode)
            .toList();

        return _buildCategorySelector(selectedList);
      },
    );
  }

  Widget _buildCategorySelector(List<ListingEntity> selectedList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'category',
          style: TextStyle(fontWeight: FontWeight.w500),
        ).tr(),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => _handleCategorySelection(selectedList),
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
      List<ListingEntity> selectedList) async {
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
