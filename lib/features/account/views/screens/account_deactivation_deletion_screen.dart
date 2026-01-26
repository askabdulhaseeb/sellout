import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../../domain/entities/account_action_type.dart';
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
                'Account Settings',
                style: textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF1A1A1A),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Deactivate or delete account',
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
                        title: 'Cancel',
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
                        title: 'Continue',
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
                  onCancel: () => setState(() => _showConfirmation = false),
                  onConfirm: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _selectedOption == AccountActionType.delete
                              ? 'account_deleted_successfully'
                              : 'account_deactivated_successfully',
                        ),
                      ),
                    );
                    Navigator.of(context).popUntil((Route<dynamic> route) => route.isFirst);
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
  });
  final AccountActionType actionType;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

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
        ? 'Confirm Account Deletion'
        : 'Confirm Deactivation';
    final String subtitle = 'Please review before proceeding';
    final List<_ConsequenceItem> consequences = isDelete
        ? <_ConsequenceItem>[
            _ConsequenceItem(
              Icons.person_off_rounded,
              'Your profile and all personal information will be erased',
            ),
            _ConsequenceItem(
              Icons.delete_forever,
              'All posts, listings, and photos will be deleted',
            ),
            _ConsequenceItem(
              Icons.chat_bubble_outline,
              'Chat history and messages will be removed',
            ),
            _ConsequenceItem(
              Icons.block,
              'You will not be able to recover any data',
            ),
          ]
        : <_ConsequenceItem>[
            _ConsequenceItem(
              Icons.visibility_off,
              'Your profile will be hidden from other users',
            ),
            _ConsequenceItem(
              Icons.remove_circle_outline,
              'Your posts and listings will be temporarily removed',
            ),
            _ConsequenceItem(
              Icons.verified_user,
              'All your data will be preserved safely',
            ),
            _ConsequenceItem(
              Icons.restore,
              'You can reactivate anytime by logging back in',
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
                title: 'Go Back',
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
                isLoading: false,
                title: isDelete ? 'Delete Forever' : 'Deactivate Now',
                bgColor: isDelete
                    ? const Color(0xFFD32F2F)
                    : const Color(0xFFF5A623),
                textColor: Colors.white,
                borderRadius: BorderRadius.circular(8),
                onTap: onConfirm,
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
                      ? 'Account deletion is permanent and irreversible. Make sure to download any data you want to keep before proceeding. This action cannot be undone.'
                      : 'Deactivation is temporary. Your account will be hidden but all your data, posts, and settings will be preserved. Simply log back in to reactivate your account at any time.',
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
