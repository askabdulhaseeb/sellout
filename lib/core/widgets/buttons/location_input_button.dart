import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocationInputButton extends FormField<bool> {
  LocationInputButton({
    required FormFieldValidator<bool> validator,
    super.key,
  }) : super(
          validator: validator,
          builder: (FormFieldState<bool> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const _Widget(),
                if (state.hasError)
                  Text(
                    state.errorText ?? 'Null ERROR',
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            );
          },
        );
}

class _Widget extends StatelessWidget {
  const _Widget();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Icon(Icons.location_on, color: Theme.of(context).disabledColor),
                const SizedBox(width: 8),
                Text(
                  'select_location'.tr(),
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
