class BlockUserParams {
  const BlockUserParams({required this.userId, required this.action});

  final String userId;
  final BlockAction action;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'user_id': userId, 'action': action.value};
  }
}

enum BlockAction {
  block('block'),
  unblock('unblock');

  const BlockAction(this.value);
  final String value;
}
