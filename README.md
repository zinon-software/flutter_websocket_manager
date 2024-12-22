# FlutterWebSocketManager

**FlutterWebSocketManager** is a simple and flexible Flutter package for managing WebSocket connections. It helps you easily handle WebSocket connections, messages, errors, and connection states in your Flutter applications.

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
```

Then run:

```bash
flutter pub get
```

## Usage

### Creating a WebSocket Connection

```dart
import 'package:flutter_websocket_manager/flutter_websocket_manager.dart';

void main() {
  // Create a FlutterWebSocketManager instance with optional headers and query parameters
  final wsManager = FlutterWebSocketManager(
    "wss://example.com/ws",
    queryParameters: {
      'token': '12345',  // You can add query parameters here
    },
    headers: {
      'Authorization': 'Bearer your_access_token',  // You can add custom headers here
    },
  );

  // Connect to the WebSocket
  wsManager.connect();

  // Set a callback for receiving messages
  wsManager.onMessage((message) {
    print("Received message: $message");
  });

  // Set a callback for handling errors
  wsManager.onError((error) {
    print("Error: $error");
  });

  // To send a text message
  wsManager.sendMessage("Hello, server!");

  // To send a data message (JSON)
  wsManager.sendDataMessage({'type': 'ping'});

  // To get the current connection state
  switch (wsManager.state) {
    case SocketConnectionState.connected:
      print("WebSocket is connected.");
      break;
    case SocketConnectionState.disconnected:
      print("WebSocket is disconnected.");
      break;
    case SocketConnectionState.none:
      print("WebSocket connection state is none.");
      break;
  }

  // To disconnect
  wsManager.disconnect();
}
```

### Adding `queryParameters` and `headers`

You can pass `queryParameters` and `headers` when creating the `FlutterWebSocketManager` instance:

- **`queryParameters`**: Pass query parameters as a `Map`, which will be added to the WebSocket URL.
- **`headers`**: Custom headers such as "Authorization" can be added when connecting to the server.

```dart
final wsManager = FlutterWebSocketManager(
  "wss://example.com/ws",
  queryParameters: {
    'orderId': '2631',  // Add query parameters as needed
  },
  headers: {
    'Authorization': 'Bearer your_token_here',  // Add custom headers
    'Custom-Header': 'CustomValue',
  },
);
```

### Practical Example

```dart
import 'package:flutter_websocket_manager/flutter_websocket_manager.dart';

void main() {
  final wsManager = FlutterWebSocketManager(
    "wss://example.com/ws",
    queryParameters: {'orderId': '2631'}, // Query parameters
    headers: {'Authorization': 'Bearer token'}, // Custom headers
  );

  // Connect to the WebSocket
  wsManager.connect();

  // Listen for messages
  wsManager.onMessage((message) {
    print("Received message: $message");
  });

  // Handle errors
  wsManager.onError((error) {
    print("Error: $error");
  });

  // Send a text message
  wsManager.sendMessage("Hello WebSocket");

  // Send a data message (JSON)
  wsManager.sendDataMessage({'action': 'ping'});

  // Disconnect
  wsManager.disconnect();
}
```

---
