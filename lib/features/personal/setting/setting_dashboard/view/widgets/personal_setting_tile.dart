import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(6)),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).dividerColor,
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: textColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (displayTrailingIcon)
              const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
