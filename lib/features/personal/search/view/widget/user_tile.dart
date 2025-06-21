import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../user/profiles/data/models/user_model.dart';
import '../../../user/profiles/views/screens/profile_screen.dart';
import '../../../user/profiles/views/screens/user_profile_screen.dart';

class UserTile extends StatelessWidget {
  const UserTile({required this.user, super.key});
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute<ProfileScreen>(
              builder: (BuildContext context) =>
                  UserProfileScreen(uid: user.uid),
            ));
      },
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CustomNetworkImage(
            fit: BoxFit.fill,
            size: 50,
            imageURL: user.profilePhotoURL,
            placeholder: user.displayName,
          )),
      title: Text(
        user.displayName,
        style: TextTheme.of(context).titleSmall?.copyWith(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        user.username,
        style: TextTheme.of(context).labelMedium?.copyWith(
            color: ColorScheme.of(context).onSurface.withValues(alpha: 0.4)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
