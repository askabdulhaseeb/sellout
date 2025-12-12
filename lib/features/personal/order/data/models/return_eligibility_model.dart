import 'dart:convert';

class ReturnEligibilityEligibilityModel {
  final bool allowed;
  final String? reason;

  ReturnEligibilityEligibilityModel({required this.allowed, this.reason});

  factory ReturnEligibilityEligibilityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReturnEligibilityEligibilityModel(
      allowed: json['allowed'] == true,
      reason: json['reason'] as String?,
    );
  }
}

class ReturnEligibilityModel {
  final bool success;
  final String? orderId;
  final ReturnEligibilityEligibilityModel? eligibility;
  final String? currentStatus;
  final bool? returnAlreadyRequested;

  ReturnEligibilityModel({
    required this.success,
    this.orderId,
    this.eligibility,
    this.currentStatus,
    this.returnAlreadyRequested,
  });

  factory ReturnEligibilityModel.fromJson(Map<String, dynamic> json) {
    return ReturnEligibilityModel(
      success: json['success'] == true,
      orderId: json['order_id'] as String?,
      eligibility: json['eligibility'] is Map<String, dynamic>
          ? ReturnEligibilityEligibilityModel.fromJson(
              json['eligibility'] as Map<String, dynamic>,
            )
          : null,
      currentStatus: json['current_status'] as String?,
      returnAlreadyRequested: json['return_already_requested'] as bool?,
    );
  }

  static ReturnEligibilityModel? fromRaw(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final dynamic parsed = json.decode(raw);
      if (parsed is Map<String, dynamic>) {
        return ReturnEligibilityModel.fromJson(parsed);
      }
    } catch (_) {
      // ignore
    }
    return null;
  }
}
