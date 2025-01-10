import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/enums/business/services/service_category_type.dart';
import '../../../../../core/enums/business/services/service_model_type.dart';
import '../../../../../core/functions/app_log.dart';
import '../../../../../core/functions/permission_fun.dart';
import '../../../../../core/sources/api_call.dart';
import '../../../../../core/widgets/app_snakebar.dart';
import '../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../attachment/domain/entities/picked_attachment_option.dart';
import '../../../../attachment/views/screens/pickable_attachment_screen.dart';
import '../../../core/domain/entity/business_entity.dart';
import '../../domain/params/add_service_param.dart';
import '../../domain/usecase/add_service_usecase.dart';

class AddServiceProvider extends ChangeNotifier {
  AddServiceProvider(this._addServiceUsecase);
  final AddServiceUsecase _addServiceUsecase;

  Future<void> addService(BuildContext context) async {
    try {
      final AddServiceParam param = AddServiceParam(
        name: _title.text,
        category: _selectedCategory,
        type: _selectedType,
        model: _selectedModelType,
        hours: _selectedHour,
        mints: _selectedMinute,
        price: _price.text,
        businessID: _business?.businessID ?? '',
        currency: '',
        description: _description.text,
        included: _included.text,
        excluded: _notIncluded.text,
        attachments: attachments,
        isMobile: _isMobileService,
      );
      isLoading = true;
      final DataState<bool> result = await _addServiceUsecase(param);
      if (result is DataSuccess) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } else {
        AppSnackBar.showSnackBar(
          // ignore: use_build_context_synchronously
          context,
          result.exception?.message ?? 'something-wrong'.tr(),
        );
        AppLog.error(
          result.exception?.message ?? 'something-wrong'.tr(),
          name: 'AddServiceProvider.addService - error',
          error: result.exception,
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'AddServiceProvider.addService - catch',
        error: e,
      );
    }
    isLoading = false;
  }

  Future<void> addPhotos(BuildContext context) async {
    //
    final bool hasPersmission =
        await PermissionFun.hasPermission(Permission.photos);
    if (!hasPersmission) return;
    //
    final List<PickedAttachment>? newPhotos = await Navigator.of(context).push(
      MaterialPageRoute<List<PickedAttachment>>(
        builder: (BuildContext context) => PickableAttachmentScreen(
          option: PickableAttachmentOption(
            maxAttachments: 10,
            type: AttachmentType.image,
            selectedMedia: _attachments
                .map((PickedAttachment e) => e.selectedMedia!)
                .toList(),
          ),
        ),
      ),
    );
    if (newPhotos == null) return;
    for (final PickedAttachment photo in newPhotos) {
      // if (!_attachments.any(
      //     (PickedAttachment e) => e.selectedMedia == photo.selectedMedia)) {
      // }
      _attachments.add(photo);
    }
    notifyListeners();
  }

  void removePhoto(PickedAttachment photo) {
    _attachments.remove(photo);
    notifyListeners();
  }

  void reset() {
    _business = null;
    _selectedCategory = null;
    _selectedType = null;
    _selectedModelType = null;
    _title.clear();
    _price.clear();
    _description.clear();
    _included.clear();
    _notIncluded.clear();
    _attachments.clear();
    _selectedHour = null;
    _selectedMinute = null;
    _isMobileService = false;
    _isLoading = false;
  }

  //
  //
  // PROPERTIES
  BusinessEntity? _business;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _included = TextEditingController();
  final TextEditingController _notIncluded = TextEditingController();
  final List<PickedAttachment> _attachments = <PickedAttachment>[];
  ServiceCategoryType? _selectedCategory;
  ServiceType? _selectedType;
  ServiceModelType? _selectedModelType;
  //
  int? _selectedHour;
  int? _selectedMinute;
  //
  bool _isMobileService = false;
  bool _isLoading = false;
  //
  //
  // GETTERS
  BusinessEntity? get business => _business;
  TextEditingController get title => _title;
  TextEditingController get price => _price;
  TextEditingController get description => _description;
  TextEditingController get included => _included;
  TextEditingController get notIncluded => _notIncluded;
  List<PickedAttachment> get attachments => _attachments;
  ServiceCategoryType? get selectedCategory => _selectedCategory;
  ServiceType? get selectedType => _selectedType;
  ServiceModelType? get selectedModelType => _selectedModelType;
  //
  int? get selectedHour => _selectedHour;
  int? get selectedMinute => _selectedMinute;
  //
  bool get isMobileService => _isMobileService;
  bool get isLoading => _isLoading;
  //
  //
  // SETTERS
  void setBusiness(BusinessEntity? value) {
    _business = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setSelectedCategory(ServiceCategoryType? value) {
    _selectedCategory = value;
    _selectedType = null;
    notifyListeners();
  }

  void setSelectedType(ServiceType? value) {
    _selectedType = value;
    notifyListeners();
  }

  void setSelectedModelType(ServiceModelType? value) {
    _selectedModelType = value;
    notifyListeners();
  }

  void setSelectedHour(int? value) {
    _selectedHour = value;
    notifyListeners();
  }

  void setSelectedMinute(int? value) {
    _selectedMinute = value;
    notifyListeners();
  }

  void setIsMobileService(bool value) {
    _isMobileService = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
