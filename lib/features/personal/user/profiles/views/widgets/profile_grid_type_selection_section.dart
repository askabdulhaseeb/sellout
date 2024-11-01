import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/user_entity.dart';
import '../providers/profile_provider.dart';

class ProfileGridTypeSelectionSection extends StatelessWidget {
  const ProfileGridTypeSelectionSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Consumer<ProfileProvider>(
          builder: (BuildContext context, ProfileProvider userPro, _) {
        return SizedBox(
          height: 64,
          child: Row(
            children: <Widget>[
              Expanded(
                child: _IconButton(
                  isSelected: userPro.displayType == 0,
                  icon: Icons.grid_on,
                  title: 'my-store'.tr(),
                  onPressed: () => userPro.displayType = 0,
                ),
              ),
              Expanded(
                child: _IconButton(
                  isSelected: userPro.displayType == 1,
                  icon: Icons.video_collection_outlined,
                  title: 'my-promos'.tr(),
                  onPressed: () => userPro.displayType = 1,
                ),
              ),
              Expanded(
                child: _IconButton(
                  icon: Icons.calendar_month_outlined,
                  isSelected: userPro.displayType == 2,
                  title: 'my-viewing'.tr(),
                  onPressed: () => userPro.displayType = 2,
                ),
              ),
              Expanded(
                child: _IconButton(
                  icon: Icons.bookmark_border,
                  isSelected: userPro.displayType == 3,
                  title: 'my-saved'.tr(),
                  onPressed: () => userPro.displayType = 3,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onPressed,
  });
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            icon,
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
          ),
          Text(title),
        ],
      ),
    );
  }
}
