import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/costom_textformfield.dart';
import '../../../../../../core/widgets/custom_drop_down.dart';
import '../../data/models/user_model.dart';

class ProfileFilterSection extends StatelessWidget {
  const ProfileFilterSection({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: CustomTextFormField(
              isExpanded: true,
              contentPadding: const EdgeInsets.all(4),
              controller: TextEditingController(),
              hint: 'search'.tr(),
              style: textTheme.bodySmall,
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
                height: 50,
                child: CustomDropdown(
                  hint: 'Select Category',
                  items: const <String>['Category', 'Option 1', 'Option 2'],
                  value: 'Category',
                  onChanged: (String? value) {},
                )),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: CustomFilterButton(
                  onPressed: () {}, label: 'filter'.tr(), icon: Icons.tune)),
        ],
      ),
    );
  }
}

class CustomFilterButton extends StatelessWidget {
  const CustomFilterButton({
    required this.onPressed,
    required this.label,
    required this.icon,
    super.key,
  });
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: textTheme.labelMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
