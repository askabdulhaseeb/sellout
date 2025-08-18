import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/custom_elevated_button.dart';
import '../../../../../../../routes/app_linking.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../promo/data/source/local/local_promo.dart';
import '../../../../../promo/domain/entities/promo_entity.dart';
import '../../../../../promo/domain/usecase/get_promo_by_id_usecase.dart';
import '../../../../../promo/view/create_promo/screens/create_promo_screen.dart';
import '../../../../../promo/view/home_promo_screen/widgets/promo_gridview_tile.dart';
import '../../../domain/entities/user_entity.dart';
import '../../providers/profile_provider.dart';

class ProfilePromoGridview extends StatefulWidget {
  const ProfilePromoGridview({required this.user, super.key});
  final UserEntity? user;

  @override
  State<ProfilePromoGridview> createState() => _ProfilePromoGridviewState();
}

class _ProfilePromoGridviewState extends State<ProfilePromoGridview> {
  final TextEditingController _searchController = TextEditingController();
  List<PromoEntity> _allPromos = <PromoEntity>[];
  List<PromoEntity> _filteredPromos = <PromoEntity>[];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterPromos(_searchController.text);
    });
  }

  void _filterPromos(String query) {
    final String lowerQuery = query.toLowerCase();
    setState(() {
      _filteredPromos = _allPromos.where((PromoEntity promo) {
        return promo.title.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider pro =
        Provider.of<ProfileProvider>(context, listen: false);
    if (widget.user?.uid == null) {
      return const Center(child: Text('user_not_found'));
    }

    final GetPromoByIdUsecase getPromoByIdUsecase =
        GetPromoByIdUsecase(locator());

    return FutureBuilder<DataState<List<PromoEntity>>>(
      future: getPromoByIdUsecase(widget.user!.uid),
      initialData: LocalPromo().getByUserId(widget.user!.uid),
      builder: (BuildContext context,
          AsyncSnapshot<DataState<List<PromoEntity>>> snapshot) {
        if (!snapshot.hasData || snapshot.data?.entity == null) {
          Center(child: Text('no_promo_found'.tr()));
        }

        _allPromos = snapshot.data!.entity!;
        _allPromos.sort((PromoEntity a, PromoEntity b) =>
            b.createdAt.compareTo(a.createdAt));
        _filteredPromos = _searchController.text.isEmpty
            ? _allPromos
            : _allPromos
                .where((PromoEntity promo) => promo.title
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
                .toList();

        return Column(
          children: <Widget>[
            if (pro.user?.uid == LocalAuth.uid)
              _SearchBar(controller: _searchController),
            const SizedBox(height: 10),
            if (_filteredPromos.isEmpty)
              Center(child: Text('no_promo_found'.tr()))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredPromos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 0.84,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return PromoHomeGridViewTile(promo: _filteredPromos[index]);
                },
              ),
          ],
        );
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: CustomTextFormField(
            borderRadius: 4,
            dense: true,
            contentPadding: const EdgeInsets.all(6),
            fieldPadding: const EdgeInsets.all(0),
            hint: 'search'.tr(),
            style: TextTheme.of(context).bodyMedium,
            controller: controller,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: CustomElevatedButton(
            prefixSuffixPadding: const EdgeInsets.all(4),
            margin: const EdgeInsets.all(0),
            borderRadius: BorderRadius.circular(4),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
            isLoading: false,
            title: 'promo'.tr(),
            textStyle: TextStyle(
              fontSize: 12,
              color: colorScheme.onPrimary,
            ),
            prefix: Icon(
              CupertinoIcons.add_circled,
              size: 18,
              color: colorScheme.onPrimary,
            ),
            onTap: () {
              AppNavigator.pushNamed(CreatePromoScreen.routeName);
            },
          ),
        ),
      ],
    );
  }
}
