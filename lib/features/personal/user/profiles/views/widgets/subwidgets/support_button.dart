import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/functions/app_log.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../domain/entities/supporter_detail_entity.dart';
import '../../../domain/usecase/add_remove_supporter_usecase.dart';
import '../../params/add_remove_supporter_params.dart';

class SupportButton extends StatefulWidget {
  const SupportButton(
      {required this.supporterId,
      super.key,
      this.supportingColor,
      this.supportColor,
      this.supportTextColor,
      this.supportingTextColor});

  final String supporterId;
  final Color? supportingColor;
  final Color? supportColor;
  final Color? supportTextColor;
  final Color? supportingTextColor;

  @override
  State<SupportButton> createState() => _SupportButtonState();
}

class _SupportButtonState extends State<SupportButton> {
  bool isLoading = false;
  final AddRemoveSupporterUsecase _addRemoveSupporterUsecase =
      locator<AddRemoveSupporterUsecase>();

  // Getter for real-time supporting status
  bool get isSupporting {
    return (LocalAuth.currentUser?.supporting ?? <SupporterDetailEntity>[])
        .any((SupporterDetailEntity e) => e.userID == widget.supporterId);
  }

  Future<void> _handleSupport() async {
    setState(() => isLoading = true);

    try {
      final AddRemoveSupporterParams params = AddRemoveSupporterParams(
        action: isSupporting ? SupporterAction.unfollow : SupporterAction.add,
        supporterId: widget.supporterId,
      );

      final DataState<String> result = await _addRemoveSupporterUsecase(params);

      if (result is DataSuccess) {
        AppLog.info(
            isSupporting ? 'supporter_removed'.tr() : 'supporter_added'.tr());
      } else {
        AppLog.error(
          result.exception?.reason ?? 'Unknown error',
          name: 'SupportButton_handleSupport',
        );
      }
    } catch (e) {
      AppLog.error(
        e.toString(),
        name: 'SupportButton_handleSupport',
      );
    } finally {
      // Always update UI after operation
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: CustomElevatedButton(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(6),
        bgColor: isSupporting
            ? (widget.supportingColor ??
                AppTheme.secondaryColor.withValues(alpha: 0.1))
            : (widget.supportColor ??
                AppTheme.primaryColor.withValues(alpha: 0.1)),
        textStyle: TextTheme.of(context).labelMedium?.copyWith(
              color: isSupporting
                  ? (widget.supportingTextColor ??
                      ColorScheme.of(context).secondary)
                  : (widget.supportingTextColor ??
                      ColorScheme.of(context).primary),
            ),
        title: isSupporting ? 'supporting'.tr() : 'support'.tr(),
        onTap: _handleSupport,
        isLoading: isLoading,
      ),
    );
  }
}
