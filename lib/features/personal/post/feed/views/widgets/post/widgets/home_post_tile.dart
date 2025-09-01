import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/attachment_slider.dart';
import '../../../../../domain/entities/post_entity.dart';
import '../../../../../domain/entities/visit/visiting_entity.dart';
import '../../../../../post_detail/views/screens/post_detail_screen.dart';
import 'section/buttons/home_post_button_section.dart';
import 'section/home_post_header_section.dart';
import 'section/home_post_icon_botton_section.dart';
import 'section/home_post_title_section.dart';

class HomePostTile extends StatelessWidget {
  const HomePostTile({required this.post, this.visit, super.key});
  final PostEntity post;
  final List<VisitingEntity>? visit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(PostDetailScreen.routeName,
            arguments: <String, dynamic>{'pid': post.postID, 'visit': visit});
      },
      child: Column(
        children: <Widget>[
          PostHeaderSection(post: post),
          AttachmentsSlider(
            attachments: post.fileUrls,
          ),
          HomePostIconBottonSection(post: post),
          HomePostTitleSection(post: post),
          PostButtonSection(
            detailWidget: false,
            post: post,
            visit: visit,
          ),
          Container(
            height: 4,
            width: double.infinity,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }
}
