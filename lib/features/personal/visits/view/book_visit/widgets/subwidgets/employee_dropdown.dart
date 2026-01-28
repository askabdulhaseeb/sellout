import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/widgets/media/custom_network_image.dart';
import '../../../../../user/profiles/domain/entities/user_entity.dart';
import '../../provider/booking_provider.dart';

class EmployeeDropdown extends StatefulWidget {
  const EmployeeDropdown({required this.employeesID, super.key});
  final List<String> employeesID;

  @override
  EmployeeDropdownState createState() => EmployeeDropdownState();
}

class EmployeeDropdownState extends State<EmployeeDropdown> {
  @override
  void initState() {
    super.initState();
    final BookingProvider provider = Provider.of<BookingProvider>(
      context,
      listen: false,
    );
    provider.fetchEmployees(widget.employeesID);
  }

  @override
  Widget build(BuildContext context) {
    final BookingProvider provider = Provider.of<BookingProvider>(context);
    final List<UserEntity> employees = provider.employees;
    final UserEntity? selectedEmployee = provider.selectedEmployee;

    return employees.isEmpty
        ? const CircularProgressIndicator()
        : DropdownButton<UserEntity>(
            value: selectedEmployee,
            isExpanded: true,
            underline: Container(), // Remove default underline
            items: employees.map((UserEntity user) {
              return DropdownMenuItem<UserEntity>(
                value: user,
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomNetworkImage(
                        imageURL: user.profilePhotoURL ?? '',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          user.displayName,
                          style: TextTheme.of(context).titleMedium,
                        ),
                        Text(
                          user.username,
                          style: TextTheme.of(context).bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (UserEntity? newUser) {
              provider.setSelectedEmployee(newUser);
            },
          );
  }
}
