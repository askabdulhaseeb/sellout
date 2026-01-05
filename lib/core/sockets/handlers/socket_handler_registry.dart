import 'package:flutter/foundation.dart';
import 'base_socket_handler.dart';

/// Registry that manages socket event handlers with dynamic registration.
/// Features can register/unregister handlers at runtime.
///
/// Example:
/// ```dart
/// final registry = SocketHandlerRegistry();
/// registry.registerHandler(PresenceHandler());
/// registry.registerHandler(ChatHandler());
///
/// // Later, dispatch an event
/// await registry.dispatch('newMessage', data);
///
/// // Unregister when done
/// registry.unregisterHandler(myHandler);
/// ```
class SocketHandlerRegistry {
  /// Maps event names to their handler(s).
  /// Multiple handlers can be registered for the same event.
  final Map<String, List<BaseSocketHandler>> _handlers =
      <String, List<BaseSocketHandler>>{};

  /// Track all registered handlers for proper cleanup
  final Set<BaseSocketHandler> _allHandlers = <BaseSocketHandler>{};

  /// Register a handler for its supported events.
  void registerHandler(BaseSocketHandler handler) {
    _allHandlers.add(handler);

    for (final String event in handler.supportedEvents) {
      _handlers.putIfAbsent(event, () => <BaseSocketHandler>[]);
      if (!_handlers[event]!.contains(handler)) {
        _handlers[event]!.add(handler);
        debugPrint('SocketHandlerRegistry: Registered handler for "$event"');
      }
    }
  }

  /// Unregister a handler from all its events.
  void unregisterHandler(BaseSocketHandler handler) {
    for (final String event in handler.supportedEvents) {
      _handlers[event]?.remove(handler);
      if (_handlers[event]?.isEmpty ?? false) {
        _handlers.remove(event);
      }
      debugPrint('SocketHandlerRegistry: Unregistered handler for "$event"');
    }
    _allHandlers.remove(handler);
    handler.dispose();
  }

  /// Get all registered event names.
  Set<String> get registeredEvents => _handlers.keys.toSet();

  /// Check if an event has any handlers.
  bool hasHandlersFor(String eventName) =>
      _handlers[eventName]?.isNotEmpty ?? false;

  /// Dispatch an event to all registered handlers.
  Future<void> dispatch(String eventName, dynamic data) async {
    final List<BaseSocketHandler>? handlers = _handlers[eventName];
    if (handlers == null || handlers.isEmpty) {
      debugPrint('SocketHandlerRegistry: No handlers for event "$eventName"');
      return;
    }

    for (final BaseSocketHandler handler in handlers) {
      try {
        await handler.handleEvent(eventName, data);
      } catch (e, stackTrace) {
        debugPrint(
          'SocketHandlerRegistry: Error in handler for "$eventName": $e',
        );
        debugPrint(stackTrace.toString());
      }
    }
  }

  /// Clear all handlers. Used during logout/cleanup.
  void clear() {
    for (final BaseSocketHandler handler in _allHandlers) {
      handler.dispose();
    }
    _handlers.clear();
    _allHandlers.clear();
    debugPrint('SocketHandlerRegistry: All handlers cleared');
  }
}
