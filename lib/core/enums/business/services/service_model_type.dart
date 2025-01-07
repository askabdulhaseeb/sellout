enum ServiceModelType {
  oneOff('normal_one_off', 'one_off'),
  membership('membership', 'membership'),
  subscription('subscription', 'subscription');

  const ServiceModelType(this.code, this.json);
  final String json;
  final String code;

  static List<ServiceModelType> models() => <ServiceModelType>[
        oneOff,
        membership,
        subscription,
      ];
}
