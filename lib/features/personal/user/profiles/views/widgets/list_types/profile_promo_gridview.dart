import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../promo/domain/entities/promo_entity.dart';
import '../../../../../promo/domain/usecase/get_promo_by_id_usecase.dart';
import '../../../../../promo/view/screens/create_promo_screen.dart';
import '../../../domain/entities/user_entity.dart';
import '../subwidgets/promo_grid_view_tile.dart';

class ProfilePromoGridview extends StatefulWidget {
  const ProfilePromoGridview({
    required this.user,
    super.key,
  });

  final UserEntity? user;

  @override
  State<ProfilePromoGridview> createState() => _ProfilePromoGridviewState();
}

class _ProfilePromoGridviewState extends State<ProfilePromoGridview> {
  final TextEditingController _searchController = TextEditingController();
  final List<PromoEntity> _allPromos = <PromoEntity>[];
  List<PromoEntity> _filteredPromos = <PromoEntity>[];
  bool _isLoading = true;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _loadPromos();
    _searchController.addListener(() {
      _filterPromos(_searchController.text);
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPromos() async {
    if (widget.user?.uid == null) {
      _safeSetState(() {
        _isLoading = false;
      });
      return;
    }

    final GetPromoByIdUsecase getPromoByIdUsecase =
        GetPromoByIdUsecase(locator());
    final DataState<List<PromoEntity>> result =
        await getPromoByIdUsecase(widget.user!.uid);

    if (_isDisposed) return;

    if (result.entity != null) {
      _allPromos
        ..clear()
        ..addAll(result.entity!);
      _allPromos.sort(
          (PromoEntity a, PromoEntity b) => b.createdAt.compareTo(a.createdAt));
      _filteredPromos = List<PromoEntity>.from(_allPromos);
    }

    _safeSetState(() {
      _isLoading = false;
    });
  }

  void _filterPromos(String query) {
    final String lowerQuery = query.toLowerCase();
    _safeSetState(() {
      _filteredPromos = _allPromos.where((PromoEntity promo) {
        final String title = promo.title?.toLowerCase() ?? '';
        return title.contains(lowerQuery);
      }).toList();
    });
  }

  void _safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) {
      setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.user?.uid == null) {
      return const Center(child: Text('User not found'));
    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: CustomTextFormField(
                contentPadding: EdgeInsets.zero,
                hint: 'search'.tr(),
                controller: _searchController,
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              height: 50,
              width: 100,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.all(2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
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
        ),
        const SizedBox(height: 10),
        if (_filteredPromos.isEmpty)
          const Center(child: Text('No promos found'))
        else
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: _filteredPromos.length,
            itemBuilder: (BuildContext context, int index) {
              return PromoGridViewTile(promo: _filteredPromos[index]);
            },
          ),
      ],
    );
  }
}
