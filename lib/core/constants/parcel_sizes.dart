

import 'package:flutter/material.dart';

const List<Map<String, dynamic>> parcelSizes = <Map<String, dynamic>>[
  <String, dynamic>{
    'id': 'small',
    'label': 'Small parcel',
    'dimensions': 'Up to 35 x 25 x 2.5 cm',
    'dims': <num>[35, 25, 2.5],
    'icon': Icons.mail,
    'weights': <Map<String, Object>>[
      <String, Object>{'id': '0-1', 'label': 'Up to 1 kg', 'weight': 1},
    ],
  },
  <String, dynamic>{
    'id': 'medium',
    'label': 'Medium parcel',
    'dimensions': 'Up to 45 x 35 x 16 cm',
    'dims': <int>[45, 35, 16],
    'icon': Icons.inventory_2,
    'weights': <Map<String, Object>>[
      <String, Object>{'id': '0-2', 'label': 'Up to 2 kg', 'weight': 2},
      <String, Object>{'id': '2-5', 'label': '2 - 5 kg', 'weight': 5},
    ],
  },
  <String, dynamic>{
    'id': 'large',
    'label': 'Large Parcel',
    'dimensions': 'Up to 61 x 46 x 46 cm',
    'dims': <int>[61, 46, 46],
    'icon': Icons.local_shipping,
    'weights': <Map<String, Object>>[
      <String, Object>{'id': '0-5', 'label': 'Up to 5 kg', 'weight': 5},
      <String, Object>{'id': '5-10', 'label': '5 - 10 kg', 'weight': 10},
      <String, Object>{'id': '10-15', 'label': '10 - 15 kg', 'weight': 15},
    ],
  },
  <String, dynamic>{
    'id': 'custom',
    'label': 'Custom Parcel',
    'dimensions': null,
    'dims': null,
    'icon': Icons.edit_note,
    'weights': null,
  },
];
