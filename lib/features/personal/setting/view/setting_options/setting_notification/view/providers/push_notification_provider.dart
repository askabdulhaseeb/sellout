import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/functions/app_log.dart';
import '../../../../../../../../core/sources/data_state.dart';
import '../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../user/profiles/domain/usecase/edit_profile_detail_usecase.dart';
import '../../../../../../user/profiles/views/params/update_user_params.dart';

class PushNotificationProvider extends ChangeNotifier {
  PushNotificationProvider(this._updateProfileDetailUsecase);
  final UpdateProfileDetailUsecase _updateProfileDetailUsecase;
  //variables
  bool enablePhoneNotification =
      LocalAuth.currentUser?.notification?.pushNotification ?? false;
  bool sellOutUpdates = false;
  bool marketingCommunications = false;
  bool newMessages = false;
  bool newFeedback = false;
  bool reducedItems = false;
  bool favouritedItems = false;
  bool newFollowers = false;
  bool newItems = false;
  bool mentions = false;
  bool forumMessages = false;
  bool _isLoading = false;
//getters
  bool get isLoading => _isLoading;
//setters
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

// toggle functions
  // void toggleEnablePhoneNotification(bool value) {
  //   enablePhoneNotification = value;
  //   updateProfileDetail();
  //   notifyListeners();
  // }

  void toggleSellOutUpdates(bool value) {
    sellOutUpdates = value;
    notifyListeners();
  }

  void toggleMarketingCommunications(bool value) {
    marketingCommunications = value;
    notifyListeners();
  }

  void toggleNewMessages(bool value) {
    newMessages = value;
    notifyListeners();
  }

  void toggleNewFeedback(bool value) {
    newFeedback = value;
    notifyListeners();
  }

  void toggleReducedItems(bool value) {
    reducedItems = value;
    notifyListeners();
  }

  void toggleFavouritedItems(bool value) {
    favouritedItems = value;
    notifyListeners();
  }

  void toggleNewFollowers(bool value) {
    newFollowers = value;
    notifyListeners();
  }

  void toggleNewItems(bool value) {
    newItems = value;
    notifyListeners();
  }

  void toggleMentions(bool value) {
    mentions = value;
    notifyListeners();
  }

  void toggleForumMessages(bool value) {
    forumMessages = value;
    notifyListeners();
  }

// data/api calls
  Future<void> updateProfileDetail(bool value) async {
    setLoading(true);
    notifyListeners();

    final UpdateUserParams params = UpdateUserParams(
      uid: LocalAuth.uid ?? '',
      pushNotification: value,
    );

    final DataState<String> result = await _updateProfileDetailUsecase(params);

    setLoading(false);

    if (result is DataSuccess) {
      // ✅ Update LocalAuth and notify success
      LocalAuth.currentUser?.notification?.pushNotification = value;
      AppLog.info('profile_updated_successfully'.tr());
      notifyListeners();
    } else {
      // ❌ Failed — no change to LocalAuth
      AppLog.error(
        result.exception?.message ?? 'Unknown error',
        name: 'PushNotificationProvider.updateProfileDetail - else',
      );
      // Optionally show a message
      // ScaffoldMessenger.of(context).showSnackBar(...);
    }
  }
}
