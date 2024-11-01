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
          height: 64,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: _ScoreButton(
                  title: 'my-orders'.tr(),
                  count: '0',
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: _ScoreButton(
                  title: 'supporting'.tr(),
                  count: '0',
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: _ScoreButton(
                  title: 'supporters'.tr(),
                  count: '0',
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).disabledColor,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                count,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
