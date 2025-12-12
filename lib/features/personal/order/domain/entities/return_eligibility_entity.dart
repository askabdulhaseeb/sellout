class ReturnEligibilityEntity {
  final bool success;
  final String? orderId;
  final bool? allowed;
  final String? reason;
  final String? currentStatus;
  final bool? returnAlreadyRequested;

  ReturnEligibilityEntity({
    required this.success,
    this.orderId,
    this.allowed,
    this.reason,
    this.currentStatus,
    this.returnAlreadyRequested,
  });

  @override
  String toString() {
    return 'ReturnEligibilityEntity(success: $success, orderId: $orderId, allowed: $allowed, reason: $reason, currentStatus: $currentStatus, returnAlreadyRequested: $returnAlreadyRequested)';
  }
}
