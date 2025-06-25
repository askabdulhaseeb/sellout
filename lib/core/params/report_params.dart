class ReportParams {
  // To report service

  ReportParams({
    required this.title,
    required this.reportReason,
    this.reportedUserId,
    this.businessId,
    this.postId,
    this.serviceId,
  });
  final String title;
  final String reportReason;
  final String? reportedUserId; // To report user
  final String? businessId; // Business reporting a person OR reporting business
  final String? postId; // To report post
  final String? serviceId;

  /// For reporting a user (optionally by a business)
  Map<String, dynamic> toUserReportMap() {
    return <String, dynamic>{
      'title': title,
      'report_reason': reportReason,
      'reported_user_id': reportedUserId,
      if (businessId != null)
        'business_id': businessId, // if business reports user
    };
  }

  /// For reporting a business
  Map<String, dynamic> toBusinessReportMap() {
    return <String, dynamic>{
      'title': title,
      'report_reason': reportReason,
      'business_id':
          businessId, // this should contain business ID you're reporting
    };
  }

  /// For reporting a post
  Map<String, dynamic> toPostReportMap() {
    return <String, dynamic>{
      'title': title,
      'report_reason': reportReason,
      'post_id': postId,
    };
  }

  /// For reporting a service
  Map<String, dynamic> toServiceReportMap() {
    return <String, dynamic>{
      'title': title,
      'report_reason': reportReason,
      'service_id': serviceId,
    };
  }

  @override
  String toString() {
    return 'ReportParams(title: $title, reportReason: $reportReason, reportedUserId: $reportedUserId, businessId: $businessId, postId: $postId, serviceId: $serviceId)';
  }
}
