import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/coming_soon_overlay.dart';
import '../../../../../core/widgets/scaffold/bottom_bar/business_bottom_nav_bar.dart';
import '../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../core/data/sources/local_business.dart';
import '../../../core/domain/entity/business_entity.dart';
import '../providers/business_page_provider.dart';
import '../widgets/business_page_header_section.dart';
import '../widgets/business_page_score_section.dart';
import '../widgets/business_page_table_section.dart';
import '../widgets/business_page_tap_page_section.dart';

class BusinessProfileScreen extends StatelessWidget {
  const BusinessProfileScreen({required this.businessID, super.key});
  final String businessID;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Stack(
      children: <Widget>[
        PersonalScaffold(
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: scrollController,
                child: FutureBuilder<BusinessEntity?>(
                  future: Provider.of<BusinessPageProvider>(
                    context,
                    listen: false,
                  ).getBusinessByID(businessID),
                  initialData: LocalBusiness().business(businessID),
                  builder:
                      (
                        BuildContext context,
                        AsyncSnapshot<BusinessEntity?> snapshot,
                      ) {
                        final BusinessEntity? business =
                            snapshot.data ??
                            LocalBusiness().business(businessID);
                        return business == null
                            ? Center(child: const Text('something_wrong').tr())
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  BusinessPageHeaderSection(business: business),
                                  BusinessPageScoreSection(business: business),
                                  BusinessPageTableSection(business: business),
                                  BusinessPageTapPageSection(
                                    business: business,
                                    scrollController: scrollController,
                                  ),
                                ],
                              );
                      },
                ),
              ),
            ],
          ),
          bottomNavigationBar: const SafeArea(
            child:  BusinessBottomNavBar(),
          ),
        ),
        ComingSoonOverlay(
          title: 'coming_soon'.tr(),
          subtitle: 'services_coming_soon_subtitle'.tr(),
          icon: CupertinoIcons.hourglass,
        ),
      ],
    );
  }
}
