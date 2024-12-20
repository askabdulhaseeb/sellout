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
    dateFormat = DateFormat("EEE MMM dd yyyy HH:mm:ss GMT'Z");
    dateTime = dateFormat.tryParseUtc(this);
    if (dateTime != null) return dateTime.toLocal();
    //
    dateFormat = DateFormat('hh:mm a yyyy-MM-dd');
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
    return Color(int.parse(startsWith('#') ? replaceAll('#', '0xFF') : this));
  }
}

extension NullableStringExt on String? {
  DateTime? toLocalDate() {
    if (this == null) return null;
    final DateFormat dateFormat = DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z");
    DateTime dateTime = dateFormat.parse(this!, true).toLocal();
    return dateTime;
  }

  DateTime? toDateTime() {
    if (this == null) return null;
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'");
    DateTime? dateTime = dateFormat.tryParseUtc(this!);
    if (dateTime != null) return dateTime.toLocal();
    //
    dateFormat = DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z");
    dateTime = dateFormat.tryParseUtc(this!);
    if (dateTime != null) return dateTime.toLocal();
    //
    dateFormat = DateFormat("EEE MMM dd yyyy HH:mm:ss GMT'Z");
    dateTime = dateFormat.tryParseUtc(this!);
    if (dateTime != null) return dateTime.toLocal();
    //
    dateFormat = DateFormat('hh:mm a yyyy-MM-dd');
    dateTime = dateFormat.tryParseUtc(this!);
    if (dateTime != null) return dateTime.toLocal();
    return null;
  }

  String? toSHA256() {
    if (this == null) return null;
    Uint8List bytes = utf8.encode(this!);
    Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  Color toColor() {
    if (this == null || (this ?? '').isEmpty) return Colors.transparent;
    final String coo = this ?? '';
    return Color(
        int.parse(coo.startsWith('#') ? coo.replaceAll('#', '0xFF') : coo));
  }
}
