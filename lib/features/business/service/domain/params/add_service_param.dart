import 'dart:convert';

import '../../../../../core/enums/business/services/service_category_type.dart';
import '../../../../../core/enums/business/services/service_model_type.dart';
import '../../../../attachment/domain/entities/picked_attachment.dart';

class AddServiceParam {
  AddServiceParam(
      {required this.name, //service name
      required this.category, //service category
      required this.type, //service type
      required this.model, //service model i.e. membership
      required this.hours, //time
      required this.mints, //time
      required this.businessID, //business id
      required this.price, //price
      required this.currency, //currency
      required this.description, //description
      required this.included, //included_in_service
      required this.excluded, //not_included_in_service
      required this.attachments, //files
      required this.isMobile, //mobile_service
      required this.employeeIDs, //employee_ids
      this.serviceID = ''

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
  final List<String> employeeIDs;
  final String serviceID;

  Map<String, String> toMap() {
    return <String, String>{
      'service_name': name.trim(),
      'service_category': category?.json ?? '',
      'service_type': type?.json ?? '',
      'service_model': model?.json ?? '',
      'business_id': businessID,
      'time': (((hours ?? 0) * 60) + (mints ?? 0)).toString(),
      'price': price,
      'currency': currency,
      'start_at': 'true',
      'mobile_service': isMobile ? 'true' : 'false',
      'description': description.trim(),
      'included_in_service': included.trim(),
      'not_included_in_service': excluded.trim(),
    'employee_ids': jsonEncode(employeeIDs),     };
  }
}
