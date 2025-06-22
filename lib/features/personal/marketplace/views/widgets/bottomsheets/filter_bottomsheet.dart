// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../../../core/widgets/custom_elevated_button.dart';
// import '../../providers/marketplace_provider.dart';
// import '../popups/condition_popup.dart';
// import '../popups/deliverytype_popup.dart';
// import '../popups/price_range_popup.dart';
// import '../popups/rating_filter_dialog.dart';

// class FilterBottomSheet extends StatelessWidget {
//   const FilterBottomSheet({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Access the MarketPlaceProvider for state management
//     final MarketPlaceProvider marketPlaceProvider =
//         Provider.of<MarketPlaceProvider>(context, listen: false);

//     return BottomSheet(
//       onClosing: () {},
//       builder: (BuildContext context) {
//         return Scaffold(
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             centerTitle: true,
//             title: Text('filter'.tr()),
//             actions: <Widget>[
//               TextButton(
//                   onPressed: () {
//                     marketPlaceProvider.resetFilters();
//                   },
//                   child: Text('reset'.tr()))
//             ],
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   ListTile(
//                     onTap: () => showDialog(
//                       context: context,
//                       builder: (BuildContext context) =>
//                           const PriceRangePopup(),
//                     ),
//                     title: Text(
//                       'price'.tr(),
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     subtitle: Text('select_price_range'.tr()),
//                     trailing: const Icon(Icons.keyboard_arrow_down_rounded),
//                   ),
//                   const SizedBox(height: 16),
//                   // Rating Filter
//                   ListTile(
//                     onTap: () => showDialog(
//                       context: context,
//                       builder: (BuildContext context) =>
//                           const RatingFilterDialog(),
//                     ),
//                     title: Text(
//                       'review'.tr(),
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     subtitle: Text('select_review'.tr()),
//                     trailing: const Icon(Icons.keyboard_arrow_down_rounded),
//                   ),
//                   const SizedBox(height: 16),
//                   ListTile(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) =>
//                             const ConditionTypeFilterDialog(),
//                       );
//                     },
//                     title: Text(
//                       'Condition',
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     subtitle: Text('select_condition'.tr()),
//                     trailing: const Icon(Icons.keyboard_arrow_down_rounded),
//                   ),
//                   const SizedBox(height: 16),

//                   // Delivery Type Filter (wrapped in ListTile for consistent look)
//                   ListTile(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) =>
//                             const DeliveryTypeFilterDialog(),
//                       );
//                     },
//                     title: Text(
//                       'Delivery Type',
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     subtitle: Text('select_delivery_type'.tr()),
//                     trailing: const Icon(Icons.keyboard_arrow_down_rounded),
//                   ),
//                   const SizedBox(height: 16),

//                   // Apply Button
//                   CustomElevatedButton(
//                     isLoading: false,
//                     onTap: () {
//                       marketPlaceProvider.applypersonalbusinessFilter();
//                       Navigator.pop(context);
//                     },
//                     title: 'apply_filters'.tr(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
