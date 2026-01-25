import 'package:easy_localization/easy_localization.dart';
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
  const UserProfileGridSection({
    required this.user,
    this.isBlocked = false,
    super.key,
  });
  final UserEntity? user;
  final bool isBlocked;

  @override
  Widget build(BuildContext context) {
    if (isBlocked) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.block,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'blocked_banner_message'.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'blocked_header_hidden'.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }

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
