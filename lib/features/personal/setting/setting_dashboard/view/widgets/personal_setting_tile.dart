import 'package:flutter/material.dart';
import '../../../../../../core/widgets/custom_svg_icon.dart';

class PersonalSettingTile extends StatelessWidget {
  const PersonalSettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.displayTrailingIcon = true,
    this.iconColor,
    this.textColor,
    this.bgColor,
    super.key,
  });
  final String icon;
  final String title;
  final VoidCallback onTap;
  final bool displayTrailingIcon;
  final Color? iconColor;
  final Color? textColor;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 16,
              backgroundColor: bgColor ?? Theme.of(context).dividerColor,
              child: CustomSvgIcon(
                assetPath: icon,
                color: iconColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextTheme.of(context)
                    .bodyMedium
                    ?.copyWith(color: textColor),
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
