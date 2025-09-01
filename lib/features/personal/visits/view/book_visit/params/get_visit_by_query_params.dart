enum VisitQueryType {
  postId,
  hostId,
  visitorId,
}

class VisitQueryParams {
  VisitQueryParams({
    required this.type,
    required this.id,
  });
  final VisitQueryType type;
  final String id;

  Map<String, String> toMap() {
    switch (type) {
      case VisitQueryType.postId:
        return <String, String>{'post_id': id};
      case VisitQueryType.hostId:
        return <String, String>{'host_id': id};
      case VisitQueryType.visitorId:
        return <String, String>{'visitor_id': id};
    }
  }
}
