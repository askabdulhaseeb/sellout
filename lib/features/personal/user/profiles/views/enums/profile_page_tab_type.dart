enum ProfilePageTabType {
  orders('orders'),
  store('store'),
  promos('promos'),
  viewing('viewing'),
  saved('saved'),
  reviews('reviews');

  const ProfilePageTabType(this.code);
  final String code;

  static List<ProfilePageTabType> list(bool isMe) {
    return isMe
        ? <ProfilePageTabType>[orders, store, promos, viewing, saved, reviews]
        : <ProfilePageTabType>[store, promos, reviews];
  }
}
