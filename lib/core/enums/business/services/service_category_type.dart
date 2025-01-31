class ServiceType {
  const ServiceType({required this.code, required this.json});
  final String code;
  final String json;
}

enum ServiceCategoryType {
  marketingAdvertising(
    'marketing_and_advertising',
    'marketing_and_advertising',
    'https://cdn.pixabay.com/photo/2022/07/23/05/05/computer-7339324_1280.png',
    'Business',
    <String>['promotion', 'media', 'advertising'],
    <ServiceType>[
      ServiceType(code: 'digital_marketing', json: 'digital_marketing'),
      ServiceType(code: 'social_media_,anagement', json: 'social_media'),
      ServiceType(code: 'seo_service', json: 'seo')
    ],
  ),
  designCreativeServices(
    'design_and_creative_services',
    'design_and_creative_services',
    'https://cdn.pixabay.com/photo/2023/10/18/22/47/fox-8325211_1280.png',
    'Creative',
    <String>['design', 'branding', 'creative'],
    <ServiceType>[
      ServiceType(code: 'graphic_design', json: 'graphic_design'),
      ServiceType(code: 'logo_design', json: 'logo_design'),
      ServiceType(code: 'brand_identity', json: 'brand_identity')
    ],
  ),
  writingTransition(
    'writing_and_transition',
    'writing_and_transition',
    'https://cdn.pixabay.com/photo/2017/02/01/10/21/funny-2029437_1280.png',
    'Creative',
    <String>['writing', 'translation', 'copywriting'],
    <ServiceType>[
      ServiceType(code: 'content_writing', json: 'content_writing'),
      ServiceType(code: 'copywriting', json: 'copywriting'),
      ServiceType(code: 'translation', json: 'translation')
    ],
  ),
  businessConsulting(
    'business_and_consulting',
    'business_and_consulting',
    'https://cdn.pixabay.com/photo/2024/03/28/05/58/work-8660318_1280.png',
    'Business',
    <String>['consulting', 'advisory', 'business'],
    <ServiceType>[
      ServiceType(code: 'business_advisory', json: 'business_advisory'),
      ServiceType(code: 'financial_consulting', json: 'financial_consulting'),
      ServiceType(code: 'management_consulting', json: 'management_consulting')
    ],
  ),
  massage(
    'massage',
    'massage',
    'https://cdn.pixabay.com/photo/2021/02/08/16/13/woman-5995387_1280.png',
    'Wellness',
    <String>['therapy', 'wellness', 'relaxation'],
    <ServiceType>[
      ServiceType(code: 'relaxation_massage', json: 'relaxation_massage'),
      ServiceType(code: 'therapeutic_massage', json: 'therapeutic_massage')
    ],
  ),
  hairExtensions(
    'hair_extensions',
    'hair_extensions',
    'https://cdn.pixabay.com/photo/2020/05/23/06/00/woman-5208160_1280.png',
    'Beauty',
    <String>['hair', 'beauty', 'extension'],
    <ServiceType>[
      ServiceType(code: 'clip_in_extension', json: 'clip_in_extension'),
      ServiceType(code: 'tape_in_extension', json: 'tape_in_extension')
    ],
  ),
  hairRemoval(
    'hair_removal',
    'hair_removal',
    'https://cdn.pixabay.com/photo/2015/10/12/09/27/hairstyle-983545_1280.png',
    'Beauty',
    <String>['hair', 'removal', 'waxing'],
    <ServiceType>[
      ServiceType(code: 'waxing', json: 'waxing'),
      ServiceType(code: 'laser_hair_removal', json: 'laser_hair_removal')
    ],
  ),
  tattoos(
    'tattoos',
    'tattoos',
    'https://cdn.pixabay.com/photo/2024/06/11/10/31/tattoo-8822674_1280.png',
    'Beauty',
    <String>['tattoo', 'art', 'body'],
    <ServiceType>[
      ServiceType(code: 'custom_tattoos', json: 'custom_tattoos'),
      ServiceType(code: 'cover_up_tattoos', json: 'cover_up_tattoos')
    ],
  ),
  fitness(
    'fitness',
    'fitness',
    'https://cdn.pixabay.com/photo/2024/02/22/11/25/woman-8589755_1280.png',
    'Wellness',
    <String>['fitness', 'training', 'exercise'],
    <ServiceType>[
      ServiceType(code: 'personal_training', json: 'personal_training'),
      ServiceType(code: 'group_fitness', json: 'group_fitness')
    ],
  ),
  makeup(
    'makeup',
    'makeup',
    'https://cdn.pixabay.com/photo/2016/03/31/21/39/bathroom-1296554_1280.png',
    'Beauty',
    <String>['beauty', 'cosmetics', 'makeup'],
    <ServiceType>[
      ServiceType(code: 'bridal_makeup', json: 'bridal_makeup'),
      ServiceType(code: 'party_makeup', json: 'party_makeup')
    ],
  ),
  facialSkincare(
    'facial_and_skincare',
    'facial_and_skincare',
    'https://cdn.pixabay.com/photo/2021/01/26/10/27/woman-5951049_1280.png',
    'Beauty',
    <String>['skincare', 'facial', 'beauty'],
    <ServiceType>[
      ServiceType(code: 'anti_aging_facial', json: 'anti_aging_facial'),
      ServiceType(code: 'hydrating_facial', json: 'hydrating_facial')
    ],
  ),
  eyebrowLashes(
    'eyebrows_and_lashes',
    'eyebrows_and_lashes',
    'https://cdn.pixabay.com/photo/2023/07/12/20/40/ai-generated-8123332_1280.png',
    'Beauty',
    <String>['eyebrows', 'lashes', 'beauty'],
    <ServiceType>[
      ServiceType(code: 'lash_lift', json: 'lash_lift'),
      ServiceType(code: 'eyebrow_tinting', json: 'eyebrow_tinting')
    ],
  ),
  nailServices(
    'nail_services',
    'nail_services',
    'https://cdn.pixabay.com/photo/2018/08/10/23/33/nail-polish-3597832_1280.png',
    'Beauty',
    <String>['nails', 'manicure', 'pedicure'],
    <ServiceType>[
      ServiceType(code: 'manicure', json: 'manicure'),
      ServiceType(code: 'pedicure', json: 'pedicure')
    ],
  ),
  haircutStyling(
    'haircut_and_styling',
    'haircut_and_styling',
    'https://cdn.pixabay.com/photo/2013/07/13/10/17/barber-156940_1280.png',
    'Beauty',
    <String>['haircut', 'styling', 'salon'],
    <ServiceType>[
      ServiceType(code: 'haircut', json: 'haircut'),
      ServiceType(code: 'styling', json: 'styling')
    ],
  ),
  financialServices(
    'financial_services',
    'financial_services',
    'https://cdn.pixabay.com/photo/2023/07/04/19/43/man-8106958_1280.png',
    'Business',
    <String>['finance', 'accounting', 'money'],
    <ServiceType>[
      ServiceType(code: 'accounting', json: 'accounting'),
      ServiceType(code: 'tax_preparation', json: 'tax_preparation')
    ],
  ),
  legalServices(
    'legal_services',
    'legal_services',
    'https://cdn.pixabay.com/photo/2022/11/29/21/44/justice-7625456_1280.png',
    'Business',
    <String>['law', 'legal', 'consultation'],
    <ServiceType>[
      ServiceType(code: 'legal_consultation', json: 'legal_consultation'),
      ServiceType(code: 'contract_drafting', json: 'contract_drafting')
    ],
  ),
  healthWellness(
    'health_and_wellness',
    'health_and_wellness',
    'https://cdn.pixabay.com/photo/2020/01/07/00/28/world-4746550_1280.jpg',
    'Wellness',
    <String>['health', 'wellness', 'care'],
    <ServiceType>[
      ServiceType(code: 'mental_health', json: 'mental_health'),
      ServiceType(
          code: 'nutrition_consultation', json: 'nutrition_consultation')
    ],
  ),
  educationTutoring(
    'education_and_tutoring',
    'education_and_tutoring',
    'https://cdn.pixabay.com/photo/2024/02/28/12/56/girl-8602014_1280.png',
    'Education',
    <String>['education', 'tutoring', 'learning'],
    <ServiceType>[
      ServiceType(code: 'online_tutoring', json: 'online_tutoring'),
      ServiceType(code: 'test_prep', json: 'test_prep')
    ],
  ),
  homeImprovementMaintenance(
    'home_improvement_and_maintenance',
    'home_improvement_and_maintenance',
    'https://cdn.pixabay.com/photo/2019/08/24/10/49/plumber-4427401_1280.jpg',
    'Home',
    <String>['home', 'maintenance', 'repair'],
    <ServiceType>[
      ServiceType(code: 'plumbing', json: 'plumbing'),
      ServiceType(code: 'electrical_services', json: 'electrical_services')
    ],
  ),
  automotiveServices(
    'automotive_services',
    'automotive_services',
    'https://cdn.pixabay.com/photo/2018/09/12/07/40/car-mechanic-3671448_1280.png',
    'Automotive',
    <String>['car', 'vehicle', 'repair'],
    <ServiceType>[
      ServiceType(code: 'car_repair', json: 'car_repair'),
      ServiceType(code: 'car_washing', json: 'car_washing')
    ],
  ),
  eventPlanningServices(
    'event_planning_and_services',
    'event_planning_and_services',
    'https://cdn.pixabay.com/photo/2022/12/02/12/26/time-7630786_1280.png',
    'Events',
    <String>['event', 'planning', 'services'],
    <ServiceType>[
      ServiceType(code: 'wedding_planning', json: 'wedding_planning'),
      ServiceType(code: 'party_planning', json: 'party_planning')
    ],
  ),
  travelTourism(
    'travel_and_tourism',
    'travel_and_tourism',
    'https://cdn.pixabay.com/photo/2018/05/18/16/41/globe-3411506_1280.jpg',
    'Travel',
    <String>['travel', 'tourism', 'adventure'],
    <ServiceType>[
      ServiceType(code: 'tour_packages', json: 'tour_packages'),
      ServiceType(code: 'adventure_travel', json: 'adventure_travel')
    ],
  ),
  fitnessPersonalTraining(
    'fitness_and_personal_training',
    'fitness_and_personal_training',
    'https://cdn.pixabay.com/photo/2020/11/24/18/19/cat-5773481_1280.jpg',
    'Wellness',
    <String>['fitness', 'personal training', 'exercise'],
    <ServiceType>[
      ServiceType(code: 'personal_training', json: 'personal_training'),
      ServiceType(code: 'group_training', json: 'group_training')
    ],
  ),
  photographyVideography(
    'photography_and_videography',
    'photography_and_videography',
    'https://cdn.pixabay.com/photo/2024/02/27/05/04/ai-generated-8599431_1280.jpg',
    'Creative',
    <String>['photo', 'video', 'creative'],
    <ServiceType>[
      ServiceType(code: 'event_photography', json: 'event_photography'),
      ServiceType(code: 'wedding_videography', json: 'wedding_videography')
    ],
  ),
  beautyCosmetics(
    'beauty_and_cosmetics',
    'beauty_and_cosmetics',
    'https://cdn.pixabay.com/photo/2022/03/17/04/57/cosmetic-products-7073743_1280.jpg',
    'Beauty',
    <String>['beauty', 'cosmetics', 'care'],
    <ServiceType>[
      ServiceType(code: 'skincare', json: 'skincare'),
      ServiceType(code: 'makeup_artistry', json: 'makeup_artistry')
    ],
  ),
  foodCateringServices(
    'food_and_catering_services',
    'food_and_catering_services',
    'https://cdn.pixabay.com/photo/2014/04/02/14/09/restaurant-306345_1280.png',
    'Food',
    <String>['food', 'catering', 'service'],
    <ServiceType>[
      ServiceType(code: 'event_catering', json: 'event_catering'),
      ServiceType(code: 'private_chef', json: 'private_chef')
    ],
  ),
  petServices(
    'pet_services',
    'pet_services',
    'https://cdn.pixabay.com/photo/2023/09/04/22/35/boy-8233868_1280.png',
    'Pets',
    <String>['pet', 'services', 'care'],
    <ServiceType>[
      ServiceType(code: 'pet_grooming', json: 'pet_grooming'),
      ServiceType(code: 'pet_sitting', json: 'pet_sitting')
    ],
  ),
  realEstateServices(
    'real_estate_services',
    'real_estate_services',
    'https://cdn.pixabay.com/photo/2023/12/29/10/36/house-8475945_1280.jpg',
    'Real Estate',
    <String>['real estate', 'property', 'services'],
    <ServiceType>[
      ServiceType(code: 'property_management', json: 'property_management'),
      ServiceType(code: 'real_estate_agent', json: 'real_estate_agent')
    ],
  );

  const ServiceCategoryType(
    this.code,
    this.json,
    this.imageURL,
    this.category,
    this.tags,
    this.serviceTypes,
  );
  final String code;
  final String json;
  final String imageURL;
  final String category;
  final List<String> tags;
  final List<ServiceType> serviceTypes;

  static ServiceCategoryType? fromJson(String json) {
    return ServiceCategoryType.values.firstWhere(
      (ServiceCategoryType e) => e.json == json,
      orElse: () => ServiceCategoryType.tattoos,
    );
  }

  static List<ServiceCategoryType> categories() => <ServiceCategoryType>[
        ...ServiceCategoryType.values
      ]..sort((ServiceCategoryType a, ServiceCategoryType b) =>
          a.category.compareTo(b.category));
}
