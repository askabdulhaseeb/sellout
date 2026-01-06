import 'package:flutter/material.dart';
import '../../../../../../services/get_it.dart';
import '../../../chat_dashboard/data/sources/socket/chat_socket_handler.dart';

/// Animated typing indicator that shows when other users are typing.
/// Displays animated dots with the typing user's name(s).
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    required this.chatId,
    super.key,
  });

  final String chatId;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final ChatSocketHandler _chatSocketHandler;

  @override
  void initState() {
    super.initState();
    _chatSocketHandler = locator<ChatSocketHandler>();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, List<TypingUser>>>(
      valueListenable: _chatSocketHandler.typingUsersNotifier,
      builder: (BuildContext context, Map<String, List<TypingUser>> typingMap, _) {
        final List<TypingUser> typingUsers = typingMap[widget.chatId] ?? <TypingUser>[];

        if (typingUsers.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildTypingWidget(context, typingUsers);
      },
    );
  }

  Widget _buildTypingWidget(BuildContext context, List<TypingUser> typingUsers) {
    final ThemeData theme = Theme.of(context);
    final String typingText = _buildTypingText(typingUsers);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _AnimatedTypingDots(
            animation: _animationController,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              typingText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _buildTypingText(List<TypingUser> typingUsers) {
    if (typingUsers.isEmpty) return '';

    if (typingUsers.length == 1) {
      final String name = typingUsers.first.displayName ?? 'Someone';
      return '$name is typing...';
    }

    if (typingUsers.length == 2) {
      final String name1 = typingUsers[0].displayName ?? 'Someone';
      final String name2 = typingUsers[1].displayName ?? 'Someone';
      return '$name1 and $name2 are typing...';
    }

    final String firstName = typingUsers.first.displayName ?? 'Someone';
    return '$firstName and ${typingUsers.length - 1} others are typing...';
  }
}

/// Animated dots widget that creates a bouncing effect.
class _AnimatedTypingDots extends StatelessWidget {
  const _AnimatedTypingDots({
    required this.animation,
    required this.color,
  });

  final Animation<double> animation;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildDot(0),
            const SizedBox(width: 3),
            _buildDot(1),
            const SizedBox(width: 3),
            _buildDot(2),
          ],
        );
      },
    );
  }

  Widget _buildDot(int index) {
    // Stagger the animation for each dot
    final double delay = index * 0.2;
    final double animValue = ((animation.value + delay) % 1.0);

    // Create a bounce effect
    double scale;
    if (animValue < 0.5) {
      scale = 1.0 + (animValue * 0.6); // Scale up
    } else {
      scale = 1.3 - ((animValue - 0.5) * 0.6); // Scale down
    }

    return Transform.scale(
      scale: scale,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.7),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Compact typing indicator for use in chat list tiles.
class TypingIndicatorCompact extends StatefulWidget {
  const TypingIndicatorCompact({
    required this.chatId,
    super.key,
  });

  final String chatId;

  @override
  State<TypingIndicatorCompact> createState() => _TypingIndicatorCompactState();
}

class _TypingIndicatorCompactState extends State<TypingIndicatorCompact>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final ChatSocketHandler _chatSocketHandler;

  @override
  void initState() {
    super.initState();
    _chatSocketHandler = locator<ChatSocketHandler>();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, List<TypingUser>>>(
      valueListenable: _chatSocketHandler.typingUsersNotifier,
      builder: (BuildContext context, Map<String, List<TypingUser>> typingMap, _) {
        final List<TypingUser> typingUsers = typingMap[widget.chatId] ?? <TypingUser>[];

        if (typingUsers.isEmpty) {
          return const SizedBox.shrink();
        }

        final ThemeData theme = Theme.of(context);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _AnimatedTypingDots(
              animation: _animationController,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              'typing...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }
}
