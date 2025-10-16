import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/picked_attachment_option.dart';
import '../providers/picked_media_provider.dart';
import '../widgets/media_app_bar.dart';
import '../widgets/media_grid.dart';
import '../widgets/picked_media_strip.dart';
import '../widgets/scroll_to_top_button.dart';
import '../widgets/empty_gallery_state.dart';
import '../widgets/permission_denied_state.dart';
import '../widgets/initial_loading_state.dart';
import '../widgets/load_more_indicator.dart';
import '../widgets/end_of_list_indicator.dart';

class PickableAttachmentScreen extends StatefulWidget {
  const PickableAttachmentScreen({super.key, this.option});
  final PickableAttachmentOption? option;

  @override
  State<PickableAttachmentScreen> createState() =>
      _PickableAttachmentScreenState();
}

class _PickableAttachmentScreenState extends State<PickableAttachmentScreen> {
  // --- SCROLL MANAGEMENT ---
  late final ScrollController _scrollController;

  // --- TILE KEYING ---
  // Maps gridIndex → GlobalKey for each tile in the grid
  // Used by provider to scroll to tiles when tapping strip items
  final GlobalKey _gridKey = GlobalKey();
  final Map<int, GlobalKey> _tileKeys =
      <int, GlobalKey<State<StatefulWidget>>>{};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PickedMediaProvider>(context, listen: false).init(
        context,
        widget.option ?? PickableAttachmentOption(),
      );
    });
    _scrollController.addListener(_onScroll);
  }

  // INFINITE SCROLL LOGIC:
  // Loads more media when user scrolls near the bottom (400px buffer)
  void _onScroll() {
    final PickedMediaProvider provider =
        Provider.of<PickedMediaProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 400 &&
        !provider.isLoadingMore &&
        provider.hasMoreMedia) {
      provider.loadMoreMedia();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tileKeys.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PickedMediaProvider>(
      builder: (BuildContext context, PickedMediaProvider provider, _) {
        if (provider.permissionDenied) return const PermissionDeniedState();
        if (provider.initialLoading) return const InitialLoadingState();
        if (provider.mediaList.isEmpty) return const EmptyGalleryState();

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    const MediaAppBar(),
                    MediaGrid(
                      provider: provider,
                      gridKey: _gridKey,
                      tileKeys: _tileKeys,
                    ),
                    if (provider.isLoadingMore) const LoadMoreIndicator(),
                    if (!provider.hasMoreMedia) const EndOfListIndicator(),
                  ],
                ),
                // --- BOTTOM CONTROLS BAR (Strip + Scroll-to-Top Button) ---
                // Both sit in one horizontal line at the bottom with nice animation
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    minimum: const EdgeInsets.only(
                      bottom: 8,
                      left: 8,
                      right: 8,
                    ),
                    child: Row(
                      children: <Widget>[
                        // --- MEDIA STRIP (Expandable) ---
                        Expanded(
                          child: PickedMediaStrip(
                            onItemTap: (int index) => provider.scrollToSelected(
                              context,
                              index,
                              _scrollController,
                              _tileKeys,
                            ),
                          ),
                        ),
                        // --- SCROLL-TO-TOP BUTTON ---
                        // Animates in/out as user scrolls
                        ScrollToTopButton(scrollController: _scrollController),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
