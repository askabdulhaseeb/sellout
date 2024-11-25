enum BusinessPageTabType {
  calender('calender'),
  services('services'),
  store('store'),
  promos('promos'),
  myviewing('myviewing'),
  reviews('reviews');

  const BusinessPageTabType(this.code);
  final String code;

  static List<BusinessPageTabType> mine = <BusinessPageTabType>[
    calender,
    services,
    store,
    promos,
    myviewing,
    reviews,
  ];

  static List<BusinessPageTabType> others = <BusinessPageTabType>[
    services,
    store,
    promos,
    reviews,
  ];
}
