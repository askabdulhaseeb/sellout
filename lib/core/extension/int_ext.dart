extension IntExt on int {
  String putInStart({required String sign, required int length}) {
    return toString().length < length
        ? toString().padLeft(length, sign)
        : toString();
  }
}
