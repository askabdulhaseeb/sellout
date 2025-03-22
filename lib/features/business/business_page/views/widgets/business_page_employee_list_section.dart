import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/profile_photo.dart';
import '../../../../personal/user/profiles/data/sources/local/local_user.dart';
import '../../../core/domain/entity/business_employee_entity.dart';
import '../../../core/domain/entity/business_entity.dart';

class BusinessPageEmployeeListSection extends StatelessWidget {
  const BusinessPageEmployeeListSection({required this.business, super.key});
  final BusinessEntity business;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: business.employees?.length,
        itemBuilder: (BuildContext context, int index) {
          final BusinessEmployeeEntity employee = business.employees![index];
          return _EmployeeTile(employee);
        },
      ),
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile(this.employee);
  final BusinessEmployeeEntity employee;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(8);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          // TODO: SELECT EMPLOYEE
        },
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
                color: Theme.of(context).dividerColor,
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
