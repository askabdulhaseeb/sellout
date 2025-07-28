enum ReviewApiQueryOptionType {
  reviewID('review_id'),
  businessID('business_id'),
  customerID('review_by'),
  sellerID('seller_id'),
  postID('post_id'),
  serviceID('service_id');

  const ReviewApiQueryOptionType(this.json);
  final String json;
}
