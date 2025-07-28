import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../providers/services_page_provider.dart';
import 'widgets/filter_sheet_review_dropdown.dart';
import 'widgets/service_filter_mobile_service_dropdown.dart';

class ServicesExploreFilterBottomSheet extends StatelessWidget {
  const ServicesExploreFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ServicesPageProvider pro =
        Provider.of<ServicesPageProvider>(context, listen: false);
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
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CloseButton(onPressed: () {
                    Navigator.pop(context);
                  }),
                  Text(
                    'filter'.tr(),
                    style: TextTheme.of(context)
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      pro.resetFilters();
                    },
                    child: Text(
                      'reset'.tr(),
                      style: TextTheme.of(context)
                          .labelSmall
                          ?.copyWith(color: AppTheme.primaryColor),
                    ),
                  ),
                ],
              ),
              const Divider(height: 0),
              const Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      FilterSheetMobileServiceTile(),
                      SizedBox(height: 8),
                      ServiceFilterSheetCustomerReviewTile(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomElevatedButton(
                  onTap: () {
                    pro.searchServices();
                    Navigator.pop(context);
                  },
                  title: 'apply'.tr(),
                  isLoading: pro.isLoading,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
