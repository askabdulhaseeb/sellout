import 'package:hive/hive.dart';

import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../business/core/domain/entity/business_employee_entity.dart';
import '../../data/models/address_model.dart';
import 'login_detail_entity.dart';
part 'current_user_entity.g.dart';

@HiveType(typeId: 0)
class CurrentUserEntity {
  CurrentUserEntity(
      {required this.message,
      required this.token,
      required this.userID,
      //
      required this.email,
      required this.userName,
      required this.displayName,
      required this.currency,
      required this.privacy,
      required this.countryAlpha3,
      required this.countryCode,
      required this.phoneNumber,
      required this.language,
      //
      required this.address,
      //
      required this.chatIDs,
      required this.businessIDs,
      //
      required this.imageVerified,
      required this.verificationImage,
      required this.profileImage,
      //
      required this.lastLoginTime,
      required this.createdAt,
      required this.inHiveAt,
      // New fields added for business logic
      required this.businessStatus,
      required this.businessName,
      required this.businessID,
      //
      required this.logindetail,
      required this.employeeList,
      //
      required this.twoStepAuthEnabled});

  @HiveField(1)
  final String message;
  @HiveField(2)
  final String token;
  @HiveField(3)
  final String userID;
  //
  @HiveField(11)
  final String email;
  @HiveField(12)
  final String userName;
  @HiveField(13)
  final String displayName;
  @HiveField(14)
  final String? currency;
  @HiveField(15)
  final PrivacyType privacy;
  @HiveField(16)
  final String countryAlpha3;
  @HiveField(17)
  final String countryCode;
  @HiveField(18)
  final String phoneNumber;
  @HiveField(19)
  final String language;
  //
  @HiveField(21)
  final List<AddressEntity> address;
  //
  @HiveField(31)
  final List<String> chatIDs;
  @HiveField(32)
  final List<String> businessIDs;
  //
  @HiveField(41)
  final bool imageVerified;
  @HiveField(42)
  final AttachmentEntity? verificationImage;
  @HiveField(43)
  List<AttachmentEntity> profileImage;
  //
  @HiveField(97)
  final DateTime lastLoginTime;
  @HiveField(98)
  final DateTime createdAt;
  @HiveField(99)
  final DateTime inHiveAt;

  // Business-specific fields
  @HiveField(120, defaultValue: null)
  final String? businessStatus; // **New field**
  @HiveField(121, defaultValue: null)
  final String? businessName; // **New field**
  @HiveField(122, defaultValue: null)
  final String? businessID; // **New field**
  @HiveField(123)
  final LoginDetailEntity logindetail; // **New field**
  @HiveField(124)
  final List<BusinessEmployeeEntity> employeeList; // **New field**
  @HiveField(135)
  final bool? twoStepAuthEnabled;

  // this is a Copy function to copy the current object and return a new object with old token
  CurrentUserEntity copyWith({
    String? token,
    List<AddressEntity>? address,
    bool? twoStepAuthEnabled,
  }) {
    return CurrentUserEntity(
      userName: userName,
      message: message,
      email: email,
      token: token ?? this.token,
      displayName: displayName,
      userID: userID,
      chatIDs: chatIDs,
      address: address ?? this.address,
      businessIDs: businessIDs,
      currency: currency,
      imageVerified: imageVerified,
      verificationImage: verificationImage,
      profileImage: profileImage,
      privacy: privacy,
      countryAlpha3: countryAlpha3,
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      language: language,
      lastLoginTime: lastLoginTime,
      createdAt: createdAt,
      inHiveAt: inHiveAt,
      businessStatus: businessStatus,
      businessName: businessName,
      businessID: businessID,
      logindetail: logindetail,
      employeeList: employeeList,
      twoStepAuthEnabled: twoStepAuthEnabled,
    );
  }
}
