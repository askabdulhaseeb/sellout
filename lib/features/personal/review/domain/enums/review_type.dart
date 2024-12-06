enum ReviewType {
  post('post', 'post'),
  business('business', 'business'),
  user('user', 'user');

  const ReviewType(this.json, this.code);
  final String json;
  final String code;

  static ReviewType fromJson(String? json) {
    if (json == null) return ReviewType.user;
    return ReviewType.values.firstWhere(
      (ReviewType element) => element.json == json,
      orElse: () => ReviewType.user,
    );
  }
}
