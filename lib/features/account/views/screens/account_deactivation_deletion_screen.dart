import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/sources/data_state.dart';
import '../../../personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../personal/user/profiles/domain/usecase/delete_user_usecase.dart';
import '../../domain/entities/account_action_type.dart';
import 'package:get_it/get_it.dart';
import '../widgets/account_action_card.dart';
import '../widgets/account_warning_banner.dart';

class AccountDeactivationDeletionScreen extends StatefulWidget {
  const AccountDeactivationDeletionScreen({super.key});

  static const String routeName = '/account/deactivation-deletion';

  @override
  State<AccountDeactivationDeletionScreen> createState() =>
      _AccountDeactivationDeletionScreenState();
}

class _AccountDeactivationDeletionScreenState
    extends State<AccountDeactivationDeletionScreen> {
  AccountActionType? _selectedOption;
  bool _showConfirmation = false;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: Color(0xFF1A1A1A)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'account_settings_title'.tr(),
                style: textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF1A1A1A),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'deactivate_or_delete_account'.tr(),
                style: textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF666666),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          centerTitle: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16),
              const AccountWarningBanner(),
              const SizedBox(height: 24),

              if (!_showConfirmation) ...<Widget>[
                AccountActionCard(
                  actionType: AccountActionType.deactivate,
                  isSelected: _selectedOption == AccountActionType.deactivate,
                  onTap: () => setState(
                    () => _selectedOption = AccountActionType.deactivate,
                  ),
                ),
                const SizedBox(height: 16),
                AccountActionCard(
                  actionType: AccountActionType.delete,
                  isSelected: _selectedOption == AccountActionType.delete,
                  onTap: () => setState(
                    () => _selectedOption = AccountActionType.delete,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomElevatedButton(
                        isLoading: false,
                        title: 'cancel'.tr(),
                        bgColor: Colors.white,
                        textColor: const Color(0xFF666666),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomElevatedButton(
                        isLoading: false,
                        title: 'continue'.tr(),
                        bgColor: _selectedOption == null
                            ? const Color(0xFFD0D0D0)
                            : (_selectedOption == AccountActionType.delete
                                  ? const Color(0xFFD32F2F)
                                  : const Color(0xFFF5A623)),
                        textColor: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        isDisable: _selectedOption == null,
                        onTap: _selectedOption == null
                            ? () {}
                            : () => setState(() => _showConfirmation = true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ] else ...<Widget>[
                _ConfirmationWidget(
                  actionType: _selectedOption!,
                  isProcessing: _isProcessing,
                  onCancel: () => setState(() => _showConfirmation = false),
                  onConfirm: () async {
                    setState(() => _isProcessing = true);
                    if (_selectedOption == AccountActionType.delete) {
                      final DeleteUserUsecase deleteUserUsecase =
                          GetIt.I<DeleteUserUsecase>();
                      // You may want to pass a userId or token here; using empty string for now
                      final DataState<bool?> result = await deleteUserUsecase
                          .call(LocalAuth.uid ?? '');
                      setState(() => _isProcessing = false);
                      if (result.exception != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result.exception!.message)),
                        );
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('account_deleted_successfully'.tr()),
                        ),
                      );
                      Navigator.of(
                        context,
                      ).popUntil((Route<dynamic> route) => route.isFirst);
                    } else {
                      setState(() => _isProcessing = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'deactivation_not_supported_error'.tr(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmationWidget extends StatelessWidget {
  const _ConfirmationWidget({
    required this.actionType,
    required this.onCancel,
    required this.onConfirm,
    this.isProcessing = false,
  });
  final AccountActionType actionType;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDelete = actionType == AccountActionType.delete;
    final Color cardBg = isDelete
        ? const Color(0xFFFFEBEE)
        : const Color(0xFFFFF8E1);
    final Color iconColor = isDelete
        ? const Color(0xFFD32F2F)
        : const Color(0xFFF5A623);
    final Color titleColor = iconColor;
    final String title = isDelete
        ? 'confirm_account_deletion'.tr()
        : 'confirm_account_deactivation'.tr();
    final String subtitle = 'please_review_before_proceeding'.tr();
    final List<_ConsequenceItem> consequences = isDelete
        ? <_ConsequenceItem>[
            _ConsequenceItem(
              Icons.person_off_rounded,
              'your_profile_and_all_personal_information_will_be_erased'.tr(),
            ),
            _ConsequenceItem(
              Icons.delete_forever,
              'all_posts_listings_and_photos_will_be_deleted'.tr(),
            ),
            _ConsequenceItem(
              Icons.chat_bubble_outline,
              'chat_history_and_messages_will_be_removed'.tr(),
            ),
            _ConsequenceItem(
              Icons.block,
              'you_will_not_be_able_to_recover_any_data'.tr(),
            ),
          ]
        : <_ConsequenceItem>[
            _ConsequenceItem(
              Icons.visibility_off,
              'your_profile_will_be_hidden_from_other_users'.tr(),
            ),
            _ConsequenceItem(
              Icons.remove_circle_outline,
              'your_posts_and_listings_will_be_temporarily_removed'.tr(),
            ),
            _ConsequenceItem(
              Icons.verified_user,
              'all_your_data_will_be_preserved_safely'.tr(),
            ),
            _ConsequenceItem(
              Icons.restore,
              'you_can_reactivate_anytime_by_logging_back_in'.tr(),
            ),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8, bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.warning_amber_rounded, size: 24, color: iconColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              ...consequences.map(
                (_ConsequenceItem c) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        c.icon,
                        size: 20,
                        color: isDelete
                            ? const Color(0xFFD32F2F)
                            : const Color(0xFF4CAF50),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          c.text,
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF555555),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: CustomElevatedButton(
                isLoading: false,
                title: 'go_back'.tr(),
                bgColor: Colors.white,
                textColor: const Color(0xFF666666),
                border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
                borderRadius: BorderRadius.circular(8),
                onTap: onCancel,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomElevatedButton(
                isLoading: isProcessing,
                title: isDelete ? 'delete_forever'.tr() : 'deactivate_now'.tr(),
                bgColor: isDelete
                    ? const Color(0xFFD32F2F)
                    : const Color(0xFFF5A623),
                textColor: Colors.white,
                borderRadius: BorderRadius.circular(8),
                onTap: isProcessing ? () {} : onConfirm,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Info Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDelete ? const Color(0xFFFFEBEE) : const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                isDelete ? Icons.error_outline : Icons.info_outline,
                size: 24,
                color: iconColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isDelete
                      ? 'account_deletion_is_permanent_and_irreversible'.tr()
                      : 'deactivation_is_temporary'.tr(),
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF555555),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConsequenceItem {
  const _ConsequenceItem(this.icon, this.text);
  final IconData icon;
  final String text;
}
