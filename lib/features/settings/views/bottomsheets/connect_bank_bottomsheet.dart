import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import '../../../../core/constants/app_spacings.dart';
import '../../../../core/sources/data_state.dart';
import '../../../../core/utilities/app_string.dart';
import '../../../../core/utilities/app_validators.dart';
import '../../../../core/widgets/app_snakebar.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_svg_icon.dart';
import '../../../../core/widgets/custom_textformfield.dart';
import '../../../../core/widgets/phone_number/views/countries_dropdown.dart';
import '../../../../services/get_it.dart';
import '../../../personal/setting/setting_dashboard/domain/params/create_account_session_params.dart';
import '../../../personal/setting/setting_dashboard/domain/usecase/connect_account_session_usecase.dart';

class LinkBankBottomSheet extends StatefulWidget {
  const LinkBankBottomSheet({super.key});

  @override
  State<LinkBankBottomSheet> createState() => LinkBankBottomSheetState();
}

class LinkBankBottomSheetState extends State<LinkBankBottomSheet> {
  final TextEditingController _emailController = TextEditingController();
  String? _selectedCountry;
  bool _isLoading = false;

  Future<void> _openStripeOnboarding(String url) async {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    try {
      await launchUrl(
        Uri.parse(url),
        customTabsOptions: CustomTabsOptions.partial(
          configuration: PartialCustomTabsConfiguration.adaptiveSheet(
            initialHeight: mediaQuery.size.height * 0.8,
            initialWidth: mediaQuery.size.width * 0.8,
            activitySideSheetMaximizationEnabled: true,
            activitySideSheetDecorationType:
                CustomTabsActivitySideSheetDecorationType.shadow,
            activitySideSheetRoundedCornersPosition:
                CustomTabsActivitySideSheetRoundedCornersPosition.top,
            cornerRadius: 16,
          ),
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions.pageSheet(
          entersReaderIfAvailable: true,
          configuration: const SheetPresentationControllerConfiguration(
            detents: <SheetPresentationControllerDetent>{
              SheetPresentationControllerDetent.large,
              SheetPresentationControllerDetent.medium,
            },
            prefersScrollingExpandsWhenScrolledToEdge: true,
            prefersGrabberVisible: true,
            prefersEdgeAttachedInCompactHeight: true,
          ),
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      AppSnackBar.showSnackBar(context, 'Error opening page: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ConnectAccountSessionUseCase getSessionUseCase =
        ConnectAccountSessionUseCase(locator());

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                // Title and icon
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 22,
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.1),
                      child: CustomSvgIcon(
                        assetPath: AppStrings.selloutProfileBankIcon,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.hMd),
                    Expanded(
                      child: Text(
                        'payouts_made_easy'.tr(),
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                // Email field
                CustomTextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  labelText: 'email'.tr(),
                  hint: 'email'.tr(),
                  validator: (String? value) => AppValidator.email(value),
                ),
                // Country dropdown
                CountryDropdownField(
                  onChanged: (String country) {
                    setState(() => _selectedCountry = country);
                  },
                  validator: (bool? value) =>
                      AppValidator.requireSelection(value),
                ),
                // Security info
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.verified, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "For your security, you'll complete bank setup on Stripe's official website. Your information is protected by Stripe.",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Link Bank Button
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.vMd),
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(theme.colorScheme.primary),
                            ),
                          ),
                        )
                      : CustomElevatedButton(
                          isLoading: false,
                          onTap: () async {
                            setState(() => _isLoading = true);
                            final String email = _emailController.text.trim();
                            final String country = _selectedCountry ?? '';
                            final ConnectAccountSessionParams params =
                                ConnectAccountSessionParams(email: email, country: country);
                            final DataState<String> result =
                                await getSessionUseCase.call(params);
                            final String url = result.entity ?? '';
                            setState(() => _isLoading = false);
                            if (url.isNotEmpty) {
                              if (mounted) Navigator.pop(context);
                              _openStripeOnboarding(url);
                            } else {
                              AppSnackBar.showSnackBar(context, 'something_wrong'.tr());
                            }
                          },
                          title: 'link_my_bank'.tr(),
                          bgColor: theme.colorScheme.primary,
                          textColor: theme.colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                ),
                // Encrypted info
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.lock_outline,
                        color: theme.colorScheme.primary.withOpacity(0.7),
                        size: 18,
                      ),
                      Flexible(
                        child: Text(
                          'bank_details_encrypted'.tr(),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
