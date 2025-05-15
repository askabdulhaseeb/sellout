import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'status_type.g.dart';

const Color _blueBG = Color.fromARGB(255, 215, 235, 248);
const Color _orangeBG = Color.fromARGB(255, 245, 230, 207);
const Color _greenBG = Color.fromARGB(255, 222, 246, 220);
const Color _redBG = Color.fromARGB(255, 252, 223, 221);

@HiveType(typeId: 35)
enum StatusType {
  @HiveField(0)
  pending('pending', 'pending', Colors.blue, _blueBG),
  //
  @HiveField(11)
  inprogress('inprogress', 'inprogress', Colors.orange, _orangeBG),
  @HiveField(12)
  inActive('in_active', 'in_active', Colors.orange, _orangeBG),
  //
  @HiveField(21)
  blocked('blocked', 'blocked', Colors.red, _redBG),
  @HiveField(22)
  rejected('rejected', 'rejected', Colors.red, _redBG),
  @HiveField(23)
  cancelled('cancelled', 'cancelled', Colors.red, _redBG),
  //
  @HiveField(31)
  accepted('accepted', 'accepted', Colors.green, _greenBG),
  @HiveField(32)
  completed('completed', 'completed', Colors.green, _greenBG),
  @HiveField(33)
  delivered('delivered', 'delivered', Colors.green, _greenBG),
  @HiveField(34)
  shipped('shipped', 'shipped', Colors.green, _greenBG),
  @HiveField(35)
  active('active', 'active', Colors.green, _greenBG);

  const StatusType(this.code, this.json, this.color, this.bgColor);
  final String code;
  final String json;
  final Color color;
  final Color bgColor;

  static StatusType fromJson(String? map) {
    if (map == null) return StatusType.pending;
    switch (map) {
      case 'pending':
        return StatusType.pending;
      case 'accept' || 'accepted' || 'approve' || 'approved':
        return StatusType.accepted;
      case 'reject' || 'rejected':
        return StatusType.rejected;
      case 'cancel' || 'cancelled':
        return StatusType.cancelled;
      case 'complet' || 'completed':
        return StatusType.completed;
      case 'inprogress' || 'processing':
        return StatusType.inprogress;
      case 'deliver' || 'delivered':
        return StatusType.delivered;
      case 'shipped':
        return StatusType.shipped;
      case 'active':
        return StatusType.active;
      case 'inactive':
        return StatusType.inActive;
      case 'blocked':
        return StatusType.blocked;
      default:
        return StatusType.pending;
    }
  }
}
