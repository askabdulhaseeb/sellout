// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/marketplace_provider.dart';

// class PriceRangeWidget extends StatefulWidget {
//   const PriceRangeWidget({super.key});

//   @override
//   PriceRangeWidgetState createState() => PriceRangeWidgetState();
// }

// class PriceRangeWidgetState extends State<PriceRangeWidget> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final TextTheme textTheme = Theme.of(context).textTheme;
//     final MarketPlaceProvider pro = Provider.of<MarketPlaceProvider>(context);

//     return Form(
//       key: _formKey, // 🔹 Assign GlobalKey to the form
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: DropdownButtonFormField<double>(
//               icon: const Icon(Icons.keyboard_arrow_down_rounded),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               hint: Text(
//                 'minimum_price'.tr(),
//                 style: textTheme.bodySmall,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               value: pro.minPrice,
//               isExpanded: true,
//               onChanged: (double? newValue) {
//                 setState(() {
//                   pro.setMinPrice(newValue);
//                   _formKey.currentState!.validate(); // 🔹 Revalidate
//                 });
//               },
//               items: pro.priceOptions.map((double option) {
//                 return DropdownMenuItem<double>(
//                   value: option,
//                   child: Text(option.toString()),
//                 );
//               }).toList(),
//               validator: (double? value) {
//                 if (value == null) {
//                   return 'Please select a minimum price';
//                 }
//                 return null;
//               },
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: DropdownButtonFormField<double>(
//               icon: const Icon(Icons.keyboard_arrow_down_rounded),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               hint: Text(
//                 'maximum_price'.tr(),
//                 style: textTheme.bodySmall,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               value: pro.maxPrice,
//               isExpanded: true,
//               onChanged: (double? newValue) {
//                 setState(() {
//                   pro.setMaxPrice(newValue);
//                   _formKey.currentState!.validate(); // 🔹 Revalidate
//                 });
//               },
//               items: pro.priceOptions.map((double option) {
//                 return DropdownMenuItem<double>(
//                   value: option,
//                   child: Text(option.toString()),
//                 );
//               }).toList(),
//               validator: (double? value) {
//                 if (value == null) {
//                   return 'Please select a maximum price';
//                 }
//                 if (value < (pro.minPrice ?? 0)) {
//                   return 'Maximum price cannot be less than minimum price';
//                 }
//                 return null;
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
