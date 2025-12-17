import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../attachment/domain/entities/attachment_entity.dart';
import '../../../../../../user/profiles/views/user_profile/screens/user_profile_screen.dart';

class ContactMessageTile extends StatefulWidget {
  const ContactMessageTile({
    required this.attachment,
    required this.isMe,
    super.key,
  });

  final AttachmentEntity attachment;
  final bool isMe;

  @override
  State<ContactMessageTile> createState() => _ContactMessageTileState();
}

class _ContactMessageTileState extends State<ContactMessageTile> {
  String displayName = '';
  String photoUrl = '';
  String uid = '';

  @override
  void initState() {
    super.initState();
    _loadVcf();
  }

  Future<void> _loadVcf() async {
    try {
      final http.Response response =
          await http.get(Uri.parse(widget.attachment.url));
      if (response.statusCode == 200) {
        final List<String> lines = response.body.split('\n');
        for (String line in lines) {
          if (line.startsWith('FN:')) displayName = line.substring(3).trim();
          if (line.startsWith('PHOTO:')) {
            photoUrl = line.split('PHOTO:').last.trim();
            debugPrint('Photo VCF: $photoUrl');
          }
          if (line.startsWith('NOTE:')) uid = line.substring(5).trim();
        }
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error loading VCF: $e');

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('failed_to_load_contact')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<UserProfileScreen>(
          builder: (_) => UserProfileScreen(uid: uid),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CustomNetworkImage(
                    size: 50,
                    placeholder: displayName,
                    imageURL: photoUrl,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
