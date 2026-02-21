import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;

  // Change this IP to your machine's local IP if testing on real device
  // Emulator: 10.0.2.2
  // Real Device: 192.168.x.x
  static const String _serverUrl = 'http://192.168.1.5:5000'; // Replace with actual IP

  void connect() {
    _socket = IO.io(_serverUrl, IO.OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .enableAutoConnect() 
        .build());

    _socket.connect();

    _socket.onConnect((_) {
      print('🔌 [Socket] Connected to $_serverUrl');
    });

    _socket.onDisconnect((_) {
      print('❌ [Socket] Disconnected');
    });
    
    _socket.on('server_status', (data) {
       print('✨ [Socket] Server Status: $data');
    });
  }

  void emit(String event, dynamic data) {
    if (_socket.connected) {
      _socket.emit(event, data);
    }
  }

  void on(String event, Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  void dispose() {
    _socket.dispose();
  }
}
