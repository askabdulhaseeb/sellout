class IsValidResponseEntity {
  final bool usernameExist;
  final bool emailExist;

  IsValidResponseEntity({
    required this.usernameExist,
    required this.emailExist,
  });

  factory IsValidResponseEntity.fromJson(Map<String, dynamic> json) {
    return IsValidResponseEntity(
      usernameExist: json['username_exist'] ?? false,
      emailExist: json['email_exist'] ?? false,
    );
  }
}
