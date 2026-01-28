import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../../../../../../core/widgets/buttons/custom_elevated_button.dart';
import '../../../../../../../../../post/domain/entities/post/post_entity.dart';

class PostCollectionButtons extends StatefulWidget {
  const PostCollectionButtons({
    required this.post,
    super.key,
  });

  final PostEntity post;

  @override
  State<PostCollectionButtons> createState() => _PostCollectionButtonsState();
}

class _PostCollectionButtonsState extends State<PostCollectionButtons> {
  final bool _isLoadingRoute = false;

  Future<void> openGoogleMaps(String url) async {
    final Uri googleMapsUrl = Uri.parse(url);

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      // bgColor: Colors.transparent,
      // border: Border.all(color: Theme.of(context).colorScheme.primary),
      // textColor: Theme.of(context).colorScheme.primary,
      title: 'collection_only'.tr(),
      isLoading: _isLoadingRoute,
      onTap: () => openGoogleMaps(widget.post.collectionLocation?.url ?? ''),
    );
  }
}
