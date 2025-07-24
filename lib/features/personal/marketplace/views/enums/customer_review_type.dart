enum ReviewFilterParam {
  five,
  four,
  three,
  two,
  one,
}

extension ReviewFilterParamExtension on ReviewFilterParam {
  String get text {
    switch (this) {
      case ReviewFilterParam.five:
        return '5_stars';
      case ReviewFilterParam.four:
        return '4_stars';
      case ReviewFilterParam.three:
        return '3_stars';
      case ReviewFilterParam.two:
        return '2_stars';
      case ReviewFilterParam.one:
        return '1_star';
    }
  }

  int? get jsonValue {
    switch (this) {
      case ReviewFilterParam.five:
        return 5;
      case ReviewFilterParam.four:
        return 4;
      case ReviewFilterParam.three:
        return 3;
      case ReviewFilterParam.two:
        return 2;
      case ReviewFilterParam.one:
        return 1;
    }
  }

  /// Convert from int? to enum value
  static ReviewFilterParam? fromJson(int? value) {
    switch (value) {
      case 5:
        return ReviewFilterParam.five;
      case 4:
        return ReviewFilterParam.four;
      case 3:
        return ReviewFilterParam.three;
      case 2:
        return ReviewFilterParam.two;
      case 1:
        return ReviewFilterParam.one;
      default:
        return null;
    }
  }
}
