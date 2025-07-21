import 'dart:convert';
import '../../../../../core/extension/string_ext.dart';
import '../../../../attachment/data/attchment_model.dart';
import '../../../../personal/location/data/models/location_model.dart';
import '../../../../personal/user/profiles/data/models/supporter_detail_model.dart';
import '../../../../personal/user/profiles/domain/entities/supporter_detail_entity.dart';
import '../../domain/entity/business_entity.dart';
import 'business_address_model.dart';
import 'business_employee_model.dart';
import 'business_travel_detail_model.dart';
import 'routine_model.dart';

class BusinessModel extends BusinessEntity {
  BusinessModel({
    required super.businessID,
    required super.logo,
    required super.acceptPromotions,
    required super.locationType,
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
    super.supporters,
    super.supportings,
    super.location,
    super.travelDetail,
  });

  factory BusinessModel.fromRawJson(String str) =>
      BusinessModel.fromJson(json.decode(str));
  factory BusinessModel.fromJson(Map<String, dynamic> json) => BusinessModel(
        businessID: json['business_id'],
        location: json['location'] != null
            ? LocationModel.fromJson(json['location'])
            : null,
        logo: (json['profile_pic'] as List<dynamic>?)?.isNotEmpty == true
            ? AttachmentModel.fromJson(json['profile_pic'][0])
            : null,
        acceptPromotions: json['accept_promotions'],
        locationType: json['location_type'],
        travelDetail: json['travel_detail'] != null
            ? BusinessTravelDetailModel.fromJson(json['travel_detail'])
            : null,
        employees: (json['employees'] as List<dynamic>?)
            ?.map((x) => BusinessEmployeeModel.fromJson(x))
            .toList(),
        address: json['address'] != null
            ? (json['address'] is List
                ? (json['address'] as List).isNotEmpty
                    ? BusinessAddressModel.fromJson(json['address'][0])
                    : null
                : BusinessAddressModel.fromJson(json['address']))
            : null,
        displayName: json['display_name'],
        ownerID: json['owner_id'],
        tagline: json['tagline'],
        phoneNumber: json['phone_number'],
        companyNo: json['company_no'],
        routine: (json['routine'] as List<dynamic>?)
            ?.map((x) => RoutineModel.fromJson(x))
            .toList(),
        listOfReviews: (json['list_of_reviews'] as List<dynamic>?)?.map((x) {
          if (x is int) {
            return x.toDouble();
          } else if (x is double) {
            return x;
          } else {
            return double.tryParse(x.toString()) ?? 0.0;
          }
        }).toList(),
        createdAt: json['created_at']?.toString().toDateTime(),
        updatedAt:
            (json['updated_at'] ?? json['created_at'])?.toString().toDateTime(),
        supporters: (json['supporters'] as List<dynamic>?)
            ?.map((e) => e != null
                ? SupporterDetailModel.fromMap(e).toEntity()
                : <dynamic>[])
            .whereType<SupporterDetailEntity>()
            .toList(),
        supportings: (json['supporting'] as List<dynamic>?)
            ?.map((e) => e != null
                ? SupporterDetailModel.fromMap(e).toEntity()
                : <dynamic>[])
            .whereType<SupporterDetailEntity>()
            .toList(),
      );
}
