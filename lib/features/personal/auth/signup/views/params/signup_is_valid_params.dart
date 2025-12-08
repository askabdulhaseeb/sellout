class SignupIsValidParams {
  final String? email;
  final String? username;

  SignupIsValidParams({this.email, this.username});

  Map<String, dynamic> toVerifyMap() {
    return {
      if (email != null) 'email': email,
      if (username != null) 'username': username,
    };
  }
}
