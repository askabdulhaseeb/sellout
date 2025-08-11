enum ProfilePageTabType {
  orders('orders'),
  store('store'),
  viewing('viewing'),
  promos('promos'),
  saved('saved'),
  reviews('reviews');

  const ProfilePageTabType(this.code);
  final String code;

  static List<ProfilePageTabType> list(bool isMe) {
    return isMe
        ? <ProfilePageTabType>[orders, store, viewing, promos, saved, reviews]
        : <ProfilePageTabType>[store, promos, reviews];
  }
}
