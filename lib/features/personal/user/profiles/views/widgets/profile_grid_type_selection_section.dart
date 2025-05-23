import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../enums/profile_page_tab_type.dart';
import '../providers/profile_provider.dart';

class ProfileGridTypeSelectionSection extends StatelessWidget {
  const ProfileGridTypeSelectionSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final bool isMe = (LocalAuth.uid ?? '') == (user?.uid ?? '-');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Consumer<ProfileProvider>(
          builder: (BuildContext context, ProfileProvider userPro, _) {
        final List<ProfilePageTabType> list = ProfilePageTabType.list(isMe);
        return SizedBox(
          height: 32,
          width: double.infinity,
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final ProfilePageTabType type = list[index];
              return _IconButton(
                isSelected: userPro.displayType == type,
                title: type.code.tr(),
                onPressed: () => userPro.displayType = type,
              );
            },
          ),
        );
      }),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.title,
    required this.isSelected,
    required this.onPressed,
  });
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
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Container(
            height: 2,
            width: 68,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor
                  : Theme.of(context).dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}
