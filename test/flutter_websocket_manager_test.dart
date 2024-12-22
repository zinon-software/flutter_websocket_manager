import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_websocket_manager/flutter_websocket_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Mock class for WebSocketChannel
class MockWebSocketChannel extends Mock implements WebSocketChannel {}

void main() {
  late FlutterWebSocketManager flutterWebSocketManager;
  late MockWebSocketChannel mockChannel;

  setUp(() {
    // Initialize the FlutterWebSocketManager with a mock channel
    mockChannel = MockWebSocketChannel();
    flutterWebSocketManager = FlutterWebSocketManager(
      'wss://example.com/ws',
      headers: {'Authorization': 'Bearer test_token'},
      queryParameters: {'test': '123'},
    );
  });

  test('FlutterWebSocketManager connects successfully', () async {
    // Simulate a successful connection
    flutterWebSocketManager.connect();

    // Check that the state is set to connected
    expect(flutterWebSocketManager.state, equals(SocketConnectionState.connected));
  });

  test('FlutterWebSocketManager sends a message successfully', () {
    final message = {'type': 'ping'};

    // Call sendMessage and verify that the message is sent
    flutterWebSocketManager.sendDataMessage(message);
    verify(mockChannel.sink.add(jsonEncode(message))).called(1);
  });

  test('FlutterWebSocketManager receives a message and triggers callback', () {
    const message = 'Test Message';
    bool messageReceived = false;

    // Set a callback to check if a message is received
    flutterWebSocketManager.onMessage((receivedMessage) {
      messageReceived = true;
      expect(receivedMessage, message);
    });

    // Simulate receiving a message
    flutterWebSocketManager.connect();
    mockChannel.stream.listen((_) {
      flutterWebSocketManager.sendMessage(message);
    });

    // Check if the callback was triggered
    expect(messageReceived, true);
  });

  test('FlutterWebSocketManager handles error and triggers error callback', () {
    const error = 'Test Error';
    bool errorTriggered = false;

    // Set an error callback
    flutterWebSocketManager.onError((receivedError) {
      errorTriggered = true;
      expect(receivedError, error);
    });

    // Simulate an error
    when(mockChannel.stream.listen(null)).thenThrow(error);

    // Check if the error callback was triggered
    expect(errorTriggered, true);
  });

  test('FlutterWebSocketManager disconnects successfully', () {
    flutterWebSocketManager.connect();
    flutterWebSocketManager.disconnect();

    // Check that the state is set to disconnected
    expect(flutterWebSocketManager.state, equals(SocketConnectionState.disconnected));
  });
}
