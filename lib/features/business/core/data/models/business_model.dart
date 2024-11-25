import 'dart:convert';

import '../../../../../core/extension/string_ext.dart';
import '../../../../attachment/data/attchment_model.dart';
import '../../../../personal/location/data/models/location_model.dart';
import '../../domain/entity/business_entity.dart';
import 'business_address_model.dart';
import 'business_employee_model.dart';
import 'business_travel_detail_model.dart';
import 'routine_model.dart';

class BusinessModel extends BusinessEntity {
  BusinessModel({
    required super.businessID,
    required super.location,
    required super.logo,
    required super.acceptPromotions,
    required super.locationType,
    required super.travelDetail,
    required super.employees,
    required super.address,
    required super.displayName,
    required super.ownerID,
    required super.tagline,
    required super.phoneNumber,
    required super.companyNo,
    required super.routine,
    required super.listOfReviews,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BusinessModel.fromRawJson(String str) =>
      BusinessModel.fromJson(json.decode(str));

  factory BusinessModel.fromJson(Map<String, dynamic> json) => BusinessModel(
        businessID: json['business_id'],
        location: LocationModel.fromJson(json['location']),
        logo: json['profile_pic'] == null ||
                (json['profile_pic'] ?? <dynamic>[]).isEmpty
            ? null
            : (json['profile_pic'] ?? <dynamic>[])
                .map((dynamic x) => AttachmentModel.fromJson(x))
                .toList()
                .first,
        acceptPromotions: json['accept_promotions'],
        locationType: json['location_type'],
        travelDetail: BusinessTravelDetailModel.fromJson(json['travel_detail']),
        employees: List<BusinessEmployeeModel>.from(
            (json['employees'] ?? <dynamic>[])
                .map((dynamic x) => BusinessEmployeeModel.fromJson(x))),
        address: BusinessAddressModel.fromJson(json['address']),
        displayName: json['display_name'],
        ownerID: json['owner_id'],
        tagline: json['tagline'],
        phoneNumber: json['phone_number']?.toString() ?? '',
        companyNo: json['company_no'],
        routine: List<RoutineModel>.from((json['routine'] ?? <dynamic>[])
            .map((dynamic x) => RoutineModel.fromJson(x))),
        listOfReviews: List<double>.from(
          (json['list_of_reviews'] ?? <dynamic>[]).map((dynamic x) {
            if (x is int) {
              return x.toDouble(); // Convert int to double
            } else if (x is double) {
              return x; // Already a double
            } else {
              return double.tryParse(x.toString()) ?? 0.0;
            }
          }),
        ),
        createdAt:
            json['created_at']?.toString().toDateTime() ?? DateTime.now(),
        updatedAt: (json['updated_at'] ?? json['created_at'])
                ?.toString()
                .toDateTime() ??
            DateTime.now(),
      );
}
