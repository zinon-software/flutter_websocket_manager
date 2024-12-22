library flutter_websocket_manager;

import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// A class that manages WebSocket connections, allowing for easy connection,
/// message handling, and disconnection. It supports passing custom headers
/// and query parameters when connecting to the WebSocket server.
class FlutterWebSocketManager {
  // URL of the WebSocket server
  final String url;

  // Optional query parameters that can be added to the WebSocket URL
  final Map<String, dynamic>? queryParameters;

  // Optional headers that can be sent when connecting to the WebSocket server
  final Map<String, dynamic>? headers;

  // WebSocket channel used for communication
  late WebSocketChannel _channel;

  // State of the WebSocket connection (connected, disconnected, or none)
  late SocketConnectionState _state;

  // Callback function to handle incoming messages from the WebSocket server
  Function(dynamic)? _messageCallback;

  // Callback function to handle errors during WebSocket communication
  Function(dynamic)? _errorCallback;

  /// Constructor to initialize the FlutterWebSocketManager with a WebSocket [url],
  /// optional [headers] and optional [queryParameters].
  FlutterWebSocketManager(this.url, {this.headers, this.queryParameters}) {
    // Default state is none (not connected)
    _state = SocketConnectionState.none;
  }

  /// Connects to the WebSocket server and listens for incoming messages.
  /// If an error occurs or the connection is closed, the corresponding callback
  /// is triggered if provided.
  void connect() async {
    try {
      // Parse the URL and add any query parameters
      final wsUrl = Uri.parse(url).replace(
        queryParameters: queryParameters,
      );

      // Connect to the WebSocket server with optional headers
      _channel = IOWebSocketChannel.connect(
        wsUrl,
        headers: headers,
      );

      // Set the state to connected
      _state = SocketConnectionState.connected;

      // Wait for the WebSocket connection to be ready
      await _channel.ready;

      // Listen to incoming messages from the WebSocket stream
      _channel.stream.listen(
        (message) {
          _state = SocketConnectionState.connected;

          // If a message callback is provided, call it with the received message
          if (_messageCallback != null) {
            _messageCallback!(message);
          }
        },
        onError: (error) {
          // Disconnect on error and trigger the error callback if provided
          disconnect();
          if (_errorCallback != null) {
            _errorCallback!(error);
          }
        },
        onDone: () {
          // When the connection is closed, trigger the done/error callback
          disconnect();
          if (_errorCallback != null) {
            _errorCallback!("onDone");
          }
        },
      );
    } catch (e) {
      // If an exception occurs, set the state to disconnected and trigger the error callback
      _state = SocketConnectionState.disconnected;
      if (_errorCallback != null) {
        _errorCallback!(e);
      }
    }
  }

  /// Sends a message to the WebSocket server.
  /// The [message] parameter is a Map that will be converted to JSON and sent.
  void sendMessage(String message) {
    _channel.sink.add(message);
  }

  void sendDataMessage(Map<String, dynamic> message) {
    _channel.sink.add(jsonEncode(message));
  }

  /// Disconnects from the WebSocket server and closes the connection.
  void disconnect() {
    if (state == SocketConnectionState.connected) {
      // Close the WebSocket connection with a custom code (3000)
      _channel.sink.close(3000);
      _state = SocketConnectionState.disconnected;
    }
  }

  /// Sets the callback function for handling incoming messages.
  /// The [callback] will be called with the message as an argument.
  void onMessage(Function(dynamic) callback) {
    _messageCallback = callback;
  }

  /// Sets the callback function for handling errors and disconnections.
  /// The [callback] will be called with the error or disconnection reason.
  void onError(Function(dynamic) callback) {
    _errorCallback = callback;
  }

  /// Returns the current state of the WebSocket connection.
  SocketConnectionState get state => _state;
}

/// Enum representing the possible states of the WebSocket connection.
/// - [connected]: WebSocket connection is active.
/// - [disconnected]: WebSocket connection is closed or disconnected.
/// - [none]: Initial state, before a connection is established.
enum SocketConnectionState { connected, disconnected, none }
