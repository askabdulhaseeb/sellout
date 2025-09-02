import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/profile_photo.dart';
import '../../../../personal/user/profiles/data/sources/local/local_user.dart';
import '../../../core/domain/entity/business_employee_entity.dart';
import '../../../core/domain/entity/business_entity.dart';
import '../providers/business_page_provider.dart';

class BusinessPageEmployeeListSection extends StatefulWidget {
  const BusinessPageEmployeeListSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  State<BusinessPageEmployeeListSection> createState() =>
      _BusinessPageEmployeeListSectionState();
}

class _BusinessPageEmployeeListSectionState
    extends State<BusinessPageEmployeeListSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessPageProvider>(
      builder: (BuildContext context, BusinessPageProvider pro, Widget? child) {
        final List<BusinessEmployeeEntity> employees =
            widget.business.employees ?? <BusinessEmployeeEntity>[];
        // Select first employee by default if not already selected
        if (employees.isNotEmpty && pro.employeeId == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pro.employeeId = employees.first.uid;
            pro.getServicesByQuery();
          });
        }
        return SizedBox(
          height: 54,
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: employees.length,
            itemBuilder: (BuildContext context, int index) {
              final BusinessEmployeeEntity employee = employees[index];
              return _EmployeeTile(
                employee,
                isSelected: employee.uid == pro.employeeId,
                onTap: () {
                  pro.employeeId = employee.uid;
                  pro.getServicesByQuery();
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile(
    this.employee, {
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
          builder: (
            BuildContext context,
            AsyncSnapshot<UserEntity?> snapshot,
          ) {
            final UserEntity? user = snapshot.data;
            return Container(
              width: 120,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                    : Theme.of(context).dividerColor.withValues(alpha: 0.6),
                borderRadius: borderRadius,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 1,
                ),
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
                      style: Theme.of(context).textTheme.bodySmall,
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
