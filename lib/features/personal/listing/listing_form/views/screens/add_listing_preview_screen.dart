// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../../../core/widgets/custom_toggle_switch.dart';
// import '../../../../post/domain/entities/post/post_entity.dart';
// import '../../../../post/feed/views/widgets/post/widgets/home_post_tile.dart';
// import '../../../../post/post_detail/views/widgets/post_details_sections/item_post_detail_section.dart';
// import '../providers/add_listing_form_provider.dart';

// class AddListingPreviewScreen extends StatefulWidget {
//   const AddListingPreviewScreen({super.key});

//   @override
//   State<AddListingPreviewScreen> createState() =>
//       _AddListingPreviewScreenState();
// }

// class _AddListingPreviewScreenState extends State<AddListingPreviewScreen> {
//   int _previewMode = 0;

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('listing_preview'.tr()),
//           centerTitle: true,
//           elevation: 2,
//         ),
//         body: Consumer<AddListingFormProvider>(
//           builder: (BuildContext context, AddListingFormProvider provider, _) {
//             final PostEntity? previewPost = provider.createPostFromFormData();
//             if (previewPost == null) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             return SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   const SizedBox(height: 16),
//                   CustomToggleSwitch<int>(
//                     initialValue: _previewMode,
//                     labels: const <int>[0, 1],
//                     labelStrs: <String>[
//                       'feed_preview'.tr(),
//                       'detail_preview'.tr()
//                     ],
//                     labelText: '',
//                     onToggle: (int index) {
//                       setState(() {
//                         _previewMode = index;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   _previewMode == 0
//                       ? AbsorbPointer(child: HomePostTile(post: previewPost))
//                       : AbsorbPointer(
//                           child: ItemPostDetailSection(
//                             post: previewPost,
//                           ),
//                         ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
