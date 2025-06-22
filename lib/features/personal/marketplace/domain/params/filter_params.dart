import 'dart:convert';

class FilterParam {
  FilterParam({
    required this.attribute,
    required this.operator,
    required this.value,
  });
  final String attribute;
  final String operator;
  final String value;

  FilterParam copyWith({
    String? attribute,
    String? operator,
    String? value,
  }) {
    return FilterParam(
      attribute: attribute ?? this.attribute,
      operator: operator ?? this.operator,
      value: value ?? this.value,
    );
  }

  Map<String, String> toMap() {
    return <String, String>{
      'attribute': attribute,
      'operator': operator,
      'value': value,
    };
  }

  String toJson() => json.encode(toMap());
}
