import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExt on String {
  DateTime toLocalDate() {
    final DateFormat dateFormat = DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z");
    DateTime dateTime = dateFormat.parse(this, true).toLocal();
    return dateTime;
  }

  DateTime? toDateTime() {
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'");
    DateTime? dateTime = dateFormat.tryParseUtc(this);
    if (dateTime != null) return dateTime.toLocal();
    //
    dateFormat = DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z");
    dateTime = dateFormat.tryParseUtc(this);
    if (dateTime != null) return dateTime.toLocal();
    //
    dateFormat = DateFormat('hh:mm a yyyy-MM-dd');
    dateTime = dateFormat.tryParseUtc(this);
    if (dateTime != null) return dateTime.toLocal();
    return null;
  }

  toSHA256() {
    Uint8List bytes = utf8.encode(this);
    Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  Color toColor() {
    if (isEmpty) return Colors.transparent;
    if (startsWith('#')) return Color(int.parse(substring(1), radix: 16));
    return Color(int.parse(this));
  }
}
