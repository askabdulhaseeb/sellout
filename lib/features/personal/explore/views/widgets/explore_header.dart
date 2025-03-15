import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/costom_textformfield.dart';

class ExploreHeader extends StatelessWidget {
  const ExploreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: CustomTextFormField(
                hint: 'search'.tr(),
                controller: TextEditingController(),
                prefixIcon: const Icon(CupertinoIcons.search),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: primaryColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(CupertinoIcons.eye_slash,
                  color: Theme.of(context).colorScheme.onSurface, size: 26),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
