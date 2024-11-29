// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserEntityAdapter extends TypeAdapter<UserEntity> {
  @override
  final int typeId = 1;

  @override
  UserEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserEntity(
      mobileNo: fields[0] as String,
      createdAt: fields[1] as DateTime,
      chatIds: (fields[2] as List).cast<String>(),
      timestamp: fields[3] as DateTime,
      address: (fields[4] as List).cast<AddressEntity>(),
      email: fields[5] as String,
      uid: fields[6] as String,
      displayName: fields[7] as String,
      interest: (fields[8] as List).cast<dynamic>(),
      date: fields[9] as DateTime,
      otpExpiry: fields[10] as DateTime,
      businessIds: (fields[11] as List).cast<String>(),
      supporters: (fields[12] as List).cast<SupporterDetailEntity>(),
      listOfReviews: (fields[13] as List).cast<double>(),
      profilePic: (fields[14] as List).cast<AttachmentEntity>(),
      userName: fields[15] as String,
      profileType: fields[16] as PrivacyType,
      saved: fields[17] == null ? [] : (fields[17] as List).cast<String>(),
      chatIDs: fields[18] == null ? [] : (fields[18] as List).cast<String>(),
      userRoleInfoInBusiness: fields[19] == null
          ? []
          : (fields[19] as List).cast<UserRoleInfoInBusinessEntity>(),
      suppotersInfo: fields[20] == null
          ? []
          : (fields[20] as List).cast<UserSupportInfoEntity>(),
      supportingsInfo: fields[21] == null
          ? []
          : (fields[21] as List).cast<UserSupportInfoEntity>(),
      phoneNumber: fields[22] == null ? '' : fields[22] as String,
      updateAt: fields[23] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserEntity obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.mobileNo)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.chatIds)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.uid)
      ..writeByte(7)
      ..write(obj.displayName)
      ..writeByte(8)
      ..write(obj.interest)
      ..writeByte(9)
      ..write(obj.date)
      ..writeByte(10)
      ..write(obj.otpExpiry)
      ..writeByte(11)
      ..write(obj.businessIds)
      ..writeByte(12)
      ..write(obj.supporters)
      ..writeByte(13)
      ..write(obj.listOfReviews)
      ..writeByte(14)
      ..write(obj.profilePic)
      ..writeByte(15)
      ..write(obj.userName)
      ..writeByte(16)
      ..write(obj.profileType)
      ..writeByte(17)
      ..write(obj.saved)
      ..writeByte(18)
      ..write(obj.chatIDs)
      ..writeByte(19)
      ..write(obj.userRoleInfoInBusiness)
      ..writeByte(20)
      ..write(obj.suppotersInfo)
      ..writeByte(21)
      ..write(obj.supportingsInfo)
      ..writeByte(22)
      ..write(obj.phoneNumber)
      ..writeByte(23)
      ..write(obj.updateAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
