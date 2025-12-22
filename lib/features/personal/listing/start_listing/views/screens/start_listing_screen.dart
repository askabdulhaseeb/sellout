import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_spacings.dart';
import '../../../../../../core/widgets/scaffold/app_bar/app_bar_title_widget.dart';
import '../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../core/widgets/scaffold/personal_scaffold.dart';
import '../../../../../../core/widgets/searchable_textfield.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../auth/signin/domain/entities/address_entity.dart';
import '../../../../address/shipping_address/view/screens/selling_address_screen.dart';
import '../widgets/start_selling_list.dart';

class StartListingScreen extends StatefulWidget {
  const StartListingScreen({super.key});
  static const String routeName = '/add';

  @override
  State<StartListingScreen> createState() => _StartListingScreenState();
}

class _StartListingScreenState extends State<StartListingScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return PersonalScaffold(
      body: ValueListenableBuilder<AddressEntity?>(
        valueListenable: LocalAuth.sellingAddressNotifier,
        builder: (BuildContext context, AddressEntity? sellingAddress, _) {
          final bool hasSellingAddress = sellingAddress != null;
          final ColorScheme colorScheme = Theme.of(context).colorScheme;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                const AppBarTitle(titleKey: 'start_selling'),
                if (!hasSellingAddress) ...<Widget>[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'selling_address_required'.tr(),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'selling_address_required_desc'.tr(),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 100,
                          child: CustomElevatedButton(
                            mWidth: 100,
                            title: 'add_address'.tr(),
                            textStyle: TextTheme.of(context).labelMedium
                                ?.copyWith(color: colorScheme.onPrimary),
                            isLoading: false,
                            margin: EdgeInsets.zero,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSm,
                            ),
                            onTap: () => Navigator.of(
                              context,
                            ).pushNamed(SellingAddressScreen.routeName),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Opacity(
                  opacity: hasSellingAddress ? 1 : 0.35,
                  child: AbsorbPointer(
                    absorbing: !hasSellingAddress,
                    child: Column(
                      children: <Widget>[
                        SearchableTextfield(
                          padding: const EdgeInsets.only(top: 8, bottom: 4),
                          hintText: 'search_listing'.tr(),
                          onChanged: (String value) {
                            setState(() {
                              searchQuery = value.toLowerCase();
                            });
                          },
                        ),
                        StartSellingList(searchQuery: searchQuery),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
