import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

WebSocketChannel createWebSocketChannel(String url) {
  return IOWebSocketChannel.connect(Uri.parse(url), pingInterval: const Duration(seconds: 15));
}