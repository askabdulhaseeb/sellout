import 'package:flutter/material.dart';
import '../../../../features/personal/post/data/sources/local/local_post.dart';

class PostHeaderWidget extends StatefulWidget {
  const PostHeaderWidget({required this.postId, Key? key}) : super(key: key);
  final String postId;

  @override
  State<PostHeaderWidget> createState() => _PostHeaderWidgetState();
}

class _PostHeaderWidgetState extends State<PostHeaderWidget> {
  late final Future<dynamic> _postFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = LocalPost.openBox
        .then((_) => LocalPost().getPost(widget.postId, silentUpdate: true));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _postFuture,
      builder: (BuildContext c, AsyncSnapshot<dynamic> snap) {
        if (snap.hasError) return const Text('Error loading post');
        if (snap.connectionState != ConnectionState.done)
          return const CircularProgressIndicator(strokeWidth: 2);

        final dynamic post = snap.data;
        return Row(
          children: <Widget>[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.image),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(post?.title ?? widget.postId)),
          ],
        );
      },
    );
  }
}
