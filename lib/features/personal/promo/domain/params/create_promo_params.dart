import 'package:flutter/foundation.dart'; // for debugPrint
import '../../../../attachment/domain/entities/picked_attachment.dart';

class CreatePromoParams {
  CreatePromoParams({
    required this.referenceType,
    required this.referenceID,
    required this.title,
    required this.price,
    required this.attachments,
    required this.thumbNail,
  });

  final String referenceType;
  final String referenceID;
  final String title;
  final String price;
  final PickedAttachment? attachments;
  final PickedAttachment? thumbNail;

  Map<String, String> toMap() {
    final Map<String, String> map = <String, String>{
      if (referenceID.isNotEmpty) 'reference_type': referenceType.trim(),
      if (referenceID.isNotEmpty) 'reference_id': referenceID.trim(),
      'title': title.trim(),
      'price': price.trim(),
    };

    // ✅ Debug print for map and file paths
    debugPrint('👉 CreatePromoParams - toMap: $map');
    debugPrint('👉 Attachment path: ${attachments?.file.path}');
    debugPrint('👉 Thumbnail path: ${thumbNail?.file.path}');

    return map;
  }
}
