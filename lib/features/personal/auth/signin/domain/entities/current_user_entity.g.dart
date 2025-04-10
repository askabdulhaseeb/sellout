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
      username: fields[12] as String,
      currency: fields[13] as String?,
      privacy: fields[14] as PrivacyType,
      countryAlpha3: fields[15] as String,
      countryCode: fields[16] as String,
      phoneNumber: fields[17] as String,
      language: fields[18] as String,
      address: (fields[21] as List).cast<AddressEntity>(),
      chatIDs: (fields[31] as List).cast<String>(),
      businessIDs: (fields[32] as List).cast<String>(),
      imageVerified: fields[41] as bool,
      verificationImage: fields[42] as AttachmentEntity?,
      profileImage: (fields[43] as List).cast<AttachmentEntity>(),
      lastLoginTime: fields[97] as DateTime,
      createdAt: fields[98] as DateTime,
      inHiveAt: fields[99] as DateTime,
      businessStatus: fields[120] as String?,
      businessName: fields[121] as String?,
      businessID: fields[122] as String?,
      logindetail: fields[123] as LoginDetailEntity,
      employeeList: (fields[124] as List).cast<BusinessEmployeeEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, CurrentUserEntity obj) {
    writer
      ..writeByte(25)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.token)
      ..writeByte(3)
      ..write(obj.userID)
      ..writeByte(11)
      ..write(obj.email)
      ..writeByte(12)
      ..write(obj.username)
      ..writeByte(13)
      ..write(obj.currency)
      ..writeByte(14)
      ..write(obj.privacy)
      ..writeByte(15)
      ..write(obj.countryAlpha3)
      ..writeByte(16)
      ..write(obj.countryCode)
      ..writeByte(17)
      ..write(obj.phoneNumber)
      ..writeByte(18)
      ..write(obj.language)
      ..writeByte(21)
      ..write(obj.address)
      ..writeByte(31)
      ..write(obj.chatIDs)
      ..writeByte(32)
      ..write(obj.businessIDs)
      ..writeByte(41)
      ..write(obj.imageVerified)
      ..writeByte(42)
      ..write(obj.verificationImage)
      ..writeByte(43)
      ..write(obj.profileImage)
      ..writeByte(97)
      ..write(obj.lastLoginTime)
      ..writeByte(98)
      ..write(obj.createdAt)
      ..writeByte(99)
      ..write(obj.inHiveAt)
      ..writeByte(120)
      ..write(obj.businessStatus)
      ..writeByte(121)
      ..write(obj.businessName)
      ..writeByte(122)
      ..write(obj.businessID)
      ..writeByte(123)
      ..write(obj.logindetail)
      ..writeByte(124)
      ..write(obj.employeeList);
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
