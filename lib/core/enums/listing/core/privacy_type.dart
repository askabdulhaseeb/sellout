import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
part 'privacy_type.g.dart';

@HiveType(typeId: 26)
enum PrivacyType {
  @HiveField(0)
  public('public', 'public', Icons.public),
  @HiveField(1)
  supporters('supporters', 'supporters', CupertinoIcons.person_3_fill),
  @HiveField(2)
  private('private', 'private', CupertinoIcons.eye_slash);

  const PrivacyType(this.code, this.json, this.icon);
  final String code;
  final String json;
  final IconData icon;

  static PrivacyType fromJson(String? val) {
    return list.firstWhere(
      (PrivacyType e) => e.json == val,
      orElse: () => PrivacyType.public,
    );
  }

  static List<PrivacyType> get list => PrivacyType.values;

  static List<IconData> get icons => <IconData>[
    PrivacyType.public.icon,
    PrivacyType.supporters.icon,
    PrivacyType.private.icon,
  ];
}
