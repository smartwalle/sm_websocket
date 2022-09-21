import 'dart:typed_data';

export 'package:sm_websocket/src/web.dart' if (dart.library.io) 'package:sm_websocket/src/io.dart';

typedef OnSuccess = void Function();
typedef OnFailure = void Function();
typedef OnClose = void Function();
typedef OnMessage = void Function(dynamic data);

abstract class IWebSocket {
  /// 建立 WebSocket 连接成功的回调.
  onSuccess(OnSuccess callback);

  /// 建立 WebSocket 连接失败的回调.
  onFailure(OnFailure callback);

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

  sendUint8List(Uint8List data);

  /// 获取连接状态.
  WebSocketState state();
}

enum WebSocketState {
  /// 连接中
  Connecting,

  /// 已连接
  Open,

  /// 关闭中
  Closing,

  /// 已关闭
  Closed,
}
