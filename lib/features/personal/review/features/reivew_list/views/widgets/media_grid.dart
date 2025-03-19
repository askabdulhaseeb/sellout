// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'dart:typed_data';
// import '../../../../../../attachment/domain/entities/picked_attachment.dart';
// import '../providers/review_provider.dart';

// class MediaGridWidget extends StatelessWidget {
//   const MediaGridWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<ReviewProvider>();
//     final colorScheme = Theme.of(context).colorScheme;

//     return Expanded(
//       child: provider.attachments.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 4,
//                 mainAxisSpacing: 4,
//                 childAspectRatio: 1, // Forces square shape
//               ),
//               itemCount: provider.attachments.length, // Fix: Set item count
//               itemBuilder: (context, index) {
//                 final asset = provider.attachments[index];
//                 final isSelected = provider.selectedMedia.contains(asset); // ✅ Fix

//                 return GestureDetector(
//                   onTap: () => provider.toggleMediaSelection(asset), // ✅ Fix
//                   child: Stack(
//                     children: [
//                       FutureBuilder<Uint8List?>(
//                         future: asset.thumbnaildata(const ThumbnailSize(150, 150)), // ✅ Fix
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return const Center(child: CircularProgressIndicator());
//                           }
//                           if (snapshot.hasData) {
//                             return ClipRRect(
//                               borderRadius: BorderRadius.circular(10), // Smooth rounded corners
//                               child: Image.memory(
//                                 snapshot.data!,
//                                 width: double.infinity,
//                                 height: double.infinity,
//                                 fit: BoxFit.cover, // Makes images fill the square space
//                               ),
//                             );
//                           }
//                           return const Center(child: Text('Error loading image'));
//                         },
//                       ),
//                       if (isSelected)
//                         Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(color: colorScheme.primary, width: 4),
//                             color: colorScheme.primary.withAlpha(100),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
