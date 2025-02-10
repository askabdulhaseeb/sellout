enum VehivleEmissionType {
  diesel('diesel', 'diesel'),
  electric('electric', 'electric'),
  gasoline('gasoline', 'gasoline'),
  hybrid('hybrid', 'hybrid');

  const VehivleEmissionType(this.json, this.code);
  final String json;
  final String code;

  static List<VehivleEmissionType> get all => VehivleEmissionType.values;

  static VehivleEmissionType fromJson(String json) {
    return VehivleEmissionType.all
        .firstWhere((VehivleEmissionType e) => e.json == json);
  }
}
