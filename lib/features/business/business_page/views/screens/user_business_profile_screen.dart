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

class UserBusinessProfileScreen extends StatefulWidget {
  const UserBusinessProfileScreen({required this.businessID, super.key});
  final String businessID;

  @override
  State<UserBusinessProfileScreen> createState() =>
      _UserBusinessProfileScreenState();
}

class _UserBusinessProfileScreenState extends State<UserBusinessProfileScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('business').tr(), centerTitle: false),
      body: SingleChildScrollView(
        controller: scrollController,
        child: FutureBuilder<BusinessEntity?>(
          future: Provider.of<BusinessPageProvider>(context, listen: false)
              .getBusinessByID(widget.businessID),
          initialData: LocalBusiness().business(widget.businessID),
          builder: (
            BuildContext context,
            AsyncSnapshot<BusinessEntity?> snapshot,
          ) {
            debugPrint(
                'Business Profile routine: ${snapshot.data?.routine?.first.toString()}');
            final BusinessEntity? business =
                snapshot.data ?? LocalBusiness().business(widget.businessID);
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
    );
  }
}
