import '../../../../../../core/helper_functions/country_helper.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import 'package:flutter/foundation.dart';

class ConnectAccountSessionParams {
  ConnectAccountSessionParams({
    required this.email,
    required this.country,
    this.businessId,
  });
  final String email;
  final String country;
  final String? businessId;

  Map<String, dynamic> toMap() {
    final Map<String, String> data = <String, String>{
      'email': LocalAuth.currentUser?.email ?? '',
      'country': CountryHelper.getCountryAlpha2(country) ?? '',
      'source': 'mobile-app',
    };

    // Only add business_id if it's provided
    if (businessId != null) {
      data['business_id'] = businessId!;
    }

    debugPrint('ConnectAccountSessionParams payload: $data');
    return data;
  }

  @override
  String toString() => toMap().toString();
}
