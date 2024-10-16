enum DiscountType {
  k0(0, '0%'),
  k5(5, '5%'),
  k10(10, '10%'),
  k15(15, '15%'),
  k20(20, '20%'),
  k25(25, '25%'),
  k30(30, '30%'),
  k35(35, '35%'),
  k40(40, '40%'),
  k45(45, '45%'),
  k50(50, '50%'),
  k55(55, '55%'),
  k60(60, '60%'),
  k65(65, '65%'),
  k70(70, '70%'),
  k75(75, '75%'),
  k80(80, '80%'),
  k85(85, '85%'),
  k90(90, '90%'),
  k95(95, '95%'),
  k100(100, '100%');

  const DiscountType(this.number, this.title);
  final int number;
  final String title;

  static DiscountType? fromJson(int? number) {
    if (number == null) return null;
    for (final DiscountType item in DiscountType.values) {
      if (item.number == number) return item;
    }
    return null;
  }

  static List<DiscountType> get list => DiscountType.values;
}
