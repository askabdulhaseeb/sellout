import 'package:flutter/material.dart';
import '../../../../../../../../../core/helper_functions/country_helper.dart';
import '../../../../../../domain/entities/post/post_entity.dart';

class HomePostTitleSection extends StatelessWidget {
  const HomePostTitleSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  post.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              FutureBuilder<String>(
                future: post.getPriceStr(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('...');
                  }

                  return Text(
                    snapshot.data!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),
            ],
          ),
          // const SizedBox(height: 8),
          // post.description.isEmpty
          //     ? const SizedBox()
          //     : LimitedLinesHtmlText(
          //         htmlData: post.description,
          //         maxLines: 3,
          //       ),
        ],
      ),
    );
  }
}
