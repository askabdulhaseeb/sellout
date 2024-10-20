class GetSpecificPostParam {
  const GetSpecificPostParam({
    required this.postId,
    this.silentUpdate = true,
  });

  final String postId;
  final bool silentUpdate;
}
