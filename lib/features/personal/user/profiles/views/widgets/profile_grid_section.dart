import 'package:flutter/material.dart';

class ProfileGridSection extends StatelessWidget {
  const ProfileGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.green,
      child: const Center(
        child: Text('Profile Grid Section'),
      ),
    );
  }
}
