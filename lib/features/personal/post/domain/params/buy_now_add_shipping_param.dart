class BuyNowAddShippingParam {
  const BuyNowAddShippingParam({
    required this.postId,
    required this.objectId,
  });

  final String postId;
  final String objectId;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'post_id': postId,
        'object_id': objectId,
      };
}
