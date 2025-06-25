import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../services/get_it.dart';
import '../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../auth/signin/domain/repositories/signin_repository.dart';
import '../../../../../../../chats/create_chat/view/provider/create_private_chat_provider.dart';
import '../../../../../../domain/entities/post_entity.dart';
import '../../../../../../domain/usecase/save_post_usecase.dart';

class HomePostIconBottonSection extends StatelessWidget {
  const HomePostIconBottonSection({required this.post, super.key});
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    final bool isMine = post.createdBy == LocalAuth.uid;
    return Row(
      children: <Widget>[
        if (!isMine) PostTileChatICon(userId: post.createdBy),
        IconButton(
          icon: Icon(Icons.adaptive.share),
          onPressed: () {},
        ),
        const Spacer(),
        if (!isMine)
          SavePostButton(
            postId: post.postID,
          )
      ],
    );
  }
}

class SavePostButton extends StatefulWidget {
  const SavePostButton({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  State<SavePostButton> createState() => _SavePostButtonState();
}

class _SavePostButtonState extends State<SavePostButton> {
  bool isSaved = false;
  bool isLoading = false;

  Future<void> _handleSave() async {
    if (isLoading || isSaved) return;

    setState(() {
      isLoading = true;
    });

    final SavePostUsecase savePostUsecase = SavePostUsecase(locator());
    final DataState<bool> result = await savePostUsecase.call(widget.postId);

    if (!mounted) return;

    if (result is DataSuccess && result.entity == true) {
      setState(() {
        isSaved = true;
      });
    } else {
      AppSnackBar.showSnackBar(context, 'save_post_failed'.tr());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _handleSave,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: isLoading
            ? const SizedBox(
                key: ValueKey('loading'),
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                isSaved ? Icons.bookmark_added : Icons.bookmark_add_outlined,
                key: ValueKey(isSaved),
              ),
      ),
    );
  }
}

class PostTileChatICon extends StatelessWidget {
  const PostTileChatICon({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    final bool isLoading =
        Provider.of<CreatePrivateChatProvider>(context).isLoading;

    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.chat_outlined),
      ),
      onPressed: isLoading
          ? null
          : () {
              Provider.of<CreatePrivateChatProvider>(context, listen: false)
                  .startPrivateChat(context, userId);
            },
    );
  }
}
