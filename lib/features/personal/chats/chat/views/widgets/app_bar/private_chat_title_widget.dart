import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../../user/profiles/views/user_profile/screens/user_profile_screen.dart';
import '../../../../../../business/business_page/views/screens/user_business_profile_screen.dart';
import '../../../../../../business/core/data/sources/local_business.dart';
import '../../../../../../business/core/domain/entity/business_entity.dart';
import '../../../../chat_dashboard/views/widgets/chat_profile_with_status.dart';
import '../../providers/chat_provider.dart';

class PrivateChatTitleWidget extends StatelessWidget {
  const PrivateChatTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider pro, _) {
        final String otherPersonId = pro.chat?.otherPerson() ?? '';
        final bool isBusiness = otherPersonId.toUpperCase().startsWith('BU');
        final BusinessEntity? business = isBusiness
            ? LocalBusiness().business(otherPersonId)
            : null;
        final UserEntity? user = !isBusiness
            ? LocalUser().userEntity(otherPersonId)
            : null;
        return InkWell(
          onTap: () {
            if (isBusiness) {
              final String bid = business?.businessID ?? '';
              if (bid.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute<UserBusinessProfileScreen>(
                    builder: (_) => UserBusinessProfileScreen(businessID: bid),
                  ),
                );
              }
            } else {
              final String uid = user?.uid ?? '';
              if (uid.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute<UserProfileScreen>(
                    builder: (_) => UserProfileScreen(uid: uid),
                  ),
                );
              }
            }
          },
          child: Row(
            children: <Widget>[
              ProfilePictureWithStatus(
                isProduct: false,
                postImageUrl: isBusiness
                    ? (business?.logo?.url ?? '')
                    : (user?.profilePhotoURL ?? user?.displayName ?? ''),
                userImageUrl: '',
                userDisplayName: isBusiness
                    ? (business?.displayName ?? '')
                    : (user?.displayName ?? ''),
                userId: isBusiness
                    ? (business?.businessID ?? '')
                    : (user?.uid ?? ''),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isBusiness
                          ? (business?.displayName ?? '')
                          : (user?.displayName ?? ''),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'tap_here_to_open_profile'.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ColorScheme.of(
                          context,
                        ).onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
