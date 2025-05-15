import 'package:flutter/material.dart';

class HomePromoListSection extends StatelessWidget {
  const HomePromoListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}
