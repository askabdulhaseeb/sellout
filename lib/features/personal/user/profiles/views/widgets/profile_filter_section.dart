import 'package:flutter/material.dart';

import '../../data/models/user_model.dart';

class ProfileFilterSection extends StatelessWidget {
  const ProfileFilterSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.blue,
      child: const Center(
        child: Text('Profile Filter Section'),
      ),
    );
  }
}
