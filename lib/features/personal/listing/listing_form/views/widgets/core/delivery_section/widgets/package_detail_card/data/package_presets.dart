// Contains all package size presets and related data for the package details card.

const List<Map<String, dynamic>> packagePresets = <Map<String, dynamic>>[
  <String, dynamic>{
    'id': 'small-parcel',
    'titleKey': 'small_parcel',
    'subtitle': 'Up to 35 × 25 × 2.5 cm',
    'icon': 'mail',
    'options': <Map<String, Object>>[
      <String, Object>{
        'id': 'small-1kg',
        'labelKey': 'up_to_1kg',
        'noteKey': 'small_1kg_examples',
        'dims': <num>[35, 25, 2.5],
        'weight': 1,
      },
      <String, Object>{
        'id': 'small-2kg',
        'labelKey': 'up_to_2kg',
        'noteKey': 'small_2kg_examples',
        'dims': <num>[35, 25, 2.5],
        'weight': 2,
      },
      <String, Object>{
        'id': 'small-5kg',
        'labelKey': 'up_to_5kg',
        'noteKey': 'small_5kg_examples',
        'dims': <num>[35, 25, 2.5],
        'weight': 5,
      },
    ],
  },
  <String, dynamic>{
    'id': 'medium-parcel',
    'titleKey': 'medium_parcel',
    'subtitle': 'Up to 45 × 35 × 16 cm',
    'icon': 'inventory_2',
    'options': <Map<String, Object>>[
      <String, Object>{
        'id': 'medium-1kg',
        'labelKey': 'up_to_1kg',
        'noteKey': 'medium_1kg_examples',
        'dims': <int>[45, 35, 16],
        'weight': 1,
      },
      <String, Object>{
        'id': 'medium-2kg',
        'labelKey': 'up_to_2kg',
        'noteKey': 'medium_2kg_examples',
        'dims': <int>[45, 35, 16],
        'weight': 2,
      },
      <String, Object>{
        'id': 'medium-5kg',
        'labelKey': 'up_to_5kg',
        'noteKey': 'medium_5kg_examples',
        'dims': <int>[45, 35, 16],
        'weight': 5,
      },
    ],
  },
  <String, dynamic>{
    'id': 'large-parcel',
    'titleKey': 'large_parcel',
    'subtitle': 'Up to 61 × 46 × 46 cm',
    'icon': 'local_shipping',
    'options': <Map<String, Object>>[
      <String, Object>{
        'id': 'large-1kg',
        'labelKey': 'up_to_1kg',
        'noteKey': 'large_1kg_examples',
        'dims': <int>[61, 46, 46],
        'weight': 1,
      },
      <String, Object>{
        'id': 'large-2kg',
        'labelKey': 'up_to_2kg',
        'noteKey': 'large_2kg_examples',
        'dims': <int>[61, 46, 46],
        'weight': 2,
      },
      <String, Object>{
        'id': 'large-5kg',
        'labelKey': 'up_to_5kg',
        'noteKey': 'large_5kg_examples',
        'dims': <int>[61, 46, 46],
        'weight': 5,
      },
      <String, Object>{
        'id': 'large-10kg',
        'labelKey': 'up_to_10kg',
        'noteKey': 'large_10kg_examples',
        'dims': <int>[61, 46, 46],
        'weight': 10,
      },
    ],
  },
];
