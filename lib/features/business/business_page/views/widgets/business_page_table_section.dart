import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../core/domain/entity/business_entity.dart';
import '../enum/business_page_tab_type.dart';
import '../providers/business_page_provider.dart';

class BusinessPageTableSection extends StatelessWidget {
  const BusinessPageTableSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    final CurrentUserEntity? user = LocalAuth.currentUser;
    final bool isMine =
        user?.businessIDs.contains(business.businessID) ?? false;
    final List<BusinessPageTabType> tabs =
        isMine ? BusinessPageTabType.mine : BusinessPageTabType.others;

    return SizedBox(
      height: 50,
      child: Consumer<BusinessPageProvider>(
        builder: (BuildContext context, BusinessPageProvider pagePro, _) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 16),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              primary: false,
              itemCount: tabs.length,
              itemBuilder: (BuildContext context, int index) {
                final BusinessPageTabType tab = tabs[index];
                final bool isSelected = tab == pagePro.selectedTab;
                return _Tab(
                  tab: tab,
                  isSelected: isSelected,
                  onTap: () => pagePro.selectedTab = tab,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });
  final BusinessPageTabType tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              tab.code.tr(),
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Container(
              height: 2,
              width: 60,
              color: isSelected ? Colors.black : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
