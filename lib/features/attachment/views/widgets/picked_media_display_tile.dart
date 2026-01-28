import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_spacings.dart';
import '../../../../core/widgets/indicators/custom_shimmer_effect.dart';
import '../providers/picked_media_provider.dart';

class PickedMediaDisplayTile extends StatefulWidget {
  const PickedMediaDisplayTile({
    required this.media,
    required this.thumbnail,
    super.key,
  });
  final AssetEntity media;
  final Uint8List? thumbnail;

  @override
  State<PickedMediaDisplayTile> createState() => _PickedMediaDisplayTileState();
}

class _PickedMediaDisplayTileState extends State<PickedMediaDisplayTile>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive {
    // Keep this tile alive if it's selected
    // This prevents the tile from being disposed when scrolled out of view
    final PickedMediaProvider provider =
        Provider.of<PickedMediaProvider>(context, listen: false);
    return provider.isSelected(widget.media);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    final PickedMediaProvider mediaPro =
        Provider.of<PickedMediaProvider>(context, listen: false);
    const Color overlayColor = Colors.black54;
    const double radius = AppSpacing.radiusXs;

    return InkWell(
      onTap: () => mediaPro.onTap(widget.media),
      borderRadius: BorderRadius.circular(radius),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ShimmerLoading(
          isLoading: widget.thumbnail == null,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              AnimatedOpacity(
                opacity: widget.thumbnail == null ? 0 : 1,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: widget.thumbnail == null
                    ? Container(color: Colors.grey[300])
                    : Image.memory(
                        widget.thumbnail!,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
              ),
              // --- Selection indicator ---
              Consumer<PickedMediaProvider>(
                builder:
                    (BuildContext context, PickedMediaProvider provider, _) {
                  final int? index = provider.indexOf(widget.media);
                  if (index == null) return const SizedBox.shrink();
                  return Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withOpacity(0.9),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
              // --- Bottom overlay icons ---
              Positioned(
                bottom: 6,
                right: 6,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (widget.media.type == AssetType.video)
                      _buildIcon(overlayColor, Icons.videocam),
                    if (widget.media.isFavorite)
                      _buildIcon(overlayColor, Icons.favorite,
                          color: Colors.red),
                  ],
                ),
              ),
              // --- Subtle gradient overlay ---
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[
                      Colors.black.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(Color bg, IconData icon, {Color color = Colors.white}) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Icon(icon, size: 16, color: color),
    );
  }
}
