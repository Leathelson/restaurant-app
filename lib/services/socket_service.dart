import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  static SocketService get instance => _instance;

  late WebSocketChannel _channel;
  late Stream _broadcastStream;

  SocketService._internal() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:3000'), // Android emulator
    );

    _broadcastStream = _channel.stream.asBroadcastStream();
  }

  //sending token
void sendFirebaseToken(String idToken) {
  final message = jsonEncode({
    'event': 'firebase_login',
    'data': {'token': idToken},
  });
  _channel.sink.add(message);
}


  // REGISTER
  void sendRegisterData({
    required String name,
    required String phone,
    required String email,
    required String token,
  }) {
    _channel.sink.add(jsonEncode({
      'event': 'registerData',
      'name': name,
      'phone': phone,
      'email': email,
      'token': token,
    }));
  }

  // STREAM (broadcast-safe)
  Stream get stream => _broadcastStream;

  void dispose() {
    _channel.sink.close();
  }
}
