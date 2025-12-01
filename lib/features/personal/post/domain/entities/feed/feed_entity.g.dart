// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeedEntityAdapter extends TypeAdapter<FeedEntity> {
  @override
  final typeId = 60;

  @override
  FeedEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeedEntity(
      endpointHash: fields[0] as String,
      posts: (fields[1] as List).cast<PostEntity>(),
      cachedAt: fields[3] as DateTime,
      nextPageToken: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FeedEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.endpointHash)
      ..writeByte(1)
      ..write(obj.posts)
      ..writeByte(2)
      ..write(obj.nextPageToken)
      ..writeByte(3)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
