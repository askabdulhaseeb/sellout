class AddRemoveSupporterParams {

  AddRemoveSupporterParams({
    required this.supporterId,
    required this.action,
  });
  final String supporterId;
  final SupporterAction action;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'supporter_id': supporterId,
    };
  }
}

enum SupporterAction {
  add('add'),
  unfollow('un_follow');
 const SupporterAction(this.value);
  final String value;
}
