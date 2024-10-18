import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../../../core/sources/data_state.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecase/get_user_by_uid.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider(this._getUserByUidUsecase);
  final GetUserByUidUsecase _getUserByUidUsecase;

  DataState<UserEntity?>? _user;
  UserEntity? get user => _user?.entity;

  Future<DataState<UserEntity?>?> getUserByUid({String? uid}) async {
    _user = await _getUserByUidUsecase(uid ?? LocalAuth.uid ?? '');
    log('Profile Provider: User loaded: ${_user?.entity?.displayName}');
    notifyListeners();
    return _user;
  }
}
