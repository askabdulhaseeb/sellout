/// Enum for packaging strategies as seen in API responses.
enum PackagingStrategy { singleParcel, multiParcel, unknown }

PackagingStrategy packagingStrategyFromString(String? value) {
  switch (value) {
    case 'single_parcel':
      return PackagingStrategy.singleParcel;
    case 'multi_parcel':
      return PackagingStrategy.multiParcel;
    default:
      return PackagingStrategy.unknown;
  }
}
