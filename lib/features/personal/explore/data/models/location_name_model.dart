import 'dart:convert';

import '../../domain/entities/location_name_entity.dart';

class LocationNameModel extends LocationNameEntity {
  factory LocationNameModel.fromEntity(LocationNameEntity entity) {
    return LocationNameModel(
        description: entity.description,
        matchedSubstrings: entity.matchedSubstrings,
        placeId: entity.placeId,
        reference: entity.reference,
        structuredFormatting: entity.structuredFormatting,
        terms: entity.terms,
        types: entity.types);
  }
  factory LocationNameModel.fromJson(Map<String, dynamic> map) {
    return LocationNameModel(
      description: map['description'] as String,
      matchedSubstrings: (map['matched_substrings'] as List<dynamic>?)
              ?.map((x) =>
                  MatchedSubstringModel.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      placeId: map['place_id'] as String,
      reference: map['reference'] as String,
      structuredFormatting: StructuredFormattingModel.fromMap(
          map['structured_formatting'] as Map<String, dynamic>),
      terms: (map['terms'] as List<dynamic>?)
              ?.map((x) => TermModel.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      types: (map['types'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  factory LocationNameModel.fromRawJson(String str) =>
      LocationNameModel.fromJson(json.decode(str));

  LocationNameModel( {
    required super.description,
    required super.matchedSubstrings,
    required super.placeId,
    required super.reference,
    required super.structuredFormatting,
    required super.terms,
    required super.types,
  });
}

class MatchedSubstringModel extends MatchedSubstringEntity {
  MatchedSubstringModel({required super.length, required super.offset});

  factory MatchedSubstringModel.fromMap(Map<String, dynamic> map) {
    return MatchedSubstringModel(
      length: map['length'] as int,
      offset: map['offset'] as int,
    );
  }

  factory MatchedSubstringModel.fromJson(Map<String, dynamic> json) {
    return MatchedSubstringModel.fromMap(json);
  }
}

class StructuredFormattingModel extends StructuredFormattingEntity {
  StructuredFormattingModel({
    required super.mainText,
    required super.mainTextMatchedSubstrings,
    required super.secondaryText,
  });

  factory StructuredFormattingModel.fromMap(Map<String, dynamic> map) {
    return StructuredFormattingModel(
      mainText: map['main_text'] as String,
      mainTextMatchedSubstrings:
          (map['main_text_matched_substrings'] as List<dynamic>?)
                  ?.map((x) =>
                      MatchedSubstringModel.fromMap(x as Map<String, dynamic>))
                  .toList() ??
              [],
      secondaryText: map['secondary_text'] as String,
    );
  }

  factory StructuredFormattingModel.fromJson(Map<String, dynamic> json) {
    return StructuredFormattingModel.fromMap(json);
  }
}

class TermModel extends TermEntity {
  TermModel({required super.offset, required super.value});

  factory TermModel.fromMap(Map<String, dynamic> map) {
    return TermModel(
      offset: map['offset'] as int,
      value: map['value'] as String,
    );
  }

  factory TermModel.fromJson(Map<String, dynamic> json) {
    return TermModel.fromMap(json);
  }
}
