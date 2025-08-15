import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../../../../core/functions/app_log.dart';
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
  // Prompt
  // In Flutter, I want to display the whole gallary in a screen like whatsapp,
  // from where user can pick media, but i also don't want to crash the
  // application as there are alot of photos in the gallary,
  // how can i display that images, videos, document, audio or any type of
  // media file from local storage

  final int _pageSize = 60;
  final List<AssetEntity> _mediaList = <AssetEntity>[];
  bool _isLoading = true;
  int _currentPage = 0;
  int _lastPage = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<PickedMediaProvider>(context, listen: false)
        .setOption(context, widget.option);
    _requestPermissionAndLoad();
  }

  Future<void> _requestPermissionAndLoad() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      AppLog.info(
        'Permission granted',
        name: 'PickableAttachmentScreen._requestPermissionAndLoad - if',
      );
      _loadMoreMedia();
    } else {
      // TODO: Handle permission denied
      AppLog.error(
        'Permission denied',
        name: 'PickableAttachmentScreen._requestPermissionAndLoad - else',
        error: ps,
      );
      // Handle permission denied
    }
  }

  Future<void> _loadMoreMedia() async {
    if (_currentPage == _lastPage && !_isLoading) return;
    RequestType type = widget.option.type.requestType;
    AppLog.info(
      'Selected type: $type',
      name: 'PickableAttachmentScreen._loadMoreMedia',
    );
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: type,
      filterOption: FilterOptionGroup(
        imageOption: const FilterOption(
          sizeConstraint: SizeConstraint(
            minWidth: 100,
            minHeight: 100,
          ),
        ),
        videoOption: FilterOption(
          sizeConstraint: const SizeConstraint(
            minWidth: 100,
            minHeight: 100,
          ),
          durationConstraint:
              DurationConstraint(max: widget.option.maxVideoDuration),
        ),
        orders: <OrderOption>[
          const OrderOption(type: OrderOptionType.createDate, asc: false),
        ],
      ),
    );
    AppLog.info(
      'Step 2 - Load more media',
      name: 'PickableAttachmentScreen._loadMoreMedia',
    );
    try {
      final List<AssetEntity> media = await albums[0]
          .getAssetListPaged(page: _currentPage, size: _pageSize);
      final int totalImages = await albums[0].assetCountAsync;
      _mediaList.addAll(media);
      _currentPage++;
      _lastPage = (totalImages / _pageSize).ceil();
    } catch (e) {
      AppLog.error(
        'PickableAttachmentScreen:_loadMoreMedia  $e',
        name: 'PickableAttachmentScreen._loadMoreMedia - catch',
        error: e,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: _isLoading
          ? const Center(child: Loader())
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  _loadMoreMedia();
                }
                return false;
              },
              child: _mediaList.isEmpty
                  ? const Center(child: Text('Not Found'))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
            ),
    );
  }
}
