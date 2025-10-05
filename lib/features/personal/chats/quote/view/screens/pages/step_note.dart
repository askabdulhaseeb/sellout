import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/custom_textformfield.dart';
import '../../provider/quote_provider.dart';

class StepNote extends StatelessWidget {
  const StepNote({super.key});
  @override
  Widget build(BuildContext context) {
    final QuoteProvider pro = Provider.of<QuoteProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            /// Input field for note
            CustomTextFormField(
              labelText: 'add_note_or_preference'.tr(),
              isExpanded: true,
              controller: pro.note,
              maxLines: 6,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
