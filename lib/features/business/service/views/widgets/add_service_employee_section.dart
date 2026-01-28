import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/media/profile_photo.dart';
import '../../../../personal/auth/signin/data/sources/local/local_auth.dart';
import '../../../../personal/user/profiles/data/sources/local/local_user.dart';
import '../../../core/domain/entity/business_employee_entity.dart';
import '../providers/add_service_provider.dart';

class AddServiceEmployeeSection extends StatelessWidget {
  const AddServiceEmployeeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BusinessEmployeeEntity> employeeList =
        LocalAuth.currentUser?.employeeList ?? <BusinessEmployeeEntity>[];

    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${'assign_employees'.tr()}:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          height: 54,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: employeeList.length,
            itemBuilder: (BuildContext context, int index) {
              final BusinessEmployeeEntity employee = employeeList[index];
              final bool isSelected = context
                  .watch<AddServiceProvider>()
                  .selectedEmployeeUIDs
                  .contains(employee.uid);

              return _EmployeeTile(
                employee: employee,
                isSelected: isSelected,
                onTap: () {
                  context.read<AddServiceProvider>().toggleSelection(
                    employee.uid,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({
    required this.employee,
    required this.isSelected,
    required this.onTap,
  });

  final BusinessEmployeeEntity employee;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(8);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: FutureBuilder<UserEntity?>(
          future: LocalUser().user(employee.uid),
          builder: (BuildContext context, AsyncSnapshot<UserEntity?> snapshot) {
            final UserEntity? user = snapshot.data;

            return Container(
              width: 120,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2)
                    : Theme.of(context).dividerColor,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
                borderRadius: borderRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: ProfilePhoto(
                      url: user?.profilePhotoURL,
                      placeholder: user?.displayName ?? '/',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      user?.displayName ?? 'na'.tr(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
