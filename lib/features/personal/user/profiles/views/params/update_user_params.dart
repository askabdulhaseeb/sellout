class UpdateUserParams {
  UpdateUserParams({
    this.name = '',
    this.bio = '',
    this.uid = '',
    this.twoFactorAuth,
    this.dob,
    this.pushNotification,
    this.emailNotification,
  });

  final String name;
  final String bio;
  final String uid;
  final bool? twoFactorAuth;
  final DateTime? dob;
  final bool? pushNotification;
  final bool? emailNotification;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      if (name.isNotEmpty) 'display_name': name,
      if (bio.isNotEmpty) 'bio': bio,
      if (twoFactorAuth != null)
        'security': <String, bool>{
          'two_factor_authentication': twoFactorAuth!,
        },
      if (dob != null) 'dob': dob!.toIso8601String(),
    };

    // Conditionally add notifications if either is not null
    if (pushNotification != null || emailNotification != null) {
      map['notifications'] = <String, bool>{
        if (pushNotification != null) 'push_notification': pushNotification!,
        if (emailNotification != null) 'email_notification': emailNotification!,
      };
    }

    return map;
  }
}
