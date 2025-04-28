import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';

WebSocketChannel createWebSocketChannel(String url) {
  return HtmlWebSocketChannel.connect(Uri.parse(url));
}