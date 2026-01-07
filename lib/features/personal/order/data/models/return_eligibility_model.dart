import 'dart:convert';
import '../../domain/entities/return_eligibility_entity.dart';

class ReturnEligibilityModel extends ReturnEligibilityEntity {
  ReturnEligibilityModel({
    required super.success,
    super.orderId,
    super.allowed,
    super.currentStatus,
    super.returnAlreadyRequested,
  });

  factory ReturnEligibilityModel.fromJson(Map<String, dynamic> json) {
    // eligibility object contains allowed and daysRemaining
    final Map<String, dynamic>? eligibility =
        json['eligibility'] as Map<String, dynamic>?;

    return ReturnEligibilityModel(
      success: json['success'] == true,
      orderId: json['order_id'] as String?,
      allowed: eligibility?['allowed'] as bool?,
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
