export 'package:sm_websocket/src/web.dart' if (dart.library.io) 'package:sm_websocket/src/io.dart';

typedef OnSuccess = void Function();
typedef OnFail = void Function();
typedef OnClose = void Function();
typedef OnMessage = void Function(dynamic data);

abstract class IWebSocket {
  /// 建立 WebSocket 连接成功的回调.
  onSuccess(OnSuccess callback);

  /// 建立 WebSocket 连接失败的回调.
  onFail(OnFail callback);

  /// WebSocket 关闭的回调.
  onClose(OnClose callback);

  /// 接收到 WebSocket 消息的回调.
  onMessage(OnMessage callback);

  /// 建立 WebSocket 连接.
  open(String url);

  /// 关闭 WebSocket 连接.
  close();

  /// 发送数据.
  send(String data);
}
