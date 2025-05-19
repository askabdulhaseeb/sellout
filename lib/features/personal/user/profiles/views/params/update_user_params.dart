class UpdateUserParams {
  UpdateUserParams({
    this.name = '',
    this.bio = '',
    this.uid = '',
    this.twoFactorAuth = false,
  });

  final String name;
  final String bio;
  final String uid;
  bool twoFactorAuth;

  Map<String, dynamic> toMap() {
    return {
      if (name.isNotEmpty) 'display_name': name,
      if (bio.isNotEmpty) 'bio': bio,
      if (twoFactorAuth)
        'security': {
          'two_factor_authentication': true,
        },
    };
  }
}
