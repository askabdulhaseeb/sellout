enum UserProfilePageTabType {
  store('store'),
  viewing('viewing'),
  promos('promos'),
  reviews('reviews');

  const UserProfilePageTabType(this.code);
  final String code;
}
