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
        static ServiceModelType fromJson(String json) {
    return models().firstWhere(
      (ServiceModelType e) => e.json == json,
      orElse: () => ServiceModelType.oneOff, // fallback if needed
    );
  }
}
