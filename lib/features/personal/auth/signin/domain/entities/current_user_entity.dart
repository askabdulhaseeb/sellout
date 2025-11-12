import 'package:hive/hive.dart';
import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../business/core/domain/entity/business_employee_entity.dart';
import '../../../../location/domain/entities/location_entity.dart';
import '../../../../setting/setting_dashboard/domain/entities/notification_entity.dart';
import '../../../../setting/setting_dashboard/domain/entities/privacy_settings_entity.dart';
import '../../../../setting/setting_dashboard/domain/entities/time_away_entity.dart';
import '../../../../user/profiles/domain/entities/supporter_detail_entity.dart';
import 'address_entity.dart';
import 'login_detail_entity.dart';
import 'login_info_entity.dart';
part 'current_user_entity.g.dart';

@HiveType(typeId: 0)
class CurrentUserEntity {
  // 2FA status

  CurrentUserEntity({
    required this.message,
    required this.token,
    required this.refreshToken,
    required this.userID,
    required this.email,
    required this.userName,
    required this.displayName,
    required this.currency,
    required this.privacy,
    required this.countryAlpha3,
    required this.countryCode,
    required this.phoneNumber,
    required this.language,
    required this.address,
    required this.chatIDs,
    required this.businessIDs,
    required this.imageVerified,
    required this.otpVerified,
    required this.verificationImage,
    required this.profileImage,
    required this.lastLoginTime,
    required this.createdAt,
    required this.updatedAt,
    required this.inHiveAt,
    required this.businessStatus,
    required this.businessName,
    required this.businessID,
    required this.logindetail,
    required this.loginActivity,
    required this.employeeList,
    required this.notification,
    required this.twoStepAuthEnabled,
    required this.supporters,
    required this.supporting,
    required this.privacySettings,
    required this.timeAway,
    required this.accountStatus,
    required this.accountType,
    required this.dob,
    required this.saved,
    required this.listOfReviews,
    required this.location,
  });
  // ──────────────────────────────── BASIC INFO ────────────────────────────────
  @HiveField(1)
  final String message; // Response message (e.g., "Login successful")

  @HiveField(2)
  final String token; // JWT token for authenticated user
  @HiveField(3)
  final String refreshToken; // Token to refresh JWT

  @HiveField(4)
  final String userID; // Unique ID of the user

  @HiveField(5)
  final String email; // User email

  @HiveField(6)
  final String userName; // Username

  @HiveField(7)
  final String displayName; // Full display name

  @HiveField(8)
  final String? currency; // Preferred currency (e.g., PKR, GBP)

  @HiveField(9)
  final PrivacyType privacy; // Profile visibility (public/private)

  @HiveField(16)
  final String countryAlpha3; // Country in Alpha-3 code

  @HiveField(17)
  final String countryCode; // International dialing code

  @HiveField(18)
  final String phoneNumber; // Mobile number

  @HiveField(19)
  final String language; // App language

  // ──────────────────────────────── ACCOUNT INFO ────────────────────────────────
  @HiveField(20)
  final String? accountStatus; // active/suspended/etc.

  @HiveField(22)
  final String? accountType; // personal/business/etc.

  @HiveField(23)
  final DateTime? dob; // Date of Birth

  @HiveField(24)
  final List<String> saved; // IDs of saved items

  @HiveField(25)
  final List<int> listOfReviews; // User reviews/ratings received

  @HiveField(21)
  final List<AddressEntity> address; // Physical addresses

  // ──────────────────────────────── IMAGES ────────────────────────────────
  @HiveField(40)
  List<AttachmentEntity> profileImage; // List of profile pictures

  @HiveField(41)
  final bool imageVerified; // Image verification status

  @HiveField(42)
  final bool otpVerified; // email verification status

  @HiveField(43)
  final AttachmentEntity? verificationImage; // ID/KYC image

  // ──────────────────────────────── DATES ────────────────────────────────
  @HiveField(97)
  final DateTime lastLoginTime; // Last login timestamp

  @HiveField(98)
  final DateTime createdAt; // Account creation timestamp

  @HiveField(99)
  final DateTime updatedAt; // Account update timestamp

  @HiveField(100)
  final DateTime inHiveAt; // When saved in local cache

  // ──────────────────────────────── BUSINESS ────────────────────────────────
  @HiveField(120)
  final String? businessStatus; // Status of user's business

  @HiveField(121)
  final String? businessName; // Business display name

  @HiveField(122)
  final String? businessID; // Main business ID

  @HiveField(125)
  final List<BusinessEmployeeEntity> employeeList; // Employees if business

  @HiveField(32)
  final List<String> businessIDs; // Associated business IDs

  // ──────────────────────────────── LOGIN ────────────────────────────────
  @HiveField(123)
  final LoginDetailEntity logindetail; // personal/business type

  @HiveField(154)
  final List<DeviceLoginInfoEntity> loginActivity; // Device login logs

  @HiveField(155)
  final LocationEntity? location; // device location while loging in

  // ──────────────────────────────── COMMUNICATION ────────────────────────────────
  @HiveField(31)
  final List<String> chatIDs; // Chat thread IDs

  // ──────────────────────────────── SUPPORT ────────────────────────────────
  @HiveField(140)
  List<SupporterDetailEntity> supporters; // Followers of this user

  @HiveField(141)
  List<SupporterDetailEntity> supporting; // Followed by this user

  // ──────────────────────────────── SETTINGS ────────────────────────────────
  @HiveField(150)
  final TimeAwayEntity? timeAway; // Away mode config

  @HiveField(151)
  PrivacySettingsEntity? privacySettings; // Privacy settings

  @HiveField(152)
  final NotificationSettingsEntity? notification; // Notification preferences

  @HiveField(153)
  final bool? twoStepAuthEnabled;

  CurrentUserEntity copyWith(
      {String? token,
      String? refreshToken,
      List<AddressEntity>? address,
      bool? twoStepAuthEnabled,
      List<SupporterDetailEntity>? supporting,
      DateTime? dob,
      String? phoneNumber,
      String? countryCode,
      String? displayName,
      bool? otpVerified,
      TimeAwayEntity? timeAway}) {
    return CurrentUserEntity(
        message: message,
        token: token ?? this.token,
        refreshToken: refreshToken ?? this.refreshToken,
        otpVerified: otpVerified ?? this.otpVerified,
        countryCode: countryCode ?? this.countryCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        displayName: displayName ?? this.displayName,
        address: address ?? this.address,
        supporting: supporting ?? this.supporting,
        dob: dob ?? this.dob,
        userID: userID,
        email: email,
        userName: userName,
        currency: currency,
        privacy: privacy,
        countryAlpha3: countryAlpha3,
        language: language,
        chatIDs: chatIDs,
        businessIDs: businessIDs,
        imageVerified: imageVerified,
        verificationImage: verificationImage,
        profileImage: profileImage,
        lastLoginTime: lastLoginTime,
        createdAt: createdAt,
        updatedAt: updatedAt,
        inHiveAt: inHiveAt,
        businessStatus: businessStatus,
        businessName: businessName,
        businessID: businessID,
        logindetail: logindetail,
        loginActivity: loginActivity,
        employeeList: employeeList,
        notification: notification,
        twoStepAuthEnabled: twoStepAuthEnabled,
        supporters: supporters,
        privacySettings: privacySettings,
        timeAway: timeAway,
        accountStatus: accountStatus,
        accountType: accountType,
        saved: saved,
        listOfReviews: listOfReviews,
        location: location);
  }
}
