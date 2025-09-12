import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../../../../core/functions/app_log.dart';
import '../../../../core/widgets/empty_page_widget.dart';
import '../../../../core/widgets/loaders/loader.dart';
import '../../domain/entities/picked_attachment_option.dart';
import '../providers/picked_media_provider.dart';
import '../widgets/picked_media_display_limits_widget.dart';
import '../widgets/picked_media_display_tile.dart';

class PickableAttachmentScreen extends StatefulWidget {
  PickableAttachmentScreen({PickableAttachmentOption? option, super.key})
      : option = option ?? PickableAttachmentOption();
  final PickableAttachmentOption option;

  static const String routeName = '/selectable-attachment';

  @override
  State<PickableAttachmentScreen> createState() =>
      _PickableAttachmentScreenState();
}

class _PickableAttachmentScreenState extends State<PickableAttachmentScreen> {
  final int _pageSize = 60;
  final List<AssetEntity> _mediaList = <AssetEntity>[];
  bool _permissionDenied = false;
  AssetPathEntity? _currentAlbum;
  bool _initialLoading = true;
  bool _loadingMore = false;
  int _currentPage = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    Provider.of<PickedMediaProvider>(context, listen: false)
        .setOption(context, widget.option);

    _scrollController = ScrollController()..addListener(_onScroll);

    _requestPermissionAndLoad();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadMoreMedia();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissionAndLoad() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      setState(() => _permissionDenied = false);

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: widget.option.type.requestType,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(minWidth: 100, minHeight: 100),
          ),
          videoOption: FilterOption(
            sizeConstraint: const SizeConstraint(minWidth: 100, minHeight: 100),
            durationConstraint:
                DurationConstraint(max: widget.option.maxVideoDuration),
          ),
          orders: const <OrderOption>[
            OrderOption(type: OrderOptionType.createDate, asc: false)
          ],
        ),
      );

      if (albums.isNotEmpty) {
        _currentAlbum = albums.first;
        _loadMoreMedia(initial: true);
      } else {
        setState(() => _initialLoading = false);
      }
    } else {
      setState(() {
        _permissionDenied = true;
        _initialLoading = false;
      });
      AppLog.error('Permission denied');
    }
  }

  Future<void> _loadMoreMedia({bool initial = false}) async {
    if (_currentAlbum == null) return;

    if (initial) {
      setState(() {
        _initialLoading = true;
        _currentPage = 0;
        _mediaList.clear();
      });
    } else {
      if (_loadingMore) return;
      setState(() => _loadingMore = true);
    }

    try {
      final List<AssetEntity> newMedia = await _currentAlbum!
          .getAssetListPaged(page: _currentPage, size: _pageSize);

      if (newMedia.isEmpty) {
        setState(() {
          _loadingMore = false;
          _initialLoading = false;
        });
        return;
      }

      // Avoid duplicates
      final Set<String> existingIds =
          _mediaList.map((AssetEntity e) => e.id).toSet();
      _mediaList.addAll(
          newMedia.where((AssetEntity m) => !existingIds.contains(m.id)));

      _currentPage++;
    } catch (e, s) {
      AppLog.error('Error loading media: $e', name: 'loadMore', error: s);
    }

    setState(() {
      _loadingMore = false;
      _initialLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_permissionDenied) {
      body = EmptyPageWidget(
        icon: Icons.no_photography_rounded,
        childBelow: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: <InlineSpan>[
                TextSpan(
                  text: tr('permission_gallery_title'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextSpan(
                  text: tr('permission_gallery_body'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextSpan(
                  text: '\n${tr('permission_gallery_grant')}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => PhotoManager.openSetting(),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (_initialLoading) {
      // Can replace with shimmer loader if you have it
      body = const Center(child: Loader());
    } else if (_mediaList.isEmpty) {
      body = EmptyPageWidget(
          icon: Icons.no_photography_rounded,
          childBelow: Text('no_data_found'.tr()));
    } else {
      body = SizedBox(
        child: GridView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: _mediaList.length,
          itemBuilder: (BuildContext context, int index) {
            final AssetEntity media = _mediaList[index];
            return PickedMediaDisplayTile(media: media);
          },
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const PickedMediaDisplayLimitsWidget(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async =>
                await Provider.of<PickedMediaProvider>(context, listen: false)
                    .onSubmit(context),
          ),
        ],
      ),
      body: body,
    );
  }
}
