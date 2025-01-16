// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../auth/signin/domain/entities/address_entity.dart';

class AddEditAddressScreen extends StatefulWidget {
  const AddEditAddressScreen({
    this.initAddress,
    super.key,
  });

  final AddressEntity? initAddress;

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initAddress == null ? 'add_address'.tr() : 'edit_address'.tr(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Divider(),
            const Text(
              'add_a_delivery_or_pickup_address',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ).tr(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
