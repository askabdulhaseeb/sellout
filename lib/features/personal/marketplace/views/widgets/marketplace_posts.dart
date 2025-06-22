// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import '../../../../../core/enums/listing/core/listing_type.dart';
// import '../../../post/domain/entities/post_entity.dart';
// import '../../../user/profiles/views/widgets/subwidgets/post_grid_view_tile.dart';
// import '../providers/marketplace_provider.dart';
// import 'package:provider/provider.dart';
// import 'marketplace_custom_gridview.dart';

// class ExploreProductsGridview extends StatefulWidget {
//   const ExploreProductsGridview({required this.showPersonal, super.key});
//   final bool showPersonal;
//   @override
//   ExploreProductsGridviewState createState() => ExploreProductsGridviewState();
// }

// class ExploreProductsGridviewState extends State<ExploreProductsGridview> {
//   @override
//   void initState() {
//     super.initState();
//     final MarketPlaceProvider pro =
//         Provider.of<MarketPlaceProvider>(context, listen: false);
//     if (pro.posts.isEmpty) {
//       // pro.getFeed();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MarketPlaceProvider>(
//       builder: (BuildContext context, MarketPlaceProvider controller, _) {
//         final List<PostEntity> filteredFeed = widget.showPersonal
//             ? controller.getPersonalPosts().toSet().toList()
//             : controller.getBusinessPosts().toSet().toList();

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             /// Static Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   widget.showPersonal ? 'personal'.tr() : 'business'.tr(),
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 if (filteredFeed.length > 6)
//                   _SeeAllButton(
//                     showAll: controller.showAll,
//                     onPressed: controller.toggleShowAll,
//                   ),
//               ],
//             ),
//             _MarketplaceChoiceChipsection(),
//             if (filteredFeed.isEmpty)
//               Center(
//                 child: Text(
//                   'no_items_available'.tr(),
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//               )
//             else
//               CustomMarketplaceGridView<PostEntity>(
//                 items: filteredFeed.take(6).toList(),
//                 itemBuilder: (BuildContext context, PostEntity item) =>
//                     PostGridViewTile(post: item),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _MarketplaceChoiceChipsection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 40,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: ListingType.list.length,
//         itemBuilder: (BuildContext context, int index) {
//           final String label = ListingType.list[index].json;
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 6),
//             child: ChoiceChip(
//               label: Text(label.tr()),
//               selected: false,
//               onSelected: (_) {},
//               side: BorderSide(
//                 color: Theme.of(context).colorScheme.outlineVariant,
//               ),
//               backgroundColor: Theme.of(context).colorScheme.surface,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class _SeeAllButton extends StatelessWidget {
//   const _SeeAllButton({
//     required this.showAll,
//     required this.onPressed,
//   });
//   final bool showAll;
//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: onPressed,
//       child: Text(
//         showAll ? 'see_less'.tr() : 'see_all'.tr(),
//         style: TextStyle(
//           color: Theme.of(context).colorScheme.primary,
//         ),
//       ),
//     );
//   }
// }
