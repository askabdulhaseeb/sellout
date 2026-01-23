import 'package:flutter/material.dart';

/// Postage type used across UI and API payloads.
/// - `json` is sent to backend (`home` | `pickup`).
/// - `code` is used as localization key (`home` | `pickup`).
enum PostageType {
  home('home', 'delivery', Colors.blue, Color(0x1A2196F3)),
  pickup('pickup', 'pickup', Colors.orange, Color(0x1AFFA726));

  const PostageType(this.json, this.code, this.color, this.bgColor);
  final String json; // API value
  final String code; // localization key
  final Color color;
  final Color bgColor;

  bool get isPickup => this == PostageType.pickup;
  bool get isHome => this == PostageType.home;
}
