import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/domain/entity/business_entity.dart';
import '../providers/add_service_provider.dart';
import '../widgets/add_service_attachment_section.dart';
import '../widgets/add_service_button_section.dart';
import '../widgets/add_service_description_section.dart';
import '../widgets/add_service_dropdown_section.dart';
import '../widgets/add_service_employee_section.dart';
import '../widgets/add_service_time_and_price_section.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});
  static const String routeName = '/add_service';

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // Provider.of<AddServiceProvider>(context, listen: false).reset();
    // Provider.of<AddServiceProvider>(context, listen: false)
    //     .setBusiness(business);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final BusinessEntity? business =
        ModalRoute.of(context)?.settings.arguments as BusinessEntity?;
    Provider.of<AddServiceProvider>(context, listen: false)
        .setBusiness(business);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final AddServiceProvider pro =
        Provider.of<AddServiceProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            pro.currentService?.serviceID == null
                ? 'add_service'.tr()
                : 'edit_service'.tr(),
            style: TextTheme.of(context).titleMedium,
          ),
          centerTitle: true),
      body: Form(
        key: _formKey,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AddServiceDropdownSection(),
                AddServiceTimeAndPriceSection(),
                AddServiceDescriptionSection(),
                AddServiceAttachmentSection(),
                AddServiceEmployeeSection(),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: BottomAppBar(
        height: 90,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: AddServiceButtonSection(
          formKey: _formKey,
        ),
      ),
    );
  }
}
