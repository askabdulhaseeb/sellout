import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Current Balance',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'PKR 12,345.67',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const Center(
          child: Text(
            'Withdraw options coming soon!',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
