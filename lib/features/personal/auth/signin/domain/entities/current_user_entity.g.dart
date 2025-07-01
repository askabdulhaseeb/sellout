// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentUserEntityAdapter extends TypeAdapter<CurrentUserEntity> {
  @override
  final int typeId = 0;

  @override
  CurrentUserEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentUserEntity(
      message: fields[1] as String,
      token: fields[2] as String,
      userID: fields[3] as String,
      email: fields[11] as String,
      userName: fields[12] as String,
      displayName: fields[13] as String,
      currency: fields[14] as String?,
      privacy: fields[15] as PrivacyType,
      countryAlpha3: fields[16] as String,
      countryCode: fields[17] as String,
      phoneNumber: fields[18] as String,
      language: fields[19] as String,
      address: (fields[21] as List).cast<AddressEntity>(),
      chatIDs: (fields[31] as List).cast<String>(),
      businessIDs: (fields[32] as List).cast<String>(),
      imageVerified: fields[41] as bool,
      verificationImage: fields[42] as AttachmentEntity?,
      profileImage: (fields[43] as List).cast<AttachmentEntity>(),
      lastLoginTime: fields[97] as DateTime,
      createdAt: fields[98] as DateTime,
      updatedAt: fields[99] as DateTime,
      inHiveAt: fields[100] as DateTime,
      businessStatus: fields[120] as String?,
      businessName: fields[121] as String?,
      businessID: fields[122] as String?,
      logindetail: fields[123] as LoginDetailEntity,
      loginActivity: (fields[154] as List).cast<DeviceLoginInfoEntity>(),
      employeeList: (fields[125] as List).cast<BusinessEmployeeEntity>(),
      notification: fields[152] as NotificationSettingsEntity?,
      twoStepAuthEnabled: fields[153] as bool?,
      supporters: (fields[140] as List).cast<SupporterDetailEntity>(),
      supporting: (fields[141] as List).cast<SupporterDetailEntity>(),
      privacySettings: fields[151] as PrivacySettingsEntity?,
      timeAway: fields[150] as TimeAwayEntity?,
      accountStatus: fields[20] as String?,
      accountType: fields[22] as String?,
      dob: fields[23] as DateTime?,
      saved: (fields[24] as List).cast<String>(),
      listOfReviews: (fields[25] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, CurrentUserEntity obj) {
    writer
      ..writeByte(39)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.token)
      ..writeByte(3)
      ..write(obj.userID)
      ..writeByte(11)
      ..write(obj.email)
      ..writeByte(12)
      ..write(obj.userName)
      ..writeByte(13)
      ..write(obj.displayName)
      ..writeByte(14)
      ..write(obj.currency)
      ..writeByte(15)
      ..write(obj.privacy)
      ..writeByte(16)
      ..write(obj.countryAlpha3)
      ..writeByte(17)
      ..write(obj.countryCode)
      ..writeByte(18)
      ..write(obj.phoneNumber)
      ..writeByte(19)
      ..write(obj.language)
      ..writeByte(20)
      ..write(obj.accountStatus)
      ..writeByte(22)
      ..write(obj.accountType)
      ..writeByte(23)
      ..write(obj.dob)
      ..writeByte(24)
      ..write(obj.saved)
      ..writeByte(25)
      ..write(obj.listOfReviews)
      ..writeByte(21)
      ..write(obj.address)
      ..writeByte(43)
      ..write(obj.profileImage)
      ..writeByte(41)
      ..write(obj.imageVerified)
      ..writeByte(42)
      ..write(obj.verificationImage)
      ..writeByte(97)
      ..write(obj.lastLoginTime)
      ..writeByte(98)
      ..write(obj.createdAt)
      ..writeByte(99)
      ..write(obj.updatedAt)
      ..writeByte(100)
      ..write(obj.inHiveAt)
      ..writeByte(120)
      ..write(obj.businessStatus)
      ..writeByte(121)
      ..write(obj.businessName)
      ..writeByte(122)
      ..write(obj.businessID)
      ..writeByte(125)
      ..write(obj.employeeList)
      ..writeByte(32)
      ..write(obj.businessIDs)
      ..writeByte(123)
      ..write(obj.logindetail)
      ..writeByte(154)
      ..write(obj.loginActivity)
      ..writeByte(31)
      ..write(obj.chatIDs)
      ..writeByte(140)
      ..write(obj.supporters)
      ..writeByte(141)
      ..write(obj.supporting)
      ..writeByte(150)
      ..write(obj.timeAway)
      ..writeByte(151)
      ..write(obj.privacySettings)
      ..writeByte(152)
      ..write(obj.notification)
      ..writeByte(153)
      ..write(obj.twoStepAuthEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentUserEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
