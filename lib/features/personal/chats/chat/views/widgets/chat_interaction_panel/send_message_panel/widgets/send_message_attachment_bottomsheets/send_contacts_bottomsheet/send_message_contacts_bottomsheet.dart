import 'package:flutter/material.dart';
import 'contact_bottomsheet_view.dart';

void showContactsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    showDragHandle: false,
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    builder: (BuildContext context) => const ContactsBottomSheetView(),
  );
}
