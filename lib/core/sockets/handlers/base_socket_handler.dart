/// Base abstract class for all socket event handlers.
/// Handlers are domain-specific classes that process socket events.
///
/// Example:
/// ```dart
/// class MyHandler extends BaseSocketHandler {
///   @override
///   List<String> get supportedEvents => ['my-event'];
///
///   @override
///   Future<void> handleEvent(String eventName, dynamic data) async {
///     // Handle the event
///   }
/// }
/// ```
abstract class BaseSocketHandler {
  /// List of socket event names this handler is responsible for.
  /// Used for automatic registration with the SocketHandlerRegistry.
  List<String> get supportedEvents;

  /// Called when one of the supported events is received.
  /// [eventName] - The socket event name that triggered this handler.
  /// [data] - The raw dynamic data from the socket.
  Future<void> handleEvent(String eventName, dynamic data);

  /// Optional cleanup when handler is unregistered.
  /// Override if handler needs to release resources.
  void dispose() {}
}
