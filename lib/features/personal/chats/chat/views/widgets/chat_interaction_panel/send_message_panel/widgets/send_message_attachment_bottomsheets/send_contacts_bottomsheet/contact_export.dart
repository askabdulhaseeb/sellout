import 'dart:io';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> exportContactAsVcf(Contact contact) async {
  try {
    final String vcf = contact.toVCard();
    final Directory dir = await getTemporaryDirectory();
    final File file = File('${dir.path}/${contact.displayName}.vcf');
    await file.writeAsString(vcf);
    return file;
  } catch (_) {
    return null;
  }
}
