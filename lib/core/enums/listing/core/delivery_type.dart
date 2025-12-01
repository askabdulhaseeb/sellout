import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

part 'delivery_type.g.dart';

@HiveType(typeId: 24)
enum DeliveryType {
  /// List of all delivery types except fastDelivery

  @HiveField(0)
  paid(
    'paid_delivery',
    'paid',
    'paid_delivery_subtitle',
    Colors.teal,
    Color(0x1A008080), // soft teal background
  ),
  @HiveField(1)
  freeDelivery(
    'free_delivery',
    'free',
    'free_delivery_subtitle',
    Colors.green,
    Color(0x1A4CAF50), // soft green background
  ),
  @HiveField(2)
  collection(
    'collection',
    'collection',
    'collection_delivery_subtitle',
    Colors.blue,
    Color(0x1A2196F3), // soft blue background
  ),
  @HiveField(3)
  fastDelivery(
    'fast_delivery',
    'fast',
    'fast_delivery_subtitle',
    Colors.orange,
    Color(0x1AFFA726), // soft orange background
  );

  const DeliveryType(
    this.code,
    this.json,
    this.subtitle,
    this.color,
    this.bgColor,
  );

  final String code;
  final String json;
  final String subtitle;
  final Color color;
  final Color bgColor;

  static DeliveryType fromJson(String? json) {
    if (json == null) return DeliveryType.collection;
    for (final DeliveryType item in DeliveryType.values) {
      if (item.json == json) return item;
    }
    return DeliveryType.collection;
  }

  static List<DeliveryType> get list => DeliveryType.values
      .where((DeliveryType e) => e != DeliveryType.fastDelivery)
      .toList();
}
