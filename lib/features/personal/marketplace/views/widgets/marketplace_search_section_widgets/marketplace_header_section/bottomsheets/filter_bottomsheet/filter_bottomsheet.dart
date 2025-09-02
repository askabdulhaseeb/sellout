import 'package:flutter/material.dart';
import 'widgets/filter_sheet_button.dart';
import 'widgets/filter_sheet_condition_dropdown.dart';
import 'widgets/filter_sheet_delivery_dropdown.dart';
import 'widgets/filter_sheet_header_sections.dart';
import 'widgets/filter_sheet_price_range.dart';
import 'widgets/filter_sheet_review_dropdown.dart';

class MarketPlaceFilterBottomSheet extends StatelessWidget {
  const MarketPlaceFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      showDragHandle: false,
      enableDrag: false,
      onClosing: () {},
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: const Column(
            children: <Widget>[
              FilterSheetHeaderSection(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    spacing: 8,
                    children: <Widget>[
                      FilterSheetCustomerReviewTile(),
                      ExpandablePriceRangeTile(),
                      FilterSheetConditionTile(),
                      FilterSheetDeliveryTypeTile(),
                    ],
                  ),
                ),
              ),
              FilterSheetSheetButton()
            ],
          ),
        );
      },
    );
  }
}
