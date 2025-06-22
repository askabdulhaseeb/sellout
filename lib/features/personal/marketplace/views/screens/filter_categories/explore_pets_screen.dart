// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../../../core/widgets/costom_textformfield.dart';
// import '../../../../../../core/widgets/custom_elevated_button.dart';
// import '../../../../post/domain/entities/post_entity.dart';
// import '../../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
// import '../../providers/marketplace_provider.dart';
// import '../../widgets/price_range_widget.dart';

// class ExplorePetsScreen extends StatefulWidget {
//   const ExplorePetsScreen({
//     super.key,
//   });
//   static const String routeName = '/explore-pets';

//   @override
//   State<ExplorePetsScreen> createState() => _ExplorePetsScreenState();
// }

// class _ExplorePetsScreenState extends State<ExplorePetsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final ColorScheme colorScheme = Theme.of(context).colorScheme;
//     final TextTheme textTheme = Theme.of(context).textTheme;
//     final MarketPlaceProvider pro = Provider.of<MarketPlaceProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: 140,
//         leading: TextButton.icon(
//           style: TextButton.styleFrom(
//               foregroundColor: colorScheme.onSurfaceVariant),
//           icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurfaceVariant),
//           onPressed: () => Navigator.pop(context),
//           label: Text('go_back'.tr()),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: <Widget>[
//             Container(
//               padding: const EdgeInsets.all(8),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 border: Border.all(color: colorScheme.outline),
//               ),
//               child: Column(
//                 children: <Widget>[
//                   Text('pets'.tr(), style: textTheme.titleMedium),
//                   Text('${'find_perfect'.tr()} ${'pets'.tr()}',
//                       style: textTheme.bodySmall),
//                   const SizedBox(height: 10),
//                   CustomTextFormField(
//                     controller: pro.searchController,
//                     hint: 'search'.tr(),
//                     // onChanged: (String value) =>
//                     //     MarketPlaceProvider.filterBySearchQuery(value),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           icon: const Icon(Icons.keyboard_arrow_down_rounded),
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10))),
//                           hint: Text(
//                             'category'.tr(),
//                             style: textTheme.bodySmall,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           value: pro.selectedcategorypet,
//                           isExpanded: true,
//                           onChanged: (String? newValue) =>
//                               pro.setpetcategory(newValue),
//                           items: pro.getpetscategory().map((String? delivery) {
//                             return DropdownMenuItem<String>(
//                               value: delivery,
//                               child: Text(delivery!),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           icon: const Icon(Icons.keyboard_arrow_down_rounded),
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10))),
//                           hint: Text(
//                             overflow: TextOverflow.ellipsis,
//                             'ready_to_leave'.tr(),
//                             style: textTheme.bodySmall,
//                           ),
//                           value: pro.selectedreadytoleavepet,
//                           isExpanded: true,
//                           onChanged: (String? newValue) =>
//                               pro.setpetreadytoleave(newValue),
//                           items: pro.getpetreadytoleave().map((String? option) {
//                             return DropdownMenuItem<String>(
//                               value: option,
//                               child: Text('$option'),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           icon: const Icon(Icons.keyboard_arrow_down_rounded),
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10))),
//                           hint: Text(
//                             'age'.tr(),
//                             style: textTheme.bodySmall,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           value: pro.selectedagepet,
//                           isExpanded: true,
//                           onChanged: (String? newValue) =>
//                               pro.setpetage(newValue),
//                           items: pro.getpetsage().map((String? delivery) {
//                             return DropdownMenuItem<String>(
//                               value: delivery,
//                               child: Text(delivery!),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   const PriceRangeWidget(),
//                   const SizedBox(height: 10),
//                   CustomElevatedButton(
//                       isLoading: false,
//                       onTap: () {
//                         pro.applypetFilter();
//                         debugPrint(
//                             'filtered list:${pro.petCategoryFilteredList}');
//                       },
//                       title: 'search'.tr()),
//                   const SizedBox(width: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: <Widget>[
//                       TextButton(
//                           onPressed: () => pro.resetFilters(),
//                           child: Text(
//                             'reset'.tr(),
//                             style: TextStyle(
//                               decorationColor: colorScheme.outlineVariant,
//                               decoration: TextDecoration.underline,
//                               color: colorScheme.outlineVariant,
//                             ),
//                           )),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Consumer<MarketPlaceProvider>(
//               builder: (BuildContext context, MarketPlaceProvider provider,
//                   Widget? child) {
//                 final List<PostEntity> petsposts =
//                     provider.petsCategoryFIlteredList.toSet().toList();
//                 return GridView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 8,
//                     crossAxisSpacing: 8,
//                     childAspectRatio: 0.75,
//                   ),
//                   itemCount: petsposts.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     final PostEntity post = petsposts[index];
//                     return PostGridViewTile(post: post);
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
