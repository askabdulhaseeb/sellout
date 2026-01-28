import 'package:flutter/material.dart';
import '../../domain/entities/account_action_type.dart';

class AccountActionCard extends StatelessWidget {
  const AccountActionCard({
    required this.actionType,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final AccountActionType actionType;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDeactivate = actionType == AccountActionType.deactivate;

    final Color primaryColor = isDeactivate
        ? const Color(0xFF4CAF50)
        : const Color(0xFFD32F2F);
    final Color backgroundColor = isDeactivate
        ? const Color(0xFFF8F8F8)
        : const Color(0xFFFFF5F5);
    final Color iconBgColor = isDeactivate
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFEBEE);
    final Color borderColor = isDeactivate
        ? const Color(0xFFE0E0E0)
        : const Color(0xFFFFEBEE);
    final IconData icon = isDeactivate
        ? Icons.pause_circle_outline
        : Icons.delete_outline;
    final String badgeText = isDeactivate ? 'Temporary' : 'Permanent';
    final Color badgeColor = isDeactivate
        ? const Color(0xFFF5A623)
        : const Color(0xFFD32F2F);
    final Color badgeBgColor = isDeactivate
        ? const Color(0xFFFFF3E0)
        : const Color(0xFFFFEBEE);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Icon Container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 24, color: primaryColor),
            ),
            const SizedBox(width: 12),
            // Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title with Badge
                  Row(
                    children: <Widget>[
                      Text(
                        actionType.displayName,
                        style: textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF1A1A1A),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badgeText,
                          style: textTheme.labelSmall?.copyWith(
                            color: badgeColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    actionType.description,
                    style: textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF555555),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Status Badges
                  if (isDeactivate)
                    Row(
                      children: <Widget>[
                        _StatusBadge(
                          icon: Icons.check_circle,
                          text: 'Reversible',
                          color: const Color(0xFF4CAF50),
                        ),
                        const SizedBox(width: 12),
                        _StatusBadge(
                          icon: Icons.verified,
                          text: 'Data preserved',
                          color: const Color(0xFF2196F3),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: <Widget>[
                        _StatusBadge(
                          icon: Icons.dangerous,
                          text: 'Irreversible',
                          color: const Color(0xFFD32F2F),
                        ),
                        const SizedBox(width: 12),
                        _StatusBadge(
                          icon: Icons.delete,
                          text: 'All data deleted',
                          color: const Color(0xFFD32F2F),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
