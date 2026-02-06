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
      Uri.parse('ws://192.168.100.58:3000'), // Android emulator for smrithi
    );

    _broadcastStream = _channel.stream.asBroadcastStream();
  }

  // LOGIN
  void login(String email, String password) {
    _channel.sink.add(
      jsonEncode({'type': 'login', 'email': email, 'password': password}),
    );
  }

  // REGISTER
  void register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    _channel.sink.add(
      jsonEncode({
        'type': 'register',
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
      }),
    );
  }

  // STREAM (broadcast-safe)
  Stream get stream => _broadcastStream;

  void dispose() {
    _channel.sink.close();
  }
}
