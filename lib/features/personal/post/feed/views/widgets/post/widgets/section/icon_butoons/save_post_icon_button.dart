import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../../core/sources/data_state.dart';
import '../../../../../../../../../../core/utilities/app_string.dart';
import '../../../../../../../../../../core/widgets/app_snakebar.dart';
import '../../../../../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../../../../../../services/get_it.dart';
import '../../../../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../../../../user/profiles/data/sources/local/local_user.dart';
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

  @override
  void initState() {
    super.initState();
    final List<String>? savedPosts = LocalAuth.currentUser?.saved;
    isSaved = savedPosts?.contains(widget.postId) ?? false;
  }

  Future<void> _handleSave() async {
    if (isLoading || isSaved) return;
    setState(() => isLoading = true);
    final SavePostUsecase savePostUsecase = SavePostUsecase(locator());
    final DataState<bool> result = await savePostUsecase.call(widget.postId);
    if (!mounted) return;
    if (result is DataSuccess && result.entity == true) {
      setState(() {
        isSaved = true;
        final UserEntity? user = LocalUser().userEntity(LocalAuth.uid ?? '');
        user?.saved.add(widget.postId);
        LocalUser().save(user!);
      });
    } else {
      AppSnackBar.showSnackBar(context, 'save_post_failed'.tr());
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSaved ? null : _handleSave,
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: isLoading
              ? const SizedBox(
                  key: ValueKey<String>('loading'),
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : isSaved
                  ? const Icon(Icons.bookmark_added)
                  : const CustomSvgIcon(
                      assetPath: AppStrings.selloutSaveIcon,
                    )),
    );
  }
}
