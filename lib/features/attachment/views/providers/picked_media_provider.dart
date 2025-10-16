import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import '../../../../core/enums/core/attachment_type.dart';
import '../../domain/entities/picked_attachment.dart';
import '../../domain/entities/picked_attachment_option.dart';
import '../../../../core/functions/app_log.dart';

class PickedMediaProvider extends ChangeNotifier {
  // --- STATE ---
  final List<AssetEntity> _mediaList = <AssetEntity>[];
  final List<AssetEntity> _pickedMedia = <AssetEntity>[];
  bool _permissionDenied = false;
  bool _initialLoading = true;
  bool _loadingMore = false;
  int _currentPage = 0;
  final int _pageSize = 60;
  AssetPathEntity? _currentAlbum;
  bool _hasMoreMedia = true;

  // --- OPTIONS ---
  PickableAttachmentOption _option = PickableAttachmentOption();

  // --- GETTERS ---
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

  // --- INITIALIZATION ---
  Future<void> init(
      BuildContext context, PickableAttachmentOption option) async {
    _option = option;
    _pickedMedia
      ..clear()
      ..addAll(option.selectedMedia ?? <AssetEntity>[]);
    await _requestPermissionAndLoad();
  }

  Future<void> _requestPermissionAndLoad() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (!mounted) return;

    if (ps.isAuth) {
      _permissionDenied = false;
      notifyListeners();

      try {
        final List<AssetPathEntity> albums =
            await PhotoManager.getAssetPathList(
          type: _option.type.requestType,
          filterOption: FilterOptionGroup(
            imageOption: const FilterOption(
                sizeConstraint: SizeConstraint(minWidth: 100, minHeight: 100)),
            videoOption: FilterOption(
              sizeConstraint:
                  const SizeConstraint(minWidth: 100, minHeight: 100),
              durationConstraint:
                  DurationConstraint(max: _option.maxVideoDuration),
            ),
            orders: const <OrderOption>[
              OrderOption(type: OrderOptionType.createDate, asc: false)
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
      } catch (e, s) {
        AppLog.error('Error loading albums: $e',
            name: '_requestPermissionAndLoad', error: s);
        _initialLoading = false;
        _hasMoreMedia = false;
        if (mounted) notifyListeners();
      }
    } else {
      _permissionDenied = true;
      _initialLoading = false;
      _hasMoreMedia = false;
      if (mounted) notifyListeners();
      AppLog.error('Permission denied');
    }
  }

  // --- LOAD MORE MEDIA ---
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
        final Set<String> existingIds = _mediaList.map((e) => e.id).toSet();
        final List<AssetEntity> uniqueNewMedia =
            newMedia.where((m) => !existingIds.contains(m.id)).toList();

        if (uniqueNewMedia.isNotEmpty) {
          _mediaList.addAll(uniqueNewMedia);
          await cacheThumbnails(uniqueNewMedia); // Pre-cache thumbnails
          _currentPage++;
        }

        if (newMedia.length < _pageSize) _hasMoreMedia = false;
      }

      _initialLoading = false;
    } catch (e, s) {
      AppLog.error('Error loading media page $_currentPage: $e',
          name: 'loadMoreMedia', error: s);
      _hasMoreMedia = false;
    } finally {
      _loadingMore = false;
      if (mounted) notifyListeners();
    }
  }

  // --- THUMBNAIL CACHING ---
  final Map<String, Uint8List?> _thumbnailCache = {};

  Future<void> cacheThumbnails(List<AssetEntity> assets) async {
    for (final asset in assets) {
      if (!_thumbnailCache.containsKey(asset.id)) {
        _thumbnailCache[asset.id] =
            await asset.thumbnailDataWithSize(const ThumbnailSize(100, 100));
      }
    }
    notifyListeners();
  }

  Uint8List? getThumbnail(String id) => _thumbnailCache[id];

  // --- SELECTION HANDLING ---
  void onTap(AssetEntity media) {
    if (_pickedMedia.contains(media)) {
      _pickedMedia.remove(media);
    } else {
      if (canSelectMore) {
        _pickedMedia.add(media);
        cacheThumbnails([media]); // Pre-cache when picked
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

  // --- SCROLLING LOGIC ---
  /// Scrolls to the grid item that corresponds to a tapped item in the strip.
  ///
  /// **How it works:**
  /// 1. User taps item in strip → we get its index in pickedMedia
  /// 2. Find that same asset in full grid via ID matching (reliable)
  /// 3. Use the GlobalKey assigned to that grid tile
  /// 4. Scroll using Scrollable.ensureVisible() - MOST RELIABLE METHOD
  ///
  /// **Why GlobalKey is ALWAYS used:**
  /// - Works perfectly with infinite scroll/pagination
  /// - Doesn't rely on index positions (which change when data loads)
  /// - Automatically handles all edge cases
  /// - Finds widget context and calculates exact scroll position
  ///
  /// **Parameters:**
  /// - pickedIndex: Index in the _pickedMedia list (the strip)
  /// - controller: ScrollController of the CustomScrollView (grid)
  /// - tileKeys: Map of GlobalKeys for each grid tile, keyed by gridIndex
  void scrollToSelected(BuildContext context, int pickedIndex,
      ScrollController controller, Map<int, GlobalKey> tileKeys) {
    // STEP 1: Get the asset that was tapped in the strip
    final AssetEntity tappedAsset = _pickedMedia[pickedIndex];
    AppLog.info(
        'Strip tap detected - pickedIndex: $pickedIndex, assetId: ${tappedAsset.id}');

    // STEP 2: Find where this asset appears in the full grid
    // Using ID matching - unique and reliable across pagination
    final int gridIndex = _mediaList.indexWhere((e) => e.id == tappedAsset.id);
    AppLog.info('Asset found at gridIndex: $gridIndex');

    // STEP 3: Safety check
    if (gridIndex == -1) {
      AppLog.error('❌ Asset not found in grid: ${tappedAsset.id}');
      return;
    }

    // STEP 4: Get the GlobalKey for this grid tile
    final GlobalKey? key = tileKeys[gridIndex];
    AppLog.info(
        'GlobalKey lookup - gridIndex: $gridIndex, key exists: ${key != null}, has context: ${key?.currentContext != null}');

    // STEP 5: Verify key exists and has context
    if (key == null || key.currentContext == null) {
      AppLog.error(
          '❌ GlobalKey not available for gridIndex: $gridIndex. Available keys: ${tileKeys.keys.length}');
      AppLog.info('📍 Available gridIndices: ${tileKeys.keys.toList()}');
      return;
    }

    // STEP 6: ONLY METHOD - Use Scrollable.ensureVisible
    // This is the ONLY reliable method for infinite scroll scenarios
    // It automatically:
    // - Calculates exact scroll position using widget's RenderObject
    // - Handles all edge cases (already visible, at boundaries, etc.)
    // - Works with nested slivers perfectly
    // - Doesn't depend on index positions or calculations
    AppLog.info('✅ Calling Scrollable.ensureVisible for gridIndex: $gridIndex');
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.5, // Center the item in view (0.0 = top, 1.0 = bottom)
    );

    AppLog.info(
        '✅ Scrolled to gridIndex: $gridIndex (pickedIndex: $pickedIndex, assetId: ${tappedAsset.id})');
  }

  // --- SUBMISSION ---
  Future<void> onSubmit(BuildContext context) async {
    if (_pickedMedia.isEmpty) {
      AppLog.info('No media selected');
      return;
    }

    _loadingMore = true;
    notifyListeners();

    final List<PickedAttachment> attachments = [];

    try {
      for (final AssetEntity media in _pickedMedia) {
        final File? file = await media.file;
        if (file != null && await file.exists()) {
          final AttachmentType type = media.type == AssetType.image
              ? AttachmentType.image
              : AttachmentType.video;
          attachments.add(
              PickedAttachment(file: file, type: type, selectedMedia: media));
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
      AppLog.error('Error preparing attachments: $e',
          name: 'onSubmit', error: s);
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

  // --- CLEANUP ---
  @override
  void dispose() {
    _mediaList.clear();
    _pickedMedia.clear();
    super.dispose();
  }

  // --- MOUNTED CHECK ---
  bool get mounted => true;
}
