import 'package:flutter/material.dart';

import '../../../domain/entities/user_entity.dart';

class ProfilePromoGridview extends StatelessWidget {
  const ProfilePromoGridview({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Promo Gridview'));
  }
}
