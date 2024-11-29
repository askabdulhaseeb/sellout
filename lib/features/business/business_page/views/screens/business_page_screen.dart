import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/sources/local_business.dart';
import '../../../core/domain/entity/business_entity.dart';
import '../providers/business_page_provider.dart';
import '../widgets/business_page_header_section.dart';
import '../widgets/business_page_score_section.dart';
import '../widgets/business_page_table_section.dart';
import '../widgets/business_page_tap_page_section.dart';

class BusinessPageScreen extends StatelessWidget {
  const BusinessPageScreen({required this.businessID, super.key});
  final String businessID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('business').tr(), centerTitle: false),
      body: FutureBuilder<BusinessEntity?>(
        future: Provider.of<BusinessPageProvider>(context, listen: false)
            .getBusinessByID(businessID),
        initialData: LocalBusiness().business(businessID),
        builder: (
          BuildContext context,
          AsyncSnapshot<BusinessEntity?> snapshot,
        ) {
          final BusinessEntity? business =
              snapshot.data ?? LocalBusiness().business(businessID);
          return business == null
              ? Center(child: const Text('something-wrong').tr())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BusinessPageHeaderSection(business: business),
                    BusinessPageScoreSection(business: business),
                    BusinessPageTableSection(business: business),
                    BusinessPageTapPageSection(business: business),
                  ],
                );
        },
      ),
    );
  }
}
