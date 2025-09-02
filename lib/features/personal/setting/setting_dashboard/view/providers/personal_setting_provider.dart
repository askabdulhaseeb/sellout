import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/functions/app_log.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/phone_number/domain/entities/phone_number_entity.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../user/profiles/domain/usecase/edit_profile_detail_usecase.dart';
import '../../../../user/profiles/views/params/update_user_params.dart';
import '../../data/models/privacy_setting_model.dart';
import '../../data/models/time_away_model.dart';

class PersonalSettingProvider extends ChangeNotifier {
  PersonalSettingProvider(this._updateProfileDetailUsecase);
  final UpdateProfileDetailUsecase _updateProfileDetailUsecase;

  ///VARIBALES
  // Notification Settings
  bool enablePhoneNotification =
      LocalAuth.currentUser?.notification?.pushNotification ?? false;
  bool enableEmailNotification =
      LocalAuth.currentUser?.notification?.emailNotification ?? false;
  // Other Notification Toggles (UI only)
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
  // Privacy Settings
  bool thirdPartyTracking =
      LocalAuth.currentUser?.privacySettings?.thirdPartyTracking ?? false;
  bool personalizedContent =
      LocalAuth.currentUser?.privacySettings?.personalizedContent ?? true;
  // Update account
  String? _name;
  DateTime? _dob;
  PhoneNumberEntity? _phone;
  String? _country;
  String? _gender;
  String? _language;

  //
  bool _isLoading = false;

  /// Getters
  bool get isLoading => _isLoading;
  // account varibales
  String? get name => _name;
  DateTime? get dob => _dob;
  PhoneNumberEntity? get phone => _phone;
  String? get country => _country;
  String? get gender => _gender;
  String? get language => _language;

  /// Setters
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setName(String? value) => _name = value;
  void setDob(DateTime? value) => _dob = value;
  void setPhone(PhoneNumberEntity? value) => _phone = value;
  void setCountry(String? value) => _country = value;
  void setGender(String? value) => _gender = value;

  void setLanguage(String? value) => _language = value;

  /// Toggles (UI Only)
  void toggleSellOutUpdates(bool value) =>
      _toggle(value, () => sellOutUpdates = value);
  void toggleMarketingCommunications(bool value) =>
      _toggle(value, () => marketingCommunications = value);
  void toggleNewMessages(bool value) =>
      _toggle(value, () => newMessages = value);
  void toggleNewFeedback(bool value) =>
      _toggle(value, () => newFeedback = value);
  void toggleReducedItems(bool value) =>
      _toggle(value, () => reducedItems = value);
  void toggleFavouritedItems(bool value) =>
      _toggle(value, () => favouritedItems = value);
  void toggleNewFollowers(bool value) =>
      _toggle(value, () => newFollowers = value);
  void toggleNewItems(bool value) => _toggle(value, () => newItems = value);
  void toggleMentions(bool value) => _toggle(value, () => mentions = value);
  void toggleForumMessages(bool value) =>
      _toggle(value, () => forumMessages = value);

  void _toggle(bool value, VoidCallback action) {
    action();
    notifyListeners();
  }

  // Privacy Toggles
  Future<void> toggleThirdPartyTracking(bool value) async {
    setLoading(true);
    final DataState<String> result = await _updateProfileDetailUsecase(
      UpdateUserParams(
        privacySettings: PrivacySettingsModel(thirdPartyTracking: value),
      ),
    );
    setLoading(false);

    if (result is DataSuccess) {
      thirdPartyTracking = value;
      LocalAuth.currentUser?.privacySettings = LocalAuth
          .currentUser?.privacySettings
          ?.copyWith(thirdPartyTracking: value);
      AppLog.info('privacy_settings_updated'.tr());
    } else {
      AppLog.error(result.exception?.message ?? 'Unknown error');
    }
    notifyListeners();
  }

  Future<void> togglePersonalizedContent(bool value) async {
    setLoading(true);
    final DataState<String> result = await _updateProfileDetailUsecase(
      UpdateUserParams(
        privacySettings: PrivacySettingsModel(
          personalizedContent: value,
        ),
      ),
    );
    setLoading(false);

    if (result is DataSuccess) {
      personalizedContent = value;
      LocalAuth.currentUser?.privacySettings = LocalAuth
          .currentUser?.privacySettings
          ?.copyWith(personalizedContent: value);
      AppLog.info('privacy_settings_updated'.tr());
    } else {
      AppLog.error(result.exception?.message ?? 'Unknown error');
    }
    notifyListeners();
  }

  // Push Notification Toggle
  Future<void> togglePushNotification(bool value) async {
    setLoading(true);
    final DataState<String> result = await _updateProfileDetailUsecase(
      UpdateUserParams(
        pushNotification: value,
      ),
    );
    setLoading(false);

    if (result is DataSuccess) {
      enablePhoneNotification = value;
      LocalAuth.currentUser?.notification?.pushNotification = value;
      AppLog.info('push_notification_updated'.tr());
    } else {
      AppLog.error(result.exception?.message ?? 'Unknown error');
    }
    notifyListeners();
  }

  // Email Notification Toggle
  Future<void> toggleEmailNotification(bool value) async {
    setLoading(true);
    final DataState<String> result = await _updateProfileDetailUsecase(
      UpdateUserParams(
        emailNotification: value,
      ),
    );
    setLoading(false);

    if (result is DataSuccess) {
      enableEmailNotification = value;
      LocalAuth.currentUser?.notification?.emailNotification = value;
      AppLog.info('email_notification_updated'.tr());
    } else {
      AppLog.error(result.exception?.message ?? 'Unknown error');
    }
    notifyListeners();
  }

  // Time Away
  Future<void> updateTimeAwaySetting({
    required BuildContext context,
    required String startDate,
    required String endDate,
    required String message,
  }) async {
    setLoading(true);
    final TimeAwayModel timeAway =
        TimeAwayModel(startDate: startDate, endDate: endDate, message: message);
    final DataState<String> result = await _updateProfileDetailUsecase(
      UpdateUserParams(timeAway: timeAway),
    );
    setLoading(false);
    if (result is DataSuccess) {
      LocalAuth.currentUser?.copyWith(timeAway: timeAway);
      AppLog.info('time_away_updated');
      Navigator.pop(context);
    } else {
      AppLog.error(result.exception?.message ?? 'Unknown error');
    }
    notifyListeners();
  }

  // UpdateProfile
  Future<void> updateProfileDetail(BuildContext context) async {
    setLoading(true);

    final UpdateUserParams params = UpdateUserParams(
      name: _name,
      dob: _dob,
      phone: _phone,
    );

    final DataState<String> result = await _updateProfileDetailUsecase(params);

    if (result is DataSuccess) {
      AppLog.info('profile_updated_successfully'.tr());
      LocalAuth.currentUser?.copyWith(dob: _dob);
      LocalAuth.currentUser?.copyWith(
          phoneNumber: _phone?.number, countryCode: _phone?.countryCode);
      LocalAuth.currentUser?.copyWith(displayName: _name);

      if (context.mounted) Navigator.pop(context);
    } else {
      AppLog.error(result.exception!.message,
          name: 'ProfileProvider.updateProfileDetail - error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('something_wrong'.tr())),
      );
    }

    setLoading(false);
  }
}
