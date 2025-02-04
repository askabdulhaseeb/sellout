import 'package:hive/hive.dart';

import '../../../../../../core/enums/listing/core/privacy_type.dart';
import '../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../data/models/address_model.dart';
part 'current_user_entity.g.dart';

@HiveType(typeId: 0)
class CurrentUserEntity {
  CurrentUserEntity({
    required this.message,
    required this.token,
    required this.userID,
    //
    required this.email,
    required this.username,
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
  });

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
  final String username;
  @HiveField(13)
  final String? currency;
  @HiveField(14)
  final PrivacyType privacy;
  @HiveField(15)
  final String countryAlpha3;
  @HiveField(16)
  final String countryCode;
  @HiveField(17)
  final String phoneNumber;
  @HiveField(18)
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
  final List<AttachmentEntity> profileImage;
  //
  @HiveField(97)
  final DateTime lastLoginTime;
  @HiveField(98)
  final DateTime createdAt;
  @HiveField(99)
  final DateTime inHiveAt;

  // this is a Copy function to copy the current object and return a new object with old token

  // CurrentUserEntity copyWith({String? token}) {
  //   return CurrentUserEntity(
  //     message: message,
  //     email: email,
  //     token: token ?? this.token,
  //     username: username,
  //     userID: userID,
  //     chatIDs: chatIDs,
  //     address: address,
  //     businessIDs: businessIDs,
  //     currency: currency,
  //     imageVerified: imageVerified,
  //     verificationImage: verificationImage,
  //     profileImage: profileImage,
  //     privacy: privacy,
  //     inHiveAt: inHiveAt,
  //   );
  // }
}
