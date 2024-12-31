import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/domain/entity/business_entity.dart';
import '../enum/business_page_tab_type.dart';
import '../providers/business_page_provider.dart';
import 'section_details/business_page_calender_section.dart';
import 'section_details/business_page_myviewing_section.dart';
import 'section_details/business_page_promo_section.dart';
import 'section_details/business_page_review_section.dart';
import 'section_details/service/business_page_service_section.dart';
import 'section_details/business_page_store_section.dart';

class BusinessPageTapPageSection extends StatelessWidget {
  const BusinessPageTapPageSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessPageProvider>(
      builder: (BuildContext context, BusinessPageProvider pagePro, _) {
        return pagePro.selectedTab == BusinessPageTabType.calender
            ? BusinessPageCalenderSection(business: business)
            : pagePro.selectedTab == BusinessPageTabType.services
                ? BusinessPageServiceSection(business: business)
                : pagePro.selectedTab == BusinessPageTabType.store
                    ? BusinessPageStoreSection(business: business)
                    : pagePro.selectedTab == BusinessPageTabType.promos
                        ? BusinessPageProMoSection(business: business)
                        : pagePro.selectedTab == BusinessPageTabType.myviewing
                            ? BusinessPageMyViewingSection(business: business)
                            : pagePro.selectedTab == BusinessPageTabType.reviews
                                ? BusinessPageReviewSection(business: business)
                                : Center(
                                    child: const Text('something-wrong').tr(),
                                  );
      },
    );
  }
}
