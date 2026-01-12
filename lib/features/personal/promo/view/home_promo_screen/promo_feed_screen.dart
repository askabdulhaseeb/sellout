import 'package:flutter/material.dart';

import '../../domain/entities/promo_entity.dart';
import 'promo_screen.dart' show PromoMedia, PromoStoryHeader;

class PromoFeedScreen extends StatefulWidget {
  const PromoFeedScreen({
    required this.promos,
    super.key,
    this.initialIndex = 0,
  });

  final List<PromoEntity> promos;
  final int initialIndex;

  @override
  State<PromoFeedScreen> createState() => _PromoFeedScreenState();
}

class _PromoFeedScreenState extends State<PromoFeedScreen> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: widget.initialIndex.clamp(0, widget.promos.length - 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemCount: widget.promos.length,
        itemBuilder: (BuildContext context, int index) {
          final PromoEntity promo = widget.promos[index];

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // Media
              PromoMedia(
                promo: promo,
                // TikTok-like feed: do not auto-advance on completion.
                onVideoCompleted: null,
              ),

              // Top gradient
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 160,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Colors.black54, Colors.transparent],
                    ),
                  ),
                ),
              ),

              // Bottom gradient
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 200,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[Colors.black87, Colors.transparent],
                    ),
                  ),
                ),
              ),

              // Header (includes back button)
              SafeArea(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 8),
                    PromoStoryHeader(promo: promo),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
