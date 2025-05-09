class NewPasswordParams {
  NewPasswordParams({
    required this.uid,
    required this.password,
  });

  final String uid;
  final String password;

  /// Convert class properties to a Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'password': password,
    };
  }
}
