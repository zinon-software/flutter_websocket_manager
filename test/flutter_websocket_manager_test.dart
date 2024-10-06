import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_websocket_manager/flutter_websocket_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Mock class for WebSocketChannel
class MockWebSocketChannel extends Mock implements WebSocketChannel {}

void main() {
  late FlutterWebSocketManager webSocketManager;
  late MockWebSocketChannel mockChannel;

  setUp(() {
    // Initialize the WebSocketManager with a mock channel
    mockChannel = MockWebSocketChannel();
    webSocketManager = FlutterWebSocketManager(
      'wss://example.com/ws',
      headers: {'Authorization': 'Bearer test_token'},
      queryParameters: {'test': '123'},
    );
  });

  test('WebSocketManager connects successfully', () async {
    // Simulate a successful connection
    webSocketManager.connect();

    // Check that the state is set to connected
    expect(webSocketManager.state, equals(SocketConnectionState.connected));
  });

  test('WebSocketManager sends a message successfully', () {
    final message = {'type': 'ping'};

    // Call sendMessage and verify that the message is sent
    webSocketManager.sendDataMessage(message);
    verify(mockChannel.sink.add(jsonEncode(message))).called(1);
  });

  test('WebSocketManager receives a message and triggers callback', () {
    const message = 'Test Message';
    bool messageReceived = false;

    // Set a callback to check if a message is received
    webSocketManager.onMessage((receivedMessage) {
      messageReceived = true;
      expect(receivedMessage, message);
    });

    // Simulate receiving a message
    webSocketManager.connect();
    mockChannel.stream.listen((_) {
      webSocketManager.sendMessage(message);
    });

    // Check if the callback was triggered
    expect(messageReceived, true);
  });

  test('WebSocketManager handles error and triggers error callback', () {
    final error = 'Test Error';
    bool errorTriggered = false;

    // Set an error callback
    webSocketManager.onError((receivedError) {
      errorTriggered = true;
      expect(receivedError, error);
    });

    // Simulate an error
    when(mockChannel.stream.listen(null)).thenThrow(error);

    // Check if the error callback was triggered
    expect(errorTriggered, true);
  });

  test('WebSocketManager disconnects successfully', () {
    webSocketManager.connect();
    webSocketManager.disconnect();

    // Check that the state is set to disconnected
    expect(webSocketManager.state, equals(SocketConnectionState.disconnected));
  });
}
