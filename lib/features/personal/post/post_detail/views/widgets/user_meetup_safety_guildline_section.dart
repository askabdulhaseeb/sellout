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
          'your_safety_matters_to_us',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ).tr(),
        const SizedBox(height: 6),
        const _Point('only_meet_in_public_places'),
        const _Point('never_go_alone_to_meet_seller'),
        const _Point('always_let_someone_know'),
        const _Point('check_and_inspect_items'),
        const _Point('report_any_suspicious_activity'),
        const _Point('never_pay_in_advance'),
        const _Point('always_ask_for_receipt'),
        const _Point('always_tranfer_money_within_sellout'),
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
