import 'package:hive/hive.dart';

import '../../data/models/address_model.dart';
part 'current_user_entity.g.dart';

@HiveType(typeId: 0)
class CurrentUserEntity {
  CurrentUserEntity({
    required this.message,
    required this.email,
    required this.token,
    required this.userName,
    required this.userId,
    required this.chatIDs,
    required this.address,
    required this.inHiveAt,
    this.businessIDs = const <String>[],
  });

  @HiveField(0)
  final String message;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String token;
  @HiveField(3)
  final String userName;
  @HiveField(4)
  final String userId;
  @HiveField(5)
  final List<String> chatIDs;
  @HiveField(6)
  final List<AddressEntity> address;
  @HiveField(7, defaultValue: <String>[])
  final List<String> businessIDs;
  @HiveField(8)
  final DateTime inHiveAt;
}
