import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';

class ProfileScoreSection extends StatelessWidget {
  const ProfileScoreSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
          height: 32,
          child: Row(
            children: <Widget>[
              Expanded(
                child: _ScoreButton(
                  title: 'my_orders'.tr(),
                  count: '',
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: _ScoreButton(
                  title: 'supporting'.tr(),
                  count: (user?.supporters.length ?? 0).toString(),
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: _ScoreButton(
                  title: 'supporters'.tr(),
                  count: (user?.supporters.length ?? 0).toString(),
                  onPressed: () {},
                ),
              ),
            ],
          )),
    );
  }
}

class _ScoreButton extends StatelessWidget {
  const _ScoreButton({
    required this.title,
    required this.count,
    required this.onPressed,
  });
  final String title;
  final String count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).disabledColor,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                count,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
