import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../../../core/sources/data_state.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../post/domain/entities/post_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecase/get_post_by_id_usecase.dart';
import '../../domain/usecase/get_user_by_uid.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider(this._getUserByUidUsecase, this._getPostByIdUsecase);
  final GetUserByUidUsecase _getUserByUidUsecase;
  final GetPostByIdUsecase _getPostByIdUsecase;

  DataState<UserEntity?>? _user;
  UserEntity? get user => _user?.entity;

  int _displayType = 0;
  int get displayType => _displayType;

  set displayType(int value) {
    _displayType = value;
    notifyListeners();
  }

  Future<DataState<UserEntity?>?> getUserByUid({String? uid}) async {
    _user = await _getUserByUidUsecase(uid ?? LocalAuth.uid ?? '');
    log('Profile Provider: User loaded: ${_user?.entity?.displayName}');
    notifyListeners();
    return _user;
  }

  Future<DataState<List<PostEntity>>> getPostByUser(String? uid) async {
    return await _getPostByIdUsecase(uid);
  }
}
