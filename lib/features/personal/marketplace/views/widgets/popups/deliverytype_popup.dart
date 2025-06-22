// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../../../core/enums/listing/core/delivery_type.dart';
// import '../../providers/marketplace_provider.dart';

// class DeliveryTypeFilterDialog extends StatefulWidget {
//   const DeliveryTypeFilterDialog({super.key});

//   @override
//   State<DeliveryTypeFilterDialog> createState() =>
//       _DeliveryTypeFilterDialogState();
// }

// class _DeliveryTypeFilterDialogState extends State<DeliveryTypeFilterDialog> {
//   @override
//   Widget build(BuildContext context) {
//     MarketPlaceProvider pro = Provider.of(context, listen: false);
//     return AlertDialog(
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: DeliveryType.values.map((DeliveryType deliveryType) {
//           return ListTile(
//             title: Text(deliveryType.code),
//             onTap: () {
//               pro.setDeliveryType(deliveryType);
//               Navigator.pop(context);
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
