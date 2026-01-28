import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../core/widgets/inputs/custom_textformfield.dart';
import '../../../setting_dashboard/view/providers/personal_setting_provider.dart';

class AutomaticResponseScreen extends StatefulWidget {
  const AutomaticResponseScreen({super.key});
  static const String routeName = '/automatic_response';

  @override
  State<AutomaticResponseScreen> createState() =>
      _AutomaticResponseScreenState();
}

class _AutomaticResponseScreenState extends State<AutomaticResponseScreen> {
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController messageController = TextEditingController();

  final DateFormat displayFormat = DateFormat('MMM dd yyyy');

  Future<void> _selectDate({
    required bool isStartDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final PersonalSettingProvider pro =
        Provider.of<PersonalSettingProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('automatic_response_title'.tr()),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'message_when_away'.tr(),
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 24),

          /// Start Date
          GestureDetector(
            onTap: () => _selectDate(isStartDate: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'start_date'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  startDate != null ? displayFormat.format(startDate!) : '--',
                  style: textTheme.bodyLarge
                      ?.copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          /// End Date
          GestureDetector(
            onTap: () => _selectDate(isStartDate: false),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'end_date'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  endDate != null ? displayFormat.format(endDate!) : '--',
                  style: textTheme.bodyLarge
                      ?.copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          /// Automatic Response Field
          CustomTextFormField(
            maxLength: 1000,
            isExpanded: true,
            labelText: 'automatic_response'.tr(),
            controller: messageController,
            maxLines: 5,
            hint: 'automatic_response_hint'.tr(),
            contentPadding: const EdgeInsets.all(12),
          ),
          CustomElevatedButton(
              title: 'apply'.tr(),
              isLoading: false,
              onTap: () {
                pro.updateTimeAwaySetting(
                    context: context,
                    endDate: DateFormat('MMMM dd yyyy').format(endDate!),
                    message: messageController.text.trim(),
                    startDate: DateFormat('MMMM dd yyyy').format(startDate!));
              })
        ],
      ),
    );
  }
}
