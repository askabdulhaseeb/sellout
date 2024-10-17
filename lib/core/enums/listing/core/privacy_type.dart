import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PrivacyType {
  public('Public', 'public', Icons.public),
  supporters('Supporters', 'supporters', CupertinoIcons.person_3_fill),
  private('Private', 'private', CupertinoIcons.eye_slash);

  const PrivacyType(this.title, this.json, this.icon);
  final String title;
  final String json;
  final IconData icon;

  static PrivacyType? fromJson(String? json) => PrivacyType.values.firstWhere(
        (PrivacyType e) => e.json == json,
        orElse: () => PrivacyType.public,
      );

  static List<PrivacyType> get list => PrivacyType.values;

  static List<IconData> get icons => <IconData>[
        PrivacyType.public.icon,
        PrivacyType.supporters.icon,
        PrivacyType.private.icon,
      ];
}
