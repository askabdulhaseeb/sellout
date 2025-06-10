
import '../../../../attachment/domain/entities/picked_attachment.dart';

class CreatePromoParams{
   CreatePromoParams({
    required this.referenceType,
    required this.referenceID,
    required this.title,
    required this.price,
    required this.attachments,
  }); 
  final String referenceType;
  final String referenceID;
  final String title;
  final String price;
  final List<PickedAttachment> attachments;

  Map<String, String> toMap() {
    return <String, String>{
      'reference_type': referenceType,
      'reference_id': referenceID,
      'title': title,
      'price': price,
    };
  }
  }