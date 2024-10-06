library flutter_websocket_manager;

import 'dart:convert';
import 'dart:developer';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  final String url;
  Map<String, dynamic>? queryParameters;
  late WebSocketChannel _channel;
  late SocketConnectionState _state;
  Function(dynamic)? _callback;
  Function(dynamic)? _errorCallback;

  WebSocketManager(this.url, {this.queryParameters}) {
    _state = SocketConnectionState.none; // Default state is none
  }

  void connect() async {
    // Handle connection logic here
  }

  void sendMessage(Map<String, dynamic> message) {
    _channel.sink.add(jsonEncode(message));
  }

  void disconnect() {
    if (state == SocketConnectionState.connected) {
      _channel.sink.close(3000); // Close connection
      _state = SocketConnectionState.disconnected;
    }
  }

  void setMessageCallback(Function(dynamic) callback) {
    _callback = callback;
  }

  void setErrorCallback(Function(dynamic) callback) {
    _errorCallback = callback;
  }

  SocketConnectionState get state => _state;
}

enum SocketConnectionState { connected, disconnected, none }
