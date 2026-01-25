import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';


class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  static SocketService get instance => _instance;

  late WebSocketChannel _channel;

  SocketService._internal() {
    
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:3306'), // Android emulator
      // ws://localhost:3000 for desktop/web
    );
  }

  void login(String email, String password) {
    _channel.sink.add(jsonEncode({
      'type': 'login',
      'email': email,
      'password': password,
    }));
  }

  void register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    _channel.sink.add(jsonEncode({
      'type': 'register',
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
    }));
  }


  Stream get stream => _channel.stream;

  void dispose() {
    _channel.sink.close();
  }
}

