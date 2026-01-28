import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../../../core/sockets/handlers/presence_handler.dart';
import '../../../../../../core/widgets/media/profile_photo.dart';
import '../../../../../../services/get_it.dart';

class ProfilePictureWithStatus extends HookWidget {
  const ProfilePictureWithStatus({
    required this.postImageUrl,
    required this.userImageUrl,
    required this.userDisplayName,
    required this.userId,
    required this.isProduct,
    super.key,
  });

  final String postImageUrl;
  final String userImageUrl;
  final String userDisplayName;
  final String userId;
  final bool isProduct;

  @override
  Widget build(BuildContext context) {
    final PresenceHandler presenceHandler = locator();
    final List<String> onlineUserIds = useListenable(
      presenceHandler.onlineUsers,
    ).value;
    final bool isOnline = onlineUserIds.contains(userId);

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(2),
          child: ProfilePhoto(
            size: 22,
            url: postImageUrl,
            placeholder: userDisplayName.isNotEmpty ? userDisplayName : '',
          ),
        ),
        if (isProduct)
          Positioned(
            bottom: 2,
            right: 2,
            child: ProfilePhoto(
              isCircle: true,
              size: 14,
              url: userImageUrl.isNotEmpty ? userImageUrl : postImageUrl,
              placeholder: userDisplayName.isNotEmpty ? userDisplayName : '',
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 6,
            backgroundColor: isOnline ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }
}
