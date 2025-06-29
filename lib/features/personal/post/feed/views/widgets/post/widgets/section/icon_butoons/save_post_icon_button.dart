import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../services/get_it.dart';
import '../../../../../../../domain/usecase/save_post_usecase.dart';

class SavePostIconButton extends StatefulWidget {
  const SavePostIconButton({
    required this.postId,
    super.key,
  });

  final String postId;

  @override
  State<SavePostIconButton> createState() => _SavePostIconButtonState();
}

class _SavePostIconButtonState extends State<SavePostIconButton> {
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
