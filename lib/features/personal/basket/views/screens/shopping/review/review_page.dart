import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../core/widgets/empty_page_widget.dart';
import '../../../../../post/data/sources/local/local_post.dart';
import '../../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../providers/cart_provider.dart';
import 'review_widgets/review_item_card.dart';

class ReviewOrderPage extends StatelessWidget {
  const ReviewOrderPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchPostsForPostage(
      dynamic postage) async {
    final List<Map<String, dynamic>> result = <Map<String, dynamic>>[];
    final entries = postage.detail.entries.toList();
    for (final e in entries) {
      final item = e.value;
      final String postId = item.postId ?? e.key;
      final post = await LocalPost().getPost(postId);
      final seller = await LocalUser().user(post?.createdBy ?? '');
      result.add(
          <String, dynamic>{'post': post, 'seller': seller, 'detail': item});
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartPro = context.watch<CartProvider>();
    final postage = cartPro.postageResponseEntity;

    if (postage == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchPostsForPostage(postage),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data!;

        return Column(
          children: <Widget>[
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: EmptyPageWidget(icon: Icons.local_shipping))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (BuildContext context, int index) {
                        final Map<String, dynamic> row = items[index];
                        return ReviewItemCard(
                            post: row['post'],
                            seller: row['seller'],
                            detail: row['detail']);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
