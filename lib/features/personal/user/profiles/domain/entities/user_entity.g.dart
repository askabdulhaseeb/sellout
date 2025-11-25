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
      uid: fields[0] as String,
      email: fields[1] as String,
      username: fields[2] as String,
      displayName: fields[3] as String,
      bio: fields[4] as String,
      privacyType: fields[5] as PrivacyType?,
      profilePic: (fields[6] as List).cast<AttachmentEntity>(),
      isImageVerified: fields[8] as bool,
      verificationPic: (fields[7] as List).cast<AttachmentEntity>(),
      currency: fields[9] as String,
      language: fields[10] as String,
      listOfReviews: (fields[11] as List).cast<double>(),
      countryAlpha3: fields[12] as String,
      countryCode: fields[13] as String,
      phoneNumber: fields[14] as String,
      address: (fields[30] as List).cast<AddressEntity>(),
      stripeDetails: fields[40] as UserStripeAccountEntity?,
      chatIDs: (fields[50] as List).cast<String>(),
      businessIds: (fields[51] as List).cast<String>(),
      saved: (fields[60] as List).cast<String>(),
      interest: (fields[61] as List).cast<dynamic>(),
      supporters: (fields[62] as List?)?.cast<SupporterDetailEntity>(),
      supportings: (fields[63] as List?)?.cast<SupporterDetailEntity>(),
      businessDetail: (fields[64] as List).cast<ProfileBusinessDetailEntity>(),
      date: fields[70] as DateTime,
      updateAt: fields[71] as DateTime,
      otpExpiry: fields[72] as DateTime,
      timestamp: fields[73] as DateTime,
      createdAt: fields[74] as DateTime,
      inHiveAt: fields[99] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserEntity obj) {
    writer
      ..writeByte(30)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.displayName)
      ..writeByte(4)
      ..write(obj.bio)
      ..writeByte(5)
      ..write(obj.privacyType)
      ..writeByte(6)
      ..write(obj.profilePic)
      ..writeByte(7)
      ..write(obj.verificationPic)
      ..writeByte(8)
      ..write(obj.isImageVerified)
      ..writeByte(9)
      ..write(obj.currency)
      ..writeByte(10)
      ..write(obj.language)
      ..writeByte(11)
      ..write(obj.listOfReviews)
      ..writeByte(12)
      ..write(obj.countryAlpha3)
      ..writeByte(13)
      ..write(obj.countryCode)
      ..writeByte(14)
      ..write(obj.phoneNumber)
      ..writeByte(30)
      ..write(obj.address)
      ..writeByte(40)
      ..write(obj.stripeDetails)
      ..writeByte(50)
      ..write(obj.chatIDs)
      ..writeByte(51)
      ..write(obj.businessIds)
      ..writeByte(60)
      ..write(obj.saved)
      ..writeByte(61)
      ..write(obj.interest)
      ..writeByte(62)
      ..write(obj.supporters)
      ..writeByte(63)
      ..write(obj.supportings)
      ..writeByte(64)
      ..write(obj.businessDetail)
      ..writeByte(70)
      ..write(obj.date)
      ..writeByte(71)
      ..write(obj.updateAt)
      ..writeByte(72)
      ..write(obj.otpExpiry)
      ..writeByte(73)
      ..write(obj.timestamp)
      ..writeByte(74)
      ..write(obj.createdAt)
      ..writeByte(99)
      ..write(obj.inHiveAt);
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
