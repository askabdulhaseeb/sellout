import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../core/enums/core/attachment_type.dart';
import '../../domain/entities/picked_attachment.dart';
import '../../domain/entities/picked_attachment_option.dart';
import '../../../../core/functions/app_log.dart';

class PickedMediaProvider extends ChangeNotifier {
  final List<AssetEntity> _mediaList = <AssetEntity>[];
  final List<AssetEntity> _pickedMedia = <AssetEntity>[];
  bool _permissionDenied = false;
  bool _initialLoading = true;
  bool _loadingMore = false;
  int _currentPage = 0;
  final int _pageSize = 20;
  AssetPathEntity? _currentAlbum;
  bool _hasMoreMedia = true;
  bool _isDisposed = false;

  PickableAttachmentOption _option = PickableAttachmentOption();

  List<AssetEntity> get mediaList => _mediaList;
  List<AssetEntity> get pickedMedia => _pickedMedia;
  bool get permissionDenied => _permissionDenied;
  bool get initialLoading => _initialLoading;
  bool get isLoadingMore => _loadingMore;
  bool get hasMoreMedia => _hasMoreMedia;
  PickableAttachmentOption get option => _option;
  String get selectionStr => '${_pickedMedia.length}/${_option.maxAttachments}';
  int get selectedCount => _pickedMedia.length;
  bool get canSelectMore => _pickedMedia.length < _option.maxAttachments;

  Future<void> init(
    BuildContext context,
    PickableAttachmentOption option,
  ) async {
    _option = option;
    _pickedMedia
      ..clear()
      ..addAll(option.selectedMedia ?? <AssetEntity>[]);
    await _requestPermissionAndLoad();
  }

  Future<void> refreshPermissionAndReloadIfNeeded() async {
    // IMPORTANT: Don't call `requestPermissionExtend()` here.
    // On Android, repeated requests after denial can surface extra system
    // options (like "Never ask again"). Instead, do a silent reload attempt;
    // if the user granted permission in Settings, loading will succeed.
    if (!mounted) return;

    if (_permissionDenied || _mediaList.isEmpty) {
      final bool loaded = await _loadAlbumsAndInitialMedia();
      if (!mounted) return;
      if (loaded) {
        _permissionDenied = false;
        if (mounted) notifyListeners();
      }
    }
  }

  Future<void> _requestPermissionAndLoad() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (!mounted) return;

    if (ps.isAuth) {
      _permissionDenied = false;
      notifyListeners();

      await _loadAlbumsAndInitialMedia();
    } else {
      _permissionDenied = true;
      _initialLoading = false;
      _hasMoreMedia = false;
      if (mounted) notifyListeners();
      AppLog.error('Permission denied');
    }
  }

  Future<bool> _loadAlbumsAndInitialMedia() async {
    try {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: _option.type.requestType,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(minWidth: 100, minHeight: 100),
          ),
          videoOption: FilterOption(
            sizeConstraint: const SizeConstraint(minWidth: 100, minHeight: 100),
            durationConstraint: DurationConstraint(
              max: _option.maxVideoDuration,
            ),
          ),
          orders: const <OrderOption>[
            OrderOption(type: OrderOptionType.createDate, asc: false),
          ],
        ),
      );

      if (albums.isNotEmpty) {
        _currentAlbum = albums.first;
        await loadMoreMedia(initial: true);
      } else {
        _initialLoading = false;
        _hasMoreMedia = false;
        if (mounted) notifyListeners();
      }
      return true;
    } catch (e, s) {
      AppLog.error(
        'Error loading albums: $e',
        name: '_loadAlbumsAndInitialMedia',
        error: s,
      );

      // If permission is missing, PhotoManager may throw. Treat that as denied
      // and avoid further prompts.
      _permissionDenied = true;
      _initialLoading = false;
      _hasMoreMedia = false;
      _currentAlbum = null;
      _mediaList.clear();
      if (mounted) notifyListeners();
      return false;
    }
  }

  Future<void> loadMoreMedia({bool initial = false}) async {
    if (_currentAlbum == null) return;
    if (!initial && (!_hasMoreMedia || _loadingMore)) return;

    if (initial) {
      _initialLoading = true;
      _currentPage = 0;
      _mediaList.clear();
      _hasMoreMedia = true;
      if (mounted) notifyListeners();
    }

    _loadingMore = true;
    if (!initial && mounted) notifyListeners();

    try {
      final List<AssetEntity> newMedia = await _currentAlbum!.getAssetListPaged(
        page: _currentPage,
        size: _pageSize,
      );

      AppLog.info('Loaded ${newMedia.length} media, page: $_currentPage');

      if (newMedia.isEmpty) {
        _hasMoreMedia = false;
      } else {
        final Set<String> existingIds = _mediaList
            .map((AssetEntity e) => e.id)
            .toSet();
        final List<AssetEntity> uniqueNewMedia = newMedia
            .where((AssetEntity m) => !existingIds.contains(m.id))
            .toList();

        if (uniqueNewMedia.isNotEmpty) {
          _mediaList.addAll(uniqueNewMedia);
          await cacheThumbnails(uniqueNewMedia);
          _currentPage++;
        }

        if (newMedia.length < _pageSize) _hasMoreMedia = false;
      }

      _initialLoading = false;
    } catch (e, s) {
      AppLog.error(
        'Error loading media page $_currentPage: $e',
        name: 'loadMoreMedia',
        error: s,
      );
      _hasMoreMedia = false;
    } finally {
      _loadingMore = false;
      if (mounted) notifyListeners();
    }
  }

  final Map<String, Uint8List?> _thumbnailCache = <String, Uint8List?>{};

  Future<void> cacheThumbnails(List<AssetEntity> assets) async {
    for (final AssetEntity asset in assets) {
      if (_thumbnailCache.containsKey(asset.id)) continue;
      try {
        final Uint8List? bytes = await asset.thumbnailDataWithSize(
          const ThumbnailSize(100, 100),
          quality: 85,
          format: ThumbnailFormat.jpeg,
        );

        if (bytes != null && bytes.isNotEmpty) {
          _thumbnailCache[asset.id] = bytes;
        } else {
          _thumbnailCache[asset.id] = null;
        }
      } catch (e, s) {
        AppLog.error(
          'Thumbnail fetch failed for ${asset.id}: $e',
          name: 'cacheThumbnails',
          error: s,
        );
        _thumbnailCache[asset.id] = null;
      }
    }
    notifyListeners();
  }

  Uint8List? getThumbnail(String id) => _thumbnailCache[id];

  void onTap(AssetEntity media) {
    if (_pickedMedia.contains(media)) {
      _pickedMedia.remove(media);
    } else {
      if (canSelectMore) {
        _pickedMedia.add(media);
        cacheThumbnails(<AssetEntity>[media]);
      }
    }
    notifyListeners();
  }

  bool isSelected(AssetEntity media) => _pickedMedia.contains(media);

  void removeMedia(AssetEntity media) {
    _pickedMedia.remove(media);
    notifyListeners();
  }

  void clearSelections() {
    _pickedMedia.clear();
    notifyListeners();
  }

  int? indexOf(AssetEntity value) {
    final int index = _pickedMedia.indexOf(value);
    return index == -1 ? null : index;
  }

  void scrollToSelected(
    BuildContext context,
    int pickedIndex,
    ScrollController controller,
    Map<int, GlobalKey> tileKeys,
  ) {
    final AssetEntity tappedAsset = _pickedMedia[pickedIndex];
    AppLog.info(
      'Strip tap detected - pickedIndex: $pickedIndex, assetId: ${tappedAsset.id}',
    );

    final int gridIndex = _mediaList.indexWhere(
      (AssetEntity e) => e.id == tappedAsset.id,
    );
    AppLog.info('Asset found at gridIndex: $gridIndex');

    if (gridIndex == -1) {
      AppLog.error('❌ Asset not found in grid: ${tappedAsset.id}');
      return;
    }

    final GlobalKey? key = tileKeys[gridIndex];
    AppLog.info(
      'GlobalKey lookup - gridIndex: $gridIndex, key exists: ${key != null}, has context: ${key?.currentContext != null}',
    );

    if (key != null && key.currentContext != null) {
      AppLog.info('✅ Widget visible, direct scroll to gridIndex: $gridIndex');
      _scrollDirectly(key);
    } else {
      AppLog.info(
        '⚠️ Widget not visible (gridIndex: $gridIndex), jumping to position first...',
      );
      _scrollToPositionFirst(gridIndex, controller, tileKeys);
    }
  }

  void _scrollDirectly(GlobalKey key) {
    try {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
      AppLog.info('✅ Direct scroll completed');
    } catch (e, s) {
      AppLog.error(
        '❌ Direct scroll failed: $e',
        name: 'scrollToSelected',
        error: s,
      );
    }
  }

  Future<void> _scrollToPositionFirst(
    int gridIndex,
    ScrollController controller,
    Map<int, GlobalKey> tileKeys,
  ) async {
    try {
      AppLog.info('⏳ Strategy: Incrementally scroll to make widget visible...');

      const double scrollStep = 500.0;
      const int maxAttempts = 10;

      for (int attempt = 0; attempt < maxAttempts; attempt++) {
        final GlobalKey? currentKey = tileKeys[gridIndex];
        if (currentKey?.currentContext != null) {
          AppLog.info(
            '✅ Widget visible on attempt $attempt! Using ensureVisible for final positioning',
          );
          _scrollDirectly(currentKey!);
          return;
        }

        final double currentOffset = controller.offset;
        final double newOffset = (currentOffset + scrollStep).clamp(
          0.0,
          controller.position.maxScrollExtent,
        );

        AppLog.info(
          '📍 Attempt ${attempt + 1}/$maxAttempts: Scrolling from ${currentOffset.toStringAsFixed(1)} to ${newOffset.toStringAsFixed(1)}',
        );

        controller.jumpTo(newOffset);

        await Future.delayed(const Duration(milliseconds: 100));
      }

      AppLog.error(
        '❌ Widget still not visible after $maxAttempts attempts. gridIndex: $gridIndex',
      );
    } catch (e, s) {
      AppLog.error(
        '❌ Position-first scroll failed: $e',
        name: 'scrollToPositionFirst',
        error: s,
      );
    }
  }

  Future<void> onSubmit(BuildContext context) async {
    if (_pickedMedia.isEmpty) {
      AppLog.info('No media selected');
      return;
    }

    _loadingMore = true;
    notifyListeners();

    final List<PickedAttachment> attachments = <PickedAttachment>[];

    try {
      for (final AssetEntity media in _pickedMedia) {
        final File? file = await media.file;
        if (file != null && await file.exists()) {
          final AttachmentType type = media.type == AssetType.image
              ? AttachmentType.image
              : AttachmentType.video;
          attachments.add(
            PickedAttachment(file: file, type: type, selectedMedia: media),
          );
        }
      }

      if (attachments.isNotEmpty) {
        _pickedMedia.clear();
        if (mounted) notifyListeners();
        if (mounted) Navigator.of(context).pop(attachments);
      } else {
        _showErrorSnackbar(context, 'Failed to process selected files');
      }
    } catch (e, s) {
      AppLog.error(
        'Error preparing attachments: $e',
        name: 'onSubmit',
        error: s,
      );
      if (mounted) _showErrorSnackbar(context, 'Error preparing files');
    } finally {
      _loadingMore = false;
      if (mounted) notifyListeners();
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _mediaList.clear();
    _pickedMedia.clear();
    _thumbnailCache.clear();
    _currentAlbum = null;
    _hasMoreMedia = false;
    _initialLoading = false;
    _loadingMore = false;
    _currentPage = 0;
    _option = PickableAttachmentOption();

    super.dispose();
  }

  bool get mounted => !_isDisposed;
}
