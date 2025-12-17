import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/user_entity.dart';
import '../enums/user_profile_page_tab_type.dart';
import '../providers/user_profile_provider.dart';
import '../../widgets/list_types/profile_my_viewing_gridview.dart';
import '../../widgets/list_types/profile_promo_gridview.dart';
import '../../widgets/list_types/profile_store_gridview.dart';
import '../../widgets/profile_review_section.dart';

class UserProfileGridSection extends StatelessWidget {
  const UserProfileGridSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (BuildContext context, UserProfileProvider provider, _) {
        switch (provider.displayType) {
          case UserProfilePageTabType.store:
            return ProfileStoreGridview(user: user);
          case UserProfilePageTabType.viewing:
            return ProfileMyViewingGridview(user: user);
          case UserProfilePageTabType.promos:
            return ProfilePromoGridview(user: user);
          case UserProfilePageTabType.reviews:
            return ProfileReviewSection(user: user);
        }
      },
    );
  }
}
