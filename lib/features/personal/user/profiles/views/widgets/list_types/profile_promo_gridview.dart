import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../promo/data/source/local/local_promo.dart';
import '../../../../../promo/domain/entities/promo_entity.dart';
import '../../../../../promo/domain/usecase/get_promo_by_id_usecase.dart';
import '../../../../../promo/view/create_promo/screens/create_promo_screen.dart';
import '../../../../../promo/view/home_promo_screen/widgets/promo_gridview_tile.dart';
import '../../../domain/entities/user_entity.dart';

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
    if (widget.user?.uid == null) {
      return const Center(child: Text('User not found'));
    }

    final GetPromoByIdUsecase getPromoByIdUsecase =
        GetPromoByIdUsecase(locator());

    return FutureBuilder<DataState<List<PromoEntity>>>(
      future: getPromoByIdUsecase(widget.user!.uid),
      initialData: LocalPromo().getByUserId(widget.user!.uid),
      builder: (BuildContext context,
          AsyncSnapshot<DataState<List<PromoEntity>>> snapshot) {
        if (!snapshot.hasData || snapshot.data?.entity == null) {
          return const Center(child: Text('No promos found'));
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
            _SearchBar(controller: _searchController),
            const SizedBox(height: 10),
            if (_filteredPromos.isEmpty)
              const Center(child: Text('no_promo_found'))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredPromos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
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
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomTextFormField(
            hint: 'search'.tr(),
            contentPadding: EdgeInsets.zero,
            controller: controller,
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          height: 50,
          width: 100,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(2),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            icon: Icon(
              CupertinoIcons.add_circled,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            label: Text('promo'.tr()),
            onPressed: () {
              Navigator.pushNamed(context, CreatePromoScreen.routeName);
            },
          ),
        ),
      ],
    );
  }
}
