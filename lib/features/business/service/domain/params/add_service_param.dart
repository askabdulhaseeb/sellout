import '../../../../../core/enums/business/services/service_category_type.dart';
import '../../../../../core/enums/business/services/service_model_type.dart';
import '../../../../attachment/domain/entities/picked_attachment.dart';

class AddServiceParam {
  AddServiceParam({
    required this.name,
    required this.category,
    required this.type,
    required this.model,
    required this.hours,
    required this.mints,
    required this.businessID,
    required this.price,
    required this.currency,
    required this.description,
    required this.included,
    required this.excluded,
    required this.attachments,
    required this.isMobile,
  });

  final String name;
  final ServiceCategoryType? category;
  final ServiceType? type;
  final ServiceModelType? model;
  final int? hours;
  final int? mints;
  final String businessID;
  final String price;
  final String currency;
  final String description;
  final String included;
  final String excluded;
  final List<PickedAttachment> attachments;
  final bool isMobile;

  Map<String, String> toMap() {
    return <String, String>{
      'service_name': name.trim(),
      'service_category': category?.json ?? '',
      'service_type': type?.json ?? '',
      'service_model': model?.json ?? '',
      'business_id': businessID,
      'time': (((hours ?? 0) * 60) + (mints ?? 0)).toString(),
      'price': price,
      'currency': 'gbp',
      'start_at': 'true',
      'mobile_service': isMobile ? 'true' : 'false',
      'description': description.trim(),
      'included_in_service': included.trim(),
      'not_included_in_service': excluded.trim(),
      'employee_ids': '[]'
    };
  }
}
