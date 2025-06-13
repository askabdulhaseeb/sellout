
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
     if(referenceID.isNotEmpty)    'reference_type': referenceType.trim(),
     if(referenceID.isNotEmpty) 'reference_id': referenceID.trim(),
      'title': title.trim(),
      'price': price.trim(),
    };
  }
  }