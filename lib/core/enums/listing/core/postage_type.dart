import 'package:flutter/material.dart';

enum PostageType {
  postageOnly('postage_only', 'Postage Only', Colors.blue, Color(0x1A2196F3)),
  pickupOnly('pickup_only', 'Pickup Only', Colors.orange, Color(0x1AFFA726));

  const PostageType(this.code, this.label, this.color, this.bgColor);
  final String code;
  final String label;
  final Color color;
  final Color bgColor;
}
