import 'dart:convert';

class FilterParam {
  FilterParam({
    required this.attribute,
    required this.operator,
    this.value = '',
    this.valueList,
  });

  final String attribute;
  final String operator;
  final String value;
  final List<String>? valueList;

  FilterParam copyWith({
    String? attribute,
    String? operator,
    String? value,
    List<String>? valueList,
  }) {
    return FilterParam(
      attribute: attribute ?? this.attribute,
      operator: operator ?? this.operator,
      value: value ?? this.value,
      valueList: valueList ?? this.valueList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'attribute': attribute,
      'operator': operator,
      'value': value != '' ? value : valueList,
    };
  }

  String toJson() => json.encode(toMap());
}
