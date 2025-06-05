class UpdateUserParams {
  UpdateUserParams({
    this.name = '',
    this.bio = '',
    this.uid = '',
    this.twoFactorAuth,
  });

  final String name;
  final String bio;
  final String uid;
  bool? twoFactorAuth;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (name.isNotEmpty) 'display_name': name,
      if (bio.isNotEmpty) 'bio': bio,
      if (twoFactorAuth != null)
        'security': <String, bool>{
          'two_factor_authentication': twoFactorAuth ?? false,
        },
    };
  }
}
