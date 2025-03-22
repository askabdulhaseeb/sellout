import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';
import '../../../domain/entities/user_entity.dart';
import '../subwidgets/promo_grid_view_tile.dart';

class ProfilePromoGridview extends StatelessWidget {
  const ProfilePromoGridview({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          spacing: 4,
          children: <Widget>[
            Expanded(
              child: CustomTextFormField(
                hint: 'search'.tr(),
                controller: TextEditingController(),
              ),
            ),
            InDevMode(
              child: SizedBox(
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
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: 10, // Change this to the actual number of items
            itemBuilder: (BuildContext context, int index) {
              return const PromoGridViewTile();
            },
          ),
        ),
      ],
    );
  }
}
