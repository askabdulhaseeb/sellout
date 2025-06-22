// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/marketplace_provider.dart';
// import '../../../../../../core/enums/listing/core/item_condition_type.dart'; // Ensure this import is correct

// class ConditionTypeFilterDialog extends StatelessWidget {
//   const ConditionTypeFilterDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MarketPlaceProvider>(
//       builder:
//           (BuildContext context, MarketPlaceProvider provider, Widget? child) {
//         return AlertDialog(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: ConditionType.values.map((ConditionType condition) {
//               return ListTile(
//                 title: Text(condition.code
//                     .toUpperCase()), // Using code from ConditionType
//                 onTap: () {
//                   provider.setConditionType(
//                       condition); // Set the selected condition type
//                   Navigator.pop(context); // Close the dialog
//                 },
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }
// }
