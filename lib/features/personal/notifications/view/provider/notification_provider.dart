import 'package:flutter/material.dart';
import '../../../user/profiles/domain/usecase/get_user_by_uid.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider(this.getUSerUsecase);
  final GetUserByUidUsecase getUSerUsecase;

  void getUser() async {}
}
