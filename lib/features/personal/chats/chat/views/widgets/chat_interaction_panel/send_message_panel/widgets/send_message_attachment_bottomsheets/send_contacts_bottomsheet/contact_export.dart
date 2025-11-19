import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../../../../../../user/profiles/data/models/user_model.dart';

Future<File> createUserVcf(UserEntity user) async {
  final String vcfContent = '''
BEGIN:VCARD
VERSION:3.0
FN:${user.displayName}
PHOTO:${user.profilePic.isNotEmpty ? user.profilePic.first.url : ''}
NOTE:${user.uid}
END:VCARD
''';

  final Directory tempDir = await getTemporaryDirectory();
  final File vcfFile = File('${tempDir.path}/${user.uid}.vcf');
  return vcfFile.writeAsString(vcfContent);
}
