import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/custom_toggle_switch.dart';
import '../../../../../../services/get_it.dart';
import '../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../post/data/sources/local/local_post.dart';
import '../../../../post/domain/entities/post/post_entity.dart';
import '../../../../user/profiles/data/sources/local/local_user.dart';
import '../../../../user/profiles/domain/usecase/get_post_by_id_usecase.dart';
import '../provider/promo_provider.dart';

class ChoosePostBottomSheet extends StatefulWidget {
  const ChoosePostBottomSheet({super.key});

  @override
  State<ChoosePostBottomSheet> createState() => _ChoosePostBottomSheetState();
}

class _ChoosePostBottomSheetState extends State<ChoosePostBottomSheet> {
  String currentPage = 'Posts';
  late Future<UserEntity?> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = LocalUser().user(LocalAuth.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            CustomToggleSwitch<String>(
              labels: const <String>['Posts', 'Views'],
              labelStrs: const <String>['Posts', 'Views'],
              labelText: 'Choose Content',
              initialValue: currentPage,
              onToggle: (String value) {
                setState(() {
                  currentPage = value;
                });
              },
            ),
            const SizedBox(height: 12),
            FutureBuilder<UserEntity?>(
              future: userFuture,
              builder:
                  (BuildContext context, AsyncSnapshot<UserEntity?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('User not found'));
                }
                final UserEntity user = snapshot.data!;
                return currentPage == 'Posts'
                    ? PromoPostGridview(user: user)
                    : PromoViewGridview(user: user);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PromoPostGridview extends StatelessWidget {
  const PromoPostGridview({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    if (user?.uid == null) {
      return const Center(child: Text('User not found'));
    }

    final GetPostByIdUsecase getPostByIdUsecase = GetPostByIdUsecase(locator());

    return FutureBuilder<DataState<List<PostEntity>>>(
      future: getPostByIdUsecase(user!.uid),
      initialData: LocalPost().postbyUid(user!.uid),
      builder: (BuildContext context,
          AsyncSnapshot<DataState<List<PostEntity>>> snapshot) {
        if (!snapshot.hasData || snapshot.data?.entity == null) {
          return const Center(child: Text('No posts found'));
        }

        final List<PostEntity> posts = snapshot.data!.entity!;
        if (posts.isEmpty) {
          return const Center(child: Text('No posts found'));
        }

        posts.sort(
            (PostEntity a, PostEntity b) => b.createdAt.compareTo(a.createdAt));

        return SizedBox(
          child: GridView.builder(
            itemCount: posts.length,
            shrinkWrap: true,
            primary: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 6.0,
              mainAxisSpacing: 6.0,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (BuildContext context, int index) {
              return SimplePostTile(post: posts[index]);
            },
          ),
        );
      },
    );
  }
}

class PromoViewGridview extends StatelessWidget {
  const PromoViewGridview({required this.user, super.key});
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    // Replace this with your real logic to fetch and display views
    return const Center(child: Text('Your viewing grid here'));
  }
}

class SimplePostTile extends StatelessWidget {
  const SimplePostTile({required this.post, super.key});
  final PostEntity post;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final PromoProvider pro = Provider.of<PromoProvider>(
          context,
          listen: false,
        );
        pro.setPost(post);
        pro.setRefernceID(post.postID, 'post_attachment'
            // PASS REF TYPE HERE
            );
        Navigator.pop(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity,
              height: 150,
              child: CustomNetworkImage(
                imageURL: post.imageURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            post.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            post.priceStr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
