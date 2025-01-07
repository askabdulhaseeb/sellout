class ServiceType {
  const ServiceType({required this.code, required this.json});
  final String code;
  final String json;
}

enum ServiceCategoryType {
  marketingAdvertising(
    'marketing_and_advertising',
    'marketing_and_advertising',
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
    this.category,
    this.tags,
    this.serviceTypes,
  );
  final String code;
  final String json;
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
