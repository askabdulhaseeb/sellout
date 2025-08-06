enum Gender {
  male(code: 'male', json: 'male'),
  female(code: 'female', json: 'female'),
  other(code: 'other', json: 'other');

  final String code;
  final String json;

  const Gender({required this.code, required this.json});

  static Gender? fromJson(String? value) {
    return Gender.values.firstWhere(
      (Gender e) => e.json == value,
      orElse: () => Gender.other,
    );
  }
}
