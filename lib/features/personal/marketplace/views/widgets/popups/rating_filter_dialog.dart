// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/marketplace_provider.dart';

// class RatingFilterDialog extends StatefulWidget {
//   const RatingFilterDialog({super.key});

//   @override
//   State<RatingFilterDialog> createState() => _RatingFilterDialogState();
// }

// class _RatingFilterDialogState extends State<RatingFilterDialog> {
//   @override
//   Widget build(BuildContext context) {
//     MarketPlaceProvider pro = Provider.of(context, listen: false);
//     return AlertDialog(
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: List.generate(5, (int index) {
//           int rating = index + 1;
//           return ListTile(
//             title: Text('$rating Stars'),
//             onTap: () {
//               pro.setRating(rating);
//               Navigator.pop(context);
//             },
//           );
//         }),
//       ),
//     );
//   }
// }
