import 'package:flutter/material.dart';

class ProfileScoreSection extends StatelessWidget {
  const ProfileScoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.yellow,
      child: const Center(
        child: Text('Profile Score Section'),
      ),
    );
  }
}
