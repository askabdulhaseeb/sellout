import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';
import '../../../../../core/constants/app_spacings.dart';
import '../../../../../core/sources/data_state.dart';
import '../../../../../core/widgets/utils/in_dev_mode.dart';
import '../../../../../services/get_it.dart';
import '../../../post/post_detail/views/screens/post_detail_screen.dart';
import '../../../user/profiles/data/sources/local/local_user.dart';
import '../../../user/profiles/domain/usecase/get_user_by_uid.dart';
import '../../domain/entities/promo_entity.dart';

class PromoScreen extends StatefulWidget {
  const PromoScreen({required this.promo, super.key, this.photoDuration});
  final PromoEntity promo;
  final Duration? photoDuration;

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _defaultPhotoDuration = Duration(seconds: 6);

  late final bool _isImage;
  late final Duration _photoDuration;
  AnimationController? _photoTimer;
  bool _closing = false;
  bool _suspended = false;

  @override
  void initState() {
    super.initState();
    _isImage = widget.promo.promoType.toLowerCase() == 'image';
    _photoDuration = widget.photoDuration ?? _defaultPhotoDuration;

    if (_isImage) {
      _photoTimer = AnimationController(vsync: this, duration: _photoDuration)
        ..addListener(() {
          if (mounted) setState(() {});
        })
        ..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            _closeIfCurrent();
          }
        });

      // Start after first frame so navigation state is stable.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_suspended) {
          _photoTimer?.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _photoTimer?.dispose();
    super.dispose();
  }

  void _closeIfCurrent() {
    if (!mounted || _closing || _suspended) return;
    final ModalRoute<dynamic>? route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) return;

    _closing = true;
    Navigator.of(context).maybePop();
  }

  Future<void> _goToReference() async {
    final String pid = widget.promo.referenceId.trim();
    if (pid.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('post_not_found')));
      return;
    }

    setState(() => _suspended = true);
    _photoTimer?.stop();

    await Navigator.of(context).pushNamed(
      PostDetailScreen.routeName,
      arguments: <String, String>{'pid': pid},
    );

    if (!mounted) return;
    setState(() => _suspended = false);
    if (_isImage && (_photoTimer?.isCompleted == false)) {
      _photoTimer?.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Media content
          Positioned.fill(
            child: PromoMedia(
              promo: widget.promo,
              onVideoCompleted: _closeIfCurrent,
            ),
          ),

          // Top gradient for better text visibility
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

          // Bottom gradient for footer visibility
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

          // Content overlay
          SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 8),
                // Animated progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _PromoProgressBar(
                    progress: _isImage ? (_photoTimer?.value ?? 0) : null,
                    isVideo: !_isImage,
                  ),
                ),
                const SizedBox(height: 12),
                PromoStoryHeader(
                  promo: widget.promo,
                  onSuspend: () {
                    setState(() => _suspended = true);
                    _photoTimer?.stop();
                  },
                  onResume: () {
                    setState(() => _suspended = false);
                    if (_isImage && (_photoTimer?.isCompleted == false)) {
                      _photoTimer?.forward();
                    }
                  },
                ),
                const Spacer(),
                if (widget.promo.referenceId.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: PromoFooter(
                      promo: widget.promo,
                      onOrderNow: _goToReference,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoProgressBar extends StatelessWidget {
  const _PromoProgressBar({this.progress, this.isVideo = false});
  final double? progress;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.white.withOpacity(0.25),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double progressWidth = isVideo
              ? constraints.maxWidth
              : constraints.maxWidth * (progress ?? 0);
          return Stack(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: isVideo ? constraints.maxWidth : progressWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    colors: isVideo
                        ? <Color>[
                            Colors.white.withOpacity(0.4),
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.4),
                          ]
                        : <Color>[Colors.white.withOpacity(0.9), Colors.white],
                  ),
                ),
              ),
              if (isVideo)
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 2),
                  builder: (BuildContext context, double value, Widget? child) {
                    return Positioned(
                      left: constraints.maxWidth * value - 20,
                      child: Container(
                        width: 40,
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            colors: <Color>[
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.8),
                              Colors.white.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class PromoStoryHeader extends StatefulWidget {
  const PromoStoryHeader({
    required this.promo,
    super.key,
    this.onSuspend,
    this.onResume,
  });
  final PromoEntity promo;
  final VoidCallback? onSuspend;
  final VoidCallback? onResume;

  @override
  State<PromoStoryHeader> createState() => _PromoStoryHeaderState();
}

class _PromoStoryHeaderState extends State<PromoStoryHeader> {
  late final Future<UserEntity?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUser();
  }

  Future<UserEntity?> _loadUser() async {
    final UserEntity? cached = LocalUser().userEntity(widget.promo.createdBy);
    if (cached != null) return cached;

    final GetUserByUidUsecase getUserByUid = GetUserByUidUsecase(locator());
    final DataState<UserEntity?> res = await getUserByUid.call(
      widget.promo.createdBy,
    );
    if (res is DataSuccess<UserEntity?>) {
      return res.entity;
    }
    return null;
  }

  String _formatTimeAgo(DateTime date) {
    final Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 0) {
      return '${diff.inDays}d';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m';
    }
    return 'now'.tr();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: FutureBuilder<UserEntity?>(
        future: _userFuture,
        builder: (BuildContext context, AsyncSnapshot<UserEntity?> snap) {
          final UserEntity? user = snap.data;
          final String profileUrl =
              user?.profilePhotoURL ?? 'https://via.placeholder.com/150';
          final String username = user?.username ?? 'Unknown';
          final String timeAgo = _formatTimeAgo(widget.promo.createdAt);

          return Row(
            children: <Widget>[
              // Back button with glassmorphism
              _GlassButton(
                onTap: () => Navigator.of(context).maybePop(),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              // Profile section
              Expanded(
                child: Row(
                  children: <Widget>[
                    // Profile avatar with ring
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: CachedNetworkImage(
                            imageUrl: profileUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: Colors.white.withOpacity(0.12),
                              alignment: Alignment.center,
                              child: const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.white.withOpacity(0.12),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.person,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Username and time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            timeAgo,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Actions
              InDevMode(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _GlassButton(
                      onTap: () {},
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.promo.views?.length.toString() ?? '0',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _GlassButton(
                      onTap: () {},
                      child: const Icon(
                        Icons.more_horiz_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
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

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(8),
  });
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withOpacity(0.15),
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class PromoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PromoAppBar({required this.promo, super.key});
  final PromoEntity promo;

  @override
  Widget build(BuildContext context) {
    final GetUserByUidUsecase getUserByUid = GetUserByUidUsecase(locator());

    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: double.infinity,
      leading: FutureBuilder<DataState<UserEntity?>>(
        future: getUserByUid.call(promo.createdBy),
        builder:
            (
              BuildContext context,
              AsyncSnapshot<DataState<UserEntity?>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                );
              }
              String profileUrl = 'https://via.placeholder.com/150';
              String username = 'Unknown';
              if (snapshot.hasData &&
                  snapshot.data is DataSuccess<UserEntity?>) {
                final UserEntity? user =
                    (snapshot.data as DataSuccess<UserEntity?>).entity;
                if (user != null) {
                  profileUrl = user.profilePhotoURL ?? profileUrl;
                  username = user.username;
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(profileUrl),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InDevMode(
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.favorite_border, size: 14),
                          const SizedBox(width: 2),
                          const Text('45', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 6),
                          const Icon(Icons.remove_red_eye, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            promo.views?.length.toString() ?? 'na'.tr(),
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.more_vert, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
      ),
    );
  }

  // String _formatTimeAgo(String timestamp) {
  //   final DateTime? date = DateTime.tryParse(timestamp);

  //   if (date == null) {
  //     debugPrint('Invalid timestamp: $timestamp');
  //     return '';
  //   }

  //   final Duration duration = DateTime.now().difference(date);
  //   if (duration.inDays > 0) {
  //     return '${duration.inDays} ${duration.inDays == 1 ? 'day' : 'days'} ago';
  //   }
  //   if (duration.inHours > 0) {
  //     return '${duration.inHours} ${duration.inHours == 1 ? 'hour' : 'hours'} ago';
  //   }
  //   if (duration.inMinutes > 0) {
  //     return '${duration.inMinutes} ${duration.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  //   }
  //   return 'just now';
  // }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PromoMedia extends StatelessWidget {
  const PromoMedia({required this.promo, super.key, this.onVideoCompleted});
  final PromoEntity promo;
  final VoidCallback? onVideoCompleted;

  @override
  Widget build(BuildContext context) {
    if ((promo.promoType).toLowerCase() == 'image') {
      return CachedNetworkImage(
        imageUrl: promo.fileUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
        errorWidget: (_, __, ___) => const Center(
          child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
        ),
      );
    } else {
      return PromoVideoMedia(url: promo.fileUrl, onCompleted: onVideoCompleted);
    }
  }
}

class PromoVideoMedia extends StatefulWidget {
  const PromoVideoMedia({required this.url, super.key, this.onCompleted});

  final String url;
  final VoidCallback? onCompleted;

  @override
  State<PromoVideoMedia> createState() => _PromoVideoMediaState();
}

class _PromoVideoMediaState extends State<PromoVideoMedia>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _hasError = false;
  bool _ended = false;
  bool _showControls = false;
  late final AnimationController _controlsAnimController;
  late final Animation<double> _controlsOpacity;

  @override
  void initState() {
    super.initState();
    _controlsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _controlsOpacity = CurvedAnimation(
      parent: _controlsAnimController,
      curve: Curves.easeOut,
    );
    _init();
  }

  Future<void> _init() async {
    try {
      final Uri? uri = Uri.tryParse(widget.url);
      if (uri == null) {
        setState(() => _hasError = true);
        return;
      }

      if (uri.isScheme('http') || uri.isScheme('https')) {
        _controller = VideoPlayerController.networkUrl(uri);
      } else if (uri.isScheme('file')) {
        _controller = VideoPlayerController.file(File(uri.toFilePath()));
      } else {
        _controller = VideoPlayerController.file(File(widget.url));
      }

      await _controller!.initialize();
      await _controller!.setLooping(false);
      await _controller!.play();

      _controller!.addListener(_onTick);

      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _onTick() {
    if (!mounted || _controller == null) return;
    final VideoPlayerValue v = _controller!.value;
    final bool isCompleted =
        v.isInitialized &&
        v.duration != Duration.zero &&
        v.position >= v.duration &&
        !v.isPlaying;

    if (isCompleted && !_ended) {
      _ended = true;
      widget.onCompleted?.call();
      return;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller?.removeListener(_onTick);
    _controller?.dispose();
    _controlsAnimController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    final VideoPlayerController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (_ended) {
      _ended = false;
      controller.seekTo(Duration.zero);
      controller.play();
      setState(() {});
      return;
    }

    if (controller.value.isPlaying) {
      controller.pause();
      _showControls = true;
      _controlsAnimController.forward();
    } else {
      controller.play();
      _hideControlsAfterDelay();
    }
    setState(() {});
  }

  void _hideControlsAfterDelay() {
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted && _controller?.value.isPlaying == true) {
        _controlsAnimController.reverse().then((_) {
          if (mounted) setState(() => _showControls = false);
        });
      }
    });
  }

  void _onTapVideo() {
    if (_showControls) {
      _togglePlayPause();
    } else {
      setState(() => _showControls = true);
      _controlsAnimController.forward();
      if (_controller?.value.isPlaying == true) {
        _hideControlsAfterDelay();
      }
    }
  }

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.white70,
                size: 40,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Unable to load video',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    final VideoPlayerController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    final Size size = controller.value.size;
    final Duration position = controller.value.position;
    final Duration duration = controller.value.duration;
    final bool isPlaying = controller.value.isPlaying;
    final double progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTapVideo,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Video
          ClipRect(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: VideoPlayer(controller),
              ),
            ),
          ),

          // Play/Pause overlay
          if (_showControls || !isPlaying)
            FadeTransition(
              opacity: _controlsOpacity,
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: _VideoControlButton(
                    icon: _ended
                        ? Icons.replay_rounded
                        : isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    onTap: _togglePlayPause,
                    size: 72,
                  ),
                ),
              ),
            ),

          // Video progress bar at bottom
          Positioned(
            left: 16,
            right: 16,
            bottom: 100,
            child: FadeTransition(
              opacity: _controlsOpacity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Time indicators
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _formatDuration(position),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _formatDuration(duration),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: SizedBox(
                      height: 4,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoControlButton extends StatelessWidget {
  const _VideoControlButton({
    required this.icon,
    required this.onTap,
    this.size = 56,
  });
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withOpacity(0.2),
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white.withOpacity(0.3),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: Colors.white, size: size * 0.5),
            ),
          ),
        ),
      ),
    );
  }
}

class PromoFooter extends StatelessWidget {
  const PromoFooter({required this.promo, required this.onOrderNow, super.key});

  final PromoEntity promo;
  final VoidCallback onOrderNow;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 0.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      promo.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '\$${promo.price ?? "0"}',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _AnimatedOrderButton(
                onPressed: onOrderNow,
                primaryColor: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedOrderButton extends StatefulWidget {
  const _AnimatedOrderButton({
    required this.onPressed,
    required this.primaryColor,
  });
  final VoidCallback onPressed;
  final Color primaryColor;

  @override
  State<_AnimatedOrderButton> createState() => _AnimatedOrderButtonState();
}

class _AnimatedOrderButtonState extends State<_AnimatedOrderButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    widget.primaryColor,
                    widget.primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: widget.primaryColor.withOpacity(
                      _isPressed ? 0.2 : 0.4,
                    ),
                    blurRadius: _isPressed ? 8 : 12,
                    offset: Offset(0, _isPressed ? 2 : 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'order_now_>'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
