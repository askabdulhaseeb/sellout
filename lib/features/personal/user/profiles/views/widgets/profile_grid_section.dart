import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/user_entity.dart';
import '../enums/profile_page_tab_type.dart';
import '../providers/profile_provider.dart';
import 'list_types/profile_my_saved_gridview.dart';
import 'list_types/profile_my_viewing_gridview.dart';
import 'list_types/profile_promo_gridview.dart';
import 'list_types/profile_store_gridview.dart';
import 'profile_orders_section.dart';
import 'profile_review_section.dart';

class ProfileGridSection extends StatelessWidget {
  const ProfileGridSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<ProfileProvider>(
        builder: (BuildContext context, ProfileProvider profile, _) {
          return profile.displayType == ProfilePageTabType.orders
              ? ProfileOrdersSection(user: user)
              : profile.displayType == ProfilePageTabType.store
                  ? ProfileStoreGridview(user: user)
                  : profile.displayType == ProfilePageTabType.promos
                      ? ProfilePromoGridview(user: user)
                      : profile.displayType == ProfilePageTabType.viewing
                          ? ProfileMyViewingGridview(
                              user: user,
                            )
                          : profile.displayType == ProfilePageTabType.saved
                              ? const ProfileMySavedGridview()
                              : ProfileReviewSection(user: user);
        },
      ),
    );
  }
}
