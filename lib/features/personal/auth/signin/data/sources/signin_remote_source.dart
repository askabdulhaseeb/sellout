abstract interface class SigninRemoteSource {
  Future<bool> signin(String email, String password);
  Future<bool> forgotPassword(String email);
}

class SigninRemoteSourceImpl implements SigninRemoteSource {
  @override
  Future<bool> signin(String email, String password) async {
    try {
      // Login
    } catch (e) {
      throw e;
    }
    return false;
  }

  @override
  Future<bool> forgotPassword(String email) async {
    try {
      // Forgot Password
    } catch (e) {
      throw e;
    }
    return false;
  }
}
