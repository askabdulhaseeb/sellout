// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../post/domain/entities/post_entity.dart';
// import '../../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
// import '../../providers/marketplace_provider.dart';
// import '../../widgets/tabbarviews/rent_tabbar.dart';
// import '../../widgets/tabbarviews/sale_tabbar.dart';

// class ExplorePropertyScreen extends StatefulWidget {
//   const ExplorePropertyScreen({
//     super.key,
//   });
//   static const String routeName = '/explore-property';

//   @override
//   State<ExplorePropertyScreen> createState() => _ExplorePropertyScreenState();
// }

// class _ExplorePropertyScreenState extends State<ExplorePropertyScreen> {
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
//                   Text('property'.tr(), style: textTheme.titleMedium),
//                   Text(
//                       '${'find_perfect'.tr()} ${'property'.tr()}${'items'.tr()}',
//                       style: textTheme.bodySmall),
//                   const SizedBox(height: 10),
//                   DefaultTabController(
//                     length: 2,
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(4),
//                               border: Border.all(
//                                   color: colorScheme.outlineVariant)),
//                           padding: const EdgeInsets.all(2),
//                           child: TabBar(
//                             padding: const EdgeInsets.all(0),
//                             labelPadding: const EdgeInsets.all(0),
//                             indicatorSize: TabBarIndicatorSize.tab,
//                             dividerColor: Colors.transparent,
//                             indicator: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(4),
//                                 border: Border.all(color: colorScheme.primary)),
//                             tabs: <Widget>[
//                               Tab(text: 'sale'.tr()),
//                               Tab(text: 'rent'.tr()),
//                             ],
//                             onTap: (int index) {
//                               pro.updatepropertySelectedTab(index);
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           height: 275,
//                           child: TabBarView(children: <Widget>[
//                             SalePropertyWidget(
//                                 pro: pro,
//                                 textTheme: textTheme,
//                                 colorScheme: colorScheme),
//                             RentPropertyTabbar(
//                                 pro: pro,
//                                 textTheme: textTheme,
//                                 colorScheme: colorScheme),
//                           ]),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Consumer<MarketPlaceProvider>(
//               builder: (BuildContext context, MarketPlaceProvider provider,
//                   Widget? child) {
//                 final List<PostEntity> salePosts =
//                     provider.saleCategoryFilteredList.toSet().toList();
//                 final List<PostEntity> rentPosts =
//                     provider.rentCategoryFilteredList.toSet().toList();

//                 return provider.selectedpropertyTab == 0
//                     ? GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           mainAxisSpacing: 8,
//                           crossAxisSpacing: 8,
//                           childAspectRatio: 0.75,
//                         ),
//                         itemCount: salePosts.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           final PostEntity post = salePosts[index];
//                           return PostGridViewTile(post: post);
//                         },
//                       )
//                     : GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           mainAxisSpacing: 8,
//                           crossAxisSpacing: 8,
//                           childAspectRatio: 0.75,
//                         ),
//                         itemCount: rentPosts.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           final PostEntity post = rentPosts[index];
//                           return PostGridViewTile(post: post);
//                         },
//                       );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
