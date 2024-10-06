# WebSocketManager

**WebSocketManager** is a simple and flexible Flutter package for managing WebSocket connections. It helps you easily handle WebSocket connections, messages, errors, and connection states in your Flutter applications.

## Features

- Connect to WebSocket servers with custom headers and query parameters.
- Send and receive messages over WebSocket.
- Handle connection states (connected, disconnected, etc.).
- Handle errors and disconnections gracefully.
- Set callback functions for message handling and errors.

## Installation

To install this package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_websocket_manager: ^0.0.1

import 'package:flutter_websocket_manager/flutter_websocket_manager.dart';

void main() {
  final wsManager = WebSocketManager("wss://example.com/ws");

  wsManager.connect();

  wsManager.setMessageCallback((message) {
    print("Received message: $message");
  });

  wsManager.setErrorCallback((error) {
    print("Error: $error");
  });

  // To send a message
  wsManager.sendMessage({'type': 'ping'});

  // To disconnect
  wsManager.disconnect();
}
