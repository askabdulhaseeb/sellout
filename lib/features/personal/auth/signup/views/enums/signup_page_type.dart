
enum SignupPageType {
  accountType,
  basicInfo,
  otp,
  photoVerification,
  dateOfBirth,
  location;

  SignupPageType? next() {
    switch (this) {
      case SignupPageType.accountType:
        return SignupPageType.basicInfo;
      case SignupPageType.basicInfo:
        return SignupPageType.otp;
      case SignupPageType.otp:
        return SignupPageType.photoVerification;
      case SignupPageType.photoVerification:
        return SignupPageType.dateOfBirth;
      case SignupPageType.dateOfBirth:
        return SignupPageType.location;
      case SignupPageType.location:
        return null;
    }
  }

  SignupPageType? previous() {
    switch (this) {
      case SignupPageType.accountType:
        return null;
      case SignupPageType.basicInfo:
        return SignupPageType.accountType;
      case SignupPageType.otp:
        return SignupPageType.basicInfo;
      case SignupPageType.photoVerification:
        return SignupPageType.otp;
      case SignupPageType.dateOfBirth:
        return SignupPageType.photoVerification;
      case SignupPageType.location:
        return SignupPageType.dateOfBirth;
    }
  }
}
