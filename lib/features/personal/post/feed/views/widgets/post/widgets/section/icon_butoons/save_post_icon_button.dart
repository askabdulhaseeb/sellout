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

  Future<void> _handleToggleSave() async {
    if (isLoading) return;

    // Store the previous state for rollback in case of failure
    final bool previousState = isSaved;

    // Optimistic update - immediately update UI
    setState(() {
      isSaved = !isSaved;
      isLoading = true;
    });

    // Update local storage optimistically
    _updateLocalStorage(isSaved);

    // Make API call
    final SavePostUsecase savePostUsecase = SavePostUsecase(locator());
    final DataState<bool> result = await savePostUsecase.call(widget.postId);

    if (!mounted) return;

    setState(() => isLoading = false);

    if (result is DataSuccess && result.entity == true) {
      // Success - the optimistic update was correct
      // No need to change UI again, already updated
    } else {
      // Failure - rollback to previous state
      setState(() => isSaved = previousState);
      _updateLocalStorage(previousState);

      // Show error message
      final String errorMessage =
          isSaved ? 'unsave_post_failed'.tr() : 'save_post_failed'.tr();
      AppSnackBar.showSnackBar(context, errorMessage);
    }
  }

  void _updateLocalStorage(bool shouldBeSaved) {
    final UserEntity? user = LocalUser().userEntity(LocalAuth.uid ?? '');
    if (user == null) return;

    final List<String> updatedSaved = List<String>.from(user.saved);

    if (shouldBeSaved) {
      // Add to saved if not already present
      if (!updatedSaved.contains(widget.postId)) {
        updatedSaved.add(widget.postId);
      }
    } else {
      // Remove from saved
      updatedSaved.remove(widget.postId);
    }

    // Create updated user with new saved list
    // Note: This assumes UserEntity has fields we can copy
    // Since UserEntity doesn't have copyWith, we're mutating the list
    // This is a limitation that should be addressed in Priority 3
    user.saved.clear();
    user.saved.addAll(updatedSaved);
    LocalUser().save(user);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : _handleToggleSave,
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
                  ? Icon(
                      key: const ValueKey<String>('saved'),
                      Icons.bookmark_added,
                      color: Theme.of(context).primaryColor,
                    )
                  : const CustomSvgIcon(
                      key: ValueKey<String>('unsaved'),
                      assetPath: AppStrings.selloutSaveIcon,
                    )),
    );
  }
}
