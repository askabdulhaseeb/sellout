import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/user_entity.dart';
import '../providers/profile_provider.dart';
import 'list_types/profile_my_saved_gridview.dart';
import 'list_types/profile_my_viewing_gridview.dart';
import 'list_types/profile_promo_gridview.dart';
import 'list_types/profile_store_gridview.dart';

class ProfileGridSection extends StatelessWidget {
  const ProfileGridSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<ProfileProvider>(
        builder: (BuildContext context, ProfileProvider profile, _) {
          return profile.displayType == 0
              ? ProfileStoreGridview(user: user)
              : profile.displayType == 1
                  ? ProfilePromoGridview(user: user)
                  : profile.displayType == 2
                      ? const ProfileMyViewingGridview()
                      : const ProfileMySavedGridview();
        },
      ),
    );
  }
}
