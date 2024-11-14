import 'package:flutter/material.dart';

import '../../../../../../core/widgets/shadow_container.dart';

class PersonalSettingTile extends StatelessWidget {
  const PersonalSettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.displayTrailingIcon = true,
    this.iconColor,
    this.textColor,
    super.key,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool displayTrailingIcon;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ShadowContainer(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).dividerColor,
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Text(title, style: TextStyle(color: textColor)),
            const Spacer(),
            if (displayTrailingIcon)
              const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
