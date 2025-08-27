// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../../../core/theme/app_theme.dart';
// import '../../../../../../core/utilities/app_string.dart';
// import '../../../../../../core/widgets/in_dev_mode.dart';
// import '../../providers/cart_provider.dart';

// class CheckoutPaymentMethodSection extends StatefulWidget {
//   const CheckoutPaymentMethodSection({super.key});

//   @override
//   State<CheckoutPaymentMethodSection> createState() =>
//       _CheckoutPaymentMethodSectionState();
// }

// class _CheckoutPaymentMethodSectionState
//     extends State<CheckoutPaymentMethodSection> {
//   int? selectedIndex;

//   final List<Map<String, String>> paymentMethods = <Map<String, String>>[
//     <String, String>{'image': AppStrings.mastercard, 'title': 'master_card'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // final CartProvider pro = Provider.of<CartProvider>(context, listen: false);
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: <Widget>[
//           SizedBox(
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: paymentMethods.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final Map<String, String> method = paymentMethods[index];
//                 final bool isSelected = selectedIndex == index;
//                 return ListTile(
//                   contentPadding: const EdgeInsets.all(0),
//                   onTap: () {
//                     setState(() {
//                       selectedIndex = index;
//                     });
//                   },
//                   leading: Checkbox(
//                     activeColor: Colors.red,
//                     value: isSelected,
//                     onChanged: (_) {
//                       setState(() {
//                         selectedIndex = index;
//                       });
//                     },
//                   ),
//                   title: Row(
//                     children: <Widget>[
//                       Image.asset(method['image']!, width: 30),
//                       const SizedBox(width: 12),
//                       Text(method['title']!.tr()),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 12),
//           InDevMode(
//             child: TextButton.icon(
//               onPressed: () {},
//               icon: const Icon(
//                 Icons.add_circle_outline,
//                 color: AppTheme.primaryColor,
//               ),
//               label: const Text('add_new_card'),
//               style: TextButton.styleFrom(
//                 elevation: 0,
//                 backgroundColor: AppTheme.primaryColor.withAlpha(0x33),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           // CustomElevatedButton(
//           //   onTap: () async {
//           //     if (selectedIndex == null) {
//           //       ScaffoldMessenger.of(context).showSnackBar(
//           //         const SnackBar(content: Text('')),
//           //       );
//           //       return;
//           //     }

//           //     try {
//           //       // On success:
//           //       showModalBottomSheet(
//           //         context: context,
//           //         isScrollControlled: true,
//           //         shape: const RoundedRectangleBorder(
//           //           borderRadius:
//           //               BorderRadius.vertical(top: Radius.circular(20)),
//           //         ),
//           //         builder: (_) => const PaymentSuccessSheet(),
//           //       );
//           //     } catch (e) {
//           //       ScaffoldMessenger.of(context).showSnackBar(
//           //         SnackBar(
//           //           content: Text('${'payment_failed'.tr()}: ${e.toString()}'),
//           //           backgroundColor: ColorScheme.of(context).error,
//           //         ),
//           //       );
//           //     }
//           //   },
//           //   title: 'start_payment'.tr(),
//           //   isLoading: false,
//           // ),
//         ],
//       ),
//     );
//   }
// }
