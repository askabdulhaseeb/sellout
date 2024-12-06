import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UserMeetupSafetyGuildlineSection extends StatelessWidget {
  const UserMeetupSafetyGuildlineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          'your-safety-matters-to-us',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ).tr(),
        const SizedBox(height: 6),
        const _Point('only-meet-in-public-places'),
        const _Point('never-go-alone-to-meet-seller'),
        const _Point('always-let-someone-know'),
        const _Point('check-and-inspect-items'),
        const _Point('report-any-suspicious-activity'),
        const _Point('never-pay-in-advance'),
        const _Point('always-ask-for-receipt'),
        const _Point('always-tranfer-money-within-sellout'),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _Point extends StatelessWidget {
  const _Point(this.point);
  final String point;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Opacity(
        opacity: 0.6,
        child: Text(
          '• ${point.tr()}', // Starting with Bullet point • ◉
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
      ),
    );
  }
}
