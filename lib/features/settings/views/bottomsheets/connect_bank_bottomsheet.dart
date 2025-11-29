import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/sources/data_state.dart';
import '../../../../core/constants/app_spacings.dart';
import '../../../../core/utilities/app_string.dart';
import '../../../../core/utilities/app_validators.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_svg_icon.dart';
import '../../../../core/widgets/custom_textformfield.dart';
import '../../../../core/widgets/phone_number/domain/entities/country_entity.dart';
import '../../../../core/widgets/phone_number/views/countries_dropdown.dart';
import '../../../../services/get_it.dart';
import '../../../personal/setting/setting_dashboard/domain/params/create_account_session_params.dart';
import '../../../personal/setting/setting_dashboard/domain/usecase/connect_account_session_usecase.dart';
import '../screens/stripe_onboarding_screen.dart';

class LinkBankBottomSheet extends StatefulWidget {
  const LinkBankBottomSheet({super.key});

  @override
  State<LinkBankBottomSheet> createState() => _LinkBankBottomSheetState();
}

class _LinkBankBottomSheetState extends State<LinkBankBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  CountryEntity? _selectedCountry;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final ConnectAccountSessionUseCase getSessionUseCase =
        ConnectAccountSessionUseCase(locator());

    final ConnectAccountSessionParams params = ConnectAccountSessionParams(
      email: _emailController.text.trim(),
      country: _selectedCountry?.shortName ?? '',
    );

    final DataState<String> result = await getSessionUseCase.call(params);
    setState(() => _isLoading = false);

    final String url = result.entity ?? '';

    if (url.isNotEmpty && mounted) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute<StripeOnboardingScreen>(
          builder: (_) => StripeOnboardingScreen(url: url),
        ),
      );
    } else {
      AppSnackBar.showSnackBar(
        context,
        'something_wrong'.tr(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: AppSpacing.vMd),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: theme.iconTheme.color),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 26,
                        backgroundColor:
                            theme.colorScheme.primary.withValues(alpha: 0.1),
                        child: CustomSvgIcon(
                          assetPath: AppStrings.selloutProfileBankIcon,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.hMd),
                      Expanded(
                        child: Text(
                          'payouts_made_easy'.tr(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.vMd),
                  CustomTextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'email'.tr(),
                    hint: 'email'.tr(),
                    validator: AppValidator.email,
                  ),
                  const SizedBox(height: AppSpacing.vMd),
                  CountryDropdownField(
                    initialValue: _selectedCountry,
                    onChanged: (CountryEntity country) {
                      setState(() => _selectedCountry = country);
                    },
                    validator: (_) {
                      if (_selectedCountry == null ||
                          _selectedCountry!.countryCode.isEmpty) {
                        return 'please_select_country'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.vMd),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      isLoading: _isLoading,
                      onTap: _submit,
                      title: 'link_my_bank'.tr(),
                      bgColor: theme.colorScheme.primary,
                      textColor: theme.colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.vMd),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            'bank_details_encrypted'.tr(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
