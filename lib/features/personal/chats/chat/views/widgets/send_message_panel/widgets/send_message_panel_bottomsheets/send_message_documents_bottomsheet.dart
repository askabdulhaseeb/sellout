import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../../../../../../../attachment/domain/entities/picked_attachment.dart';
import '../../../../providers/chat_provider.dart';

Future<void> pickDocument(BuildContext context) async {
      ChatProvider pro =  Provider.of<ChatProvider>(context,listen:false);

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: <String>['pdf', 'doc', 'docx', 'txt'],
  );

  if (result != null && result.files.single.path != null) {
    File file = File(result.files.single.path!);
   final PickedAttachment attachment = PickedAttachment(file: file,type: AttachmentType.document);
pro.addAttachment(attachment);
pro.sendMessage(context);
    // Use the `file` here as you want,
    // like send it to a provider, upload to server, etc.
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No document selected')),
    );
  }
}
