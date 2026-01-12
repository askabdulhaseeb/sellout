enum Gender {
  male(code: 'male', json: 'male'),
  female(code: 'female', json: 'female');

  const Gender({required this.code, required this.json});

  final String code;
  final String json;

  static Gender? fromJson(String? value) {
    return Gender.values.firstWhere(
      (Gender e) => e.json == value,
      orElse: () => Gender.male,
    );
  }
}
