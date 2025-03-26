class UpdateUserParams {
  UpdateUserParams({required this.name, required this.bio, required this.uid});

  final String name;
  final String bio;
  final String uid;
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'display_name': name,
      'bio': bio,
    };
  }
}
