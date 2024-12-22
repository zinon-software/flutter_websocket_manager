// import 'package:flutter_websocket_manager/flutter_websocket_manager.dart';
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