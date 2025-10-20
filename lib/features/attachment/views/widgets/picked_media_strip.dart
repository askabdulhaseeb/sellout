import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../providers/picked_media_provider.dart';

class PickedMediaStrip extends StatelessWidget {
  const PickedMediaStrip({
    required this.onItemTap,
    super.key,
  });
  final void Function(int index) onItemTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<PickedMediaProvider>(
      builder: (BuildContext context, PickedMediaProvider provider, _) {
        return AnimatedOpacity(
          opacity: provider.pickedMedia.isEmpty ? 0 : 1,
          duration: const Duration(milliseconds: 400),
          child: AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 400),
            height: provider.pickedMedia.isEmpty ? 0 : 56,
            curve: Curves.easeInOut,
            child: provider.pickedMedia.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.98),
                          Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.95),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: ListView.builder(
                      key: const PageStorageKey<String>('picked_media_strip'),
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.pickedMedia.length,
                      itemBuilder: (BuildContext context, int index) {
                        final AssetEntity media = provider.pickedMedia[index];
                        final Uint8List? thumb =
                            provider.getThumbnail(media.id);
                        return _StripItemTile(
                          key: ValueKey<AssetEntity>(media),
                          thumbnail: thumb,
                          index: index,
                          onTap: () {
                            onItemTap(index);
                          },
                        );
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _StripItemTile extends StatefulWidget {
  const _StripItemTile({
    required this.thumbnail,
    required this.index,
    required this.onTap,
    super.key,
  });

  final Uint8List? thumbnail;
  final int index;
  final VoidCallback onTap;

  @override
  State<_StripItemTile> createState() => _StripItemTileState();
}

class _StripItemTileState extends State<_StripItemTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.thumbnail == null
                  ? Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .surfaceVariant
                                .withOpacity(0.4),
                            Theme.of(context)
                                .colorScheme
                                .surfaceVariant
                                .withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        // Guard against empty bytes to avoid native decoder crash
                        if (widget.thumbnail != null &&
                            widget.thumbnail!.isNotEmpty)
                          Image.memory(
                            widget.thumbnail!,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (_, __, ___) =>
                                const ColoredBox(color: Colors.black12),
                          )
                        else
                          const ColoredBox(color: Colors.black12),
                        // Fancy overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
