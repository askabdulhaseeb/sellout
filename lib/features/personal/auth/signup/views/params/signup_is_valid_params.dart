class SignupIsValidParams {

  SignupIsValidParams({this.email, this.username});
  final String? email;
  final String? username;

  Map<String, dynamic> toVerifyMap() {
    return <String, dynamic>{
      if (email != null) 'email': email,
      if (username != null) 'username': username,
    };
  }
}
