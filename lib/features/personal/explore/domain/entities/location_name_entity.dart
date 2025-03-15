class LocationNameEntity {
  LocationNameEntity({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
  });
  final String description;
  final List<MatchedSubstringEntity> matchedSubstrings;
  final String placeId;
  final String reference;
  final StructuredFormattingEntity structuredFormatting;
  final List<TermEntity> terms;
  final List<String> types;
}

class MatchedSubstringEntity {
  MatchedSubstringEntity({
    required this.length,
    required this.offset,
  });
  final int length;
  final int offset;
}

class StructuredFormattingEntity {
  StructuredFormattingEntity({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });
  final String mainText;
  final List<MatchedSubstringEntity> mainTextMatchedSubstrings;
  final String secondaryText;
}

class TermEntity {
  TermEntity({
    required this.offset,
    required this.value,
  });
  final int offset;
  final String value;
}
