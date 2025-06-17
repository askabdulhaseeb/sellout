class UpdateUserParams {
  UpdateUserParams({
    this.name = '',
    this.bio = '',
    this.uid = '',
    this.twoFactorAuth,
    this.dob,
  });

  final String name;
  final String bio;
  final String uid;
  bool? twoFactorAuth;
  final DateTime? dob;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (name.isNotEmpty) 'display_name': name,
      if (bio.isNotEmpty) 'bio': bio,
      if (twoFactorAuth != null)
        'security': <String, bool>{
          'two_factor_authentication': twoFactorAuth ?? false,
        },
      if (dob != null) 'dob': dob!.toIso8601String(),
    };
  }
}
