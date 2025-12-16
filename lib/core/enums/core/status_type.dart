import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
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
  cancelled('cancelled', 'cancelled', Colors.black, _redBG),
  @HiveField(24)
  canceled('canceled', 'canceled', Colors.black, _redBG),
  @HiveField(25)
  rejectedBySeller(
    'cancelled_by_seller',
    'cancelled_by_seller',
    Colors.red,
    _redBG,
  ),
  @HiveField(26)
  returned('returned', 'returned', Colors.black, _redBG),
  //
  @HiveField(31)
  accepted('accepted', 'accepted', Colors.green, _greenBG),
  @HiveField(32)
  completed('completed', 'completed', Colors.green, _greenBG),
  @HiveField(33)
  delivered('delivered', 'delivered', Colors.teal, _greenBG),
  @HiveField(34)
  shipped('shipped', 'shipped', Colors.blue, _greenBG),
  @HiveField(35)
  active('active', 'active', Colors.green, _greenBG),
  @HiveField(36)
  onHold('on-hold', 'on-hold', Colors.green, _greenBG),
  @HiveField(37)
  processing('processing', 'processing', Colors.red, _greenBG),
  @HiveField(38)
  readyToShip('ready_to_ship', 'ready_to_ship', Colors.red, _greenBG),
  @HiveField(39)
  paid('paid', 'paid', Colors.red, _greenBG);

  const StatusType(this.code, this.json, this.color, this.bgColor);
  final String code;
  final String json;
  final Color color;
  final Color bgColor;

  static StatusType fromJson(String? map) {
    debugPrint('Mapping StatusType from json: $map');
    if (map == null) return StatusType.pending;
    switch (map) {
      case 'pending':
        return StatusType.pending;
      case 'accept' || 'accepted' || 'approve' || 'approved':
        return StatusType.accepted;
      case 'reject' || 'rejected':
        return StatusType.rejected;
      case 'cancel' || 'cancelled' || 'cancelled_by_seller':
        return StatusType.cancelled;
      case 'canceled':
        return StatusType.canceled;
      case 'complet' || 'completed':
        return StatusType.completed;
      case 'inprogress':
        return StatusType.inprogress;
      case 'deliver' || 'delivered':
        return StatusType.delivered;
      case 'shipped' || 'dispatched':
        return StatusType.shipped;
      case 'active':
        return StatusType.active;
      case 'inactive':
        return StatusType.inActive;
      case 'blocked':
        return StatusType.blocked;
      case 'on-hold':
        return StatusType.onHold;
      case 'processing':
        return StatusType.processing;
      case 'paid':
        return StatusType.paid;
      case 'ready_to_ship':
        return StatusType.readyToShip;
      default:
        return StatusType.pending;
    }
  }
}
