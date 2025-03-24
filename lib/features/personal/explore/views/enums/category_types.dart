import 'package:easy_localization/easy_localization.dart';

enum CategoryTypes {
  clothandfootwear('cloth_foot'),
  foodanddrink('food_drink'),
  property('property'),
  vehicles('vehicles'),
  pets('pets');

  final String key;
  const CategoryTypes(this.key);
}

class CategoryType {

  CategoryType({
    required this.name, required this.imageUrl, this.category,
  });
  final CategoryTypes? category;
  final String name;
  final String imageUrl;

  String get displayName {
    return category?.translatedName ?? name.tr();
  }
}

extension CategoryTypesExtension on CategoryTypes {
  String get translatedName {
    return key.tr();
  }
}

final List<CategoryType> categories = <CategoryType>[
  CategoryType(
    category: null, // No category enum for 'popular'
    name: 'popular',
    imageUrl:
        'https://s3-alpha-sig.figma.com/img/7c40/4b7a/343188ca8c15a8fbeb74b1b594f83cf7?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=CB7TvY4d3w71bnZyTJERodvcdiHh8VFv50NypvJnMQfD8YBlmLgXQNdx65GFT-HZWs23iyZTLjlSTwiACt5KIHNnaSpzhw7oiV-VKuLfDEEdQ1yQim7cRsFPzXDVrDQ2dB-dt6IUlwHrVMmvvneI8a3JraIKbnZPD4yM4XHJTF9bSrZVGTNVINhD8xk4gADjYo43UVK2CvLRGQu5bw~AFnSlIwsrgiOb9JwNoysQx6uDt~16ZOTHxl3YICfuXeAaIwf5kc56xGtNnsMJ8zXZ~dibhhHX0CRt7WSBOdVYv2vpzvnBNU43SoyHVmcWzyaovltAkDsl9UfBfYIrKBisNQ__',
  ),
  CategoryType(
    category: CategoryTypes.clothandfootwear,
    name: 'cloth_foot',
    imageUrl:
        'https://s3-alpha-sig.figma.com/img/8158/cd46/fd55df60e2d0f936da50a5333d312183?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=qHAbgdHfgeE2kGN~-8x9WleS9ZMwQMSjMQ0iPf2ZivSZNPHCTi3OT6LTDQiC5iQN3n1oimu1ipEE0ZmqgyC4K~0m3Pg-mQ2VujEWk3T77cpv93wItyxRpAOu0natwXtZsuKte2KIJPum0k5poouqMSucBIBrzY9b4h8wRKmjI-Ak7ntgS~~qXfq878LfjevFLIr-mVIP5BreiZa~tVx2N3RgJgKfN5cGP31AqgL-tpIvI3OpiZBbIURQ3aqnaO98-rQh3zMcXzZSYPe2yHGnCQKsEIKvw6i8Crtf5WNPONQUmxu0UvZrir5ktvxY6sD85eePAqCAhoLUkwA9Eag6MQ__',
  ),
  CategoryType(
    category: CategoryTypes.foodanddrink,
    name: 'food_drink',
    imageUrl:
        'https://s3-alpha-sig.figma.com/img/72e2/1c6c/2d2aef432171d943734a6e713338a23e?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=jIGRJaDaDHRUeTOVnumZWE2uUtDeGaTJCeyfaj8d6qx~cGf4ZE~SEJqSN1DpTxCtDYtbD1wF5uBfX3HoXfpnRAc63FGHscari1zVtQ6of0-ogrYQS44Db9yKe1lTBxD4CFHXbkx-TPYR4BZSv9Am96FZ5wrNKhaWNwf9zkKmqWUs4aLm7~hWgabzLLMgFF49PqBV-iwW-4HhzBBayh2rJVun~2g14VGeyOm7qShGCbMtfW1D0ThZ303TsBJ0F6Jqsj-npBkB4DBva4ecEUYMAtla0sWStYr~BPT4h5D0kzFnYwhbz9xb~aydVX~lUnZPIuAOZ11AK4O7qMwpKw13pA__',
  ),
  CategoryType(
    category: CategoryTypes.property,
    name: 'property',
    imageUrl:
        'https://s3-alpha-sig.figma.com/img/1f9f/d103/05c6b90988e261c8b55b798535f20d60?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Qw66mjDFrEvhnj50Qp9Wb474N6BDWLQI9qyGFchTsuSt8-7Rnyr6asxWW4HTZJtm3tKwJpH31pQBVTxO43kTQd1vdJYxQOLLkBsJbCJYf3fqIzXdHINYqeSuxgtEW2PK17Wssq5S-NaxmKGgzhnV-pQyRcN-a89ot1v3yWWRqq1PXlZ7HmW3mwChjsKzaqUQSSjZsmDWKONod2h7A8KiRXXUnmyTOl~H67zAHZ-Iu87HVojGINFUDhN3wlDeoLQ~dDogLlZ3PDrdl9XvakG06q3Kdza2Ivt6QGupvH110RP5U26mBHMwyWYjbdJYhTs1sXAfrNq72H1H4C6lGbhE0A__',
  ),
  // Vehicles
  CategoryType(
    category: CategoryTypes.vehicles,
    name: 'vehicles',
    imageUrl:
        'https://s3-alpha-sig.figma.com/img/2d45/fd54/38e0ffa29aa60d389eaf121c15bfe12f?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=CkbDPaPSIU~W8ibxTRbG~OK-BrQA~nXku1TVVbX6QYBGdTYmCM6uqwH2N8wwXQY50iALGqxfD0bp0Js38z736iKXyJ0Z~t5K3nrUHc4Bb1F3oNY08P9cPZBkjzUhajPtkmPBfZbAuFY1jxZ~sTDNNtbHu0aVn7veIH3OxWM3LiNzW3YiTcP7mvFHUcXEXXiHFAvWz4WSQvb6vkr~7lXNcnxRwcW~0hYhv7raUMsxTtQbbSNd2Luj91AP6IzC~A8VhylisbuAampP40X7DIIIK6z1gHQChKoKdZkWkqoXogV6Ll8LAz64~kzTGIV94K~AgS8wEFvFu9RZ4Lh1YxOlvw__',
  ),
  CategoryType(
      category: CategoryTypes.pets,
      name: 'pets',
      imageUrl:
          'https://s3-alpha-sig.figma.com/img/ecba/6e3d/d2800112e3bd7653f7d38b57e0b79f33?Expires=1742774400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Jo5iuPbht41IpzNZC4mHEBT0eLfTl2NPqaXpdlhxy0VujTOWCGgivg-ekUB6bZBfXJhvwcmMGWTO1y4iNL1mK~jKUqCsi~tnhUEv51XEn9-W9L3zPFvlwe0WO0m11WqmQqnUrb1seRz0-0K85IX~4iNbWr5khGnJyPlBHOfmTHrVz5F3YR~Eq1ACefXClB7a3tdLD05Ae70sDAeBRQ86YPKeZv2uSL7VAaXu30iOjvZSTgoIiHM8Nza9eTun~ull2AMqXKJnUx9ujuOX90~dW8ifflUdFbsri16eqLRMDwwym1OqXxXQI43Bk8NdfaRUdRf2MoMJ90LCC-qsXbWnKg__'),
];
