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
  pending('pending', 'pending', <String>['pending'], Colors.blue, _blueBG),
  //
  @HiveField(11)
  inprogress(
    'inprogress',
    'inprogress',
    <String>['inprogress'],
    Colors.orange,
    _orangeBG,
  ),
  @HiveField(12)
  inActive(
    'in_active',
    'in_active',
    <String>['in_active', 'inactive'],
    Colors.orange,
    _orangeBG,
  ),
  //
  @HiveField(21)
  blocked('blocked', 'blocked', <String>['blocked'], Colors.red, _redBG),
  @HiveField(22)
  rejected(
    'rejected',
    'rejected',
    <String>['rejected', 'reject'],
    Colors.red,
    _redBG,
  ),
  @HiveField(23)
  cancelled(
    'cancelled',
    'cancelled',
    <String>['cancel', 'cancelled', 'cancelled_by_seller'],
    Colors.black,
    _redBG,
  ),
  @HiveField(24)
  canceled('canceled', 'canceled', <String>['canceled'], Colors.black, _redBG),
  @HiveField(25)
  rejectedBySeller(
    'rejected_by_seller',
    'rejected_by_seller',
    <String>['rejected_by_seller'],
    Colors.red,
    _redBG,
  ),
  @HiveField(26)
  returned('returned', 'returned', <String>['returned'], Colors.black, _redBG),
  //
  @HiveField(31)
  accepted(
    'accepted',
    'accepted',
    <String>['accepted', 'accept', 'approve', 'approved'],
    Colors.green,
    _greenBG,
  ),
  @HiveField(32)
  completed(
    'completed',
    'completed',
    <String>['completed', 'complet'],
    Colors.green,
    _greenBG,
  ),
  @HiveField(33)
  delivered(
    'delivered',
    'delivered',
    <String>['delivered', 'deliver'],
    Colors.teal,
    _greenBG,
  ),
  @HiveField(34)
  shipped(
    'shipped',
    'shipped',
    <String>['shipped', 'dispatched'],
    Colors.blue,
    _greenBG,
  ),
  @HiveField(35)
  active('active', 'active', <String>['active'], Colors.green, _greenBG),
  @HiveField(36)
  onHold('on-hold', 'on-hold', <String>['on-hold'], Colors.green, _greenBG),
  @HiveField(37)
  processing(
    'processing',
    'processing',
    <String>['processing'],
    Colors.red,
    _greenBG,
  ),
  @HiveField(38)
  readyToShip(
    'ready_to_ship',
    'ready_to_ship',
    <String>['ready_to_ship'],
    Colors.red,
    _greenBG,
  ),
  @HiveField(39)
  paid('paid', 'paid', <String>['paid'], Colors.red, _greenBG);

  const StatusType(
    this.code,
    this.json,
    this.aliases,
    this.color,
    this.bgColor,
  );
  final String code;
  final String json;
  final List<String> aliases;
  final Color color;
  final Color bgColor;

  static StatusType fromJson(String? map) {
    debugPrint('Mapping StatusType from json: $map');
    if (map == null) return StatusType.pending;
    for (final StatusType s in StatusType.values) {
      if (s.code == map || s.json == map || s.aliases.contains(map)) {
        return s;
      }
    }
    return StatusType.pending;
  }
}
