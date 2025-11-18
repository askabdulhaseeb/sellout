import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../chats/chat/domain/params/post_inquiry_params.dart';
import '../../../../../../../../chats/chat/domain/usecase/create_post_inquiry_usecase.dart';

class PostInquiryIconButton extends StatefulWidget {
  const PostInquiryIconButton({
    required this.postId,
    super.key,
  });

  final String postId;

  @override
  State<PostInquiryIconButton> createState() => _PostInquiryIconButtonState();
}

class _PostInquiryIconButtonState extends State<PostInquiryIconButton> {
  bool isLoading = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _showInquiryDialog() async {
    final String? inquiryText = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('inquiry_title'.tr()),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'inquiry_hint'.tr(),
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr()),
            ),
            FilledButton(
              onPressed: () {
                if (_textController.text.trim().isEmpty) {
                  AppSnackBar.showSnackBar(
                      context, 'inquiry_empty_error'.tr());
                  return;
                }
                Navigator.of(context).pop(_textController.text.trim());
              },
              child: Text('send'.tr()),
            ),
          ],
        );
      },
    );

    if (inquiryText != null && inquiryText.isNotEmpty) {
      await _handleCreateInquiry(inquiryText);
      _textController.clear();
    }
  }

  Future<void> _handleCreateInquiry(String text) async {
    if (isLoading) return;

    setState(() => isLoading = true);

    final CreatePostInquiryUsecase createPostInquiryUsecase =
        CreatePostInquiryUsecase(locator());

    final PostInquiryParams params = PostInquiryParams(
      postId: widget.postId,
      text: text,
    );

    final DataState<bool> result = await createPostInquiryUsecase.call(params);

    if (!mounted) return;

    setState(() => isLoading = false);

    if (result is DataSuccess && result.entity == true) {
      AppSnackBar.showSnackBar(context, 'inquiry_sent_success'.tr());
    } else {
      AppSnackBar.showSnackBar(context, 'inquiry_sent_failed'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : _showInquiryDialog,
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              Icons.chat_bubble_outline,
              color: Theme.of(context).iconTheme.color,
            ),
    );
  }
}
