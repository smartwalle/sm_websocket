library sm_websocket;

import 'dart:html' as html;
import 'dart:typed_data';

import 'package:sm_websocket/sm_websocket.dart';

enum _OpenStatus {
  Pending, // 等待建立连接
  Success, // 建立连接成功
  Failed, // 建立连接失败
}

class WebSocket implements IWebSocket {
  html.WebSocket _socket;

  OnSuccess _onSuccess;
  OnFail _onFail;
  OnClose _onClose;
  OnMessage _onMessage;

  _OpenStatus _openStatus;

  /// 建立 WebSocket 连接成功的回调.
  onSuccess(OnSuccess callback) {
    _onSuccess = callback;
  }

  /// 建立 WebSocket 连接失败的回调.
  onFail(OnFail callback) {
    _onFail = callback;
  }

  /// WebSocket 关闭的回调.
  onClose(OnClose callback) {
    _onClose = callback;
  }

  /// 接收到 WebSocket 消息的回调.
  onMessage(OnMessage callback) {
    _onMessage = callback;
  }

  /// 建立 WebSocket 连接.
  open(String url) {
    this.close();

    this._openStatus = _OpenStatus.Pending;
    this._socket = html.WebSocket(url);
    this._socket.binaryType = "arraybuffer";

    this._socket.onOpen.first.then((value) {
      this._openStatus = _OpenStatus.Success;
      if (_onSuccess != null) {
        _onSuccess();
      }
    });

    this._socket.onError.first.then((value) {
      this._openStatus = _OpenStatus.Failed;
      if (_onFail != null) {
        _onFail();
      }
      this._socket = null;
    });

    this._socket.onClose.first.then((value) {
      if (_onClose != null && this._openStatus != _OpenStatus.Failed) {
        _onClose();
      }
      this._socket = null;
    });

    this._socket.onMessage.listen((event) {
      if (_onMessage != null) {
        if (event.data is ByteBuffer) {
          var buf = event.data as ByteBuffer;
          _onMessage(buf.asUint8List());
        } else {
          _onMessage(event.data);
        }
      }
    });
  }

  /// 关闭 WebSocket 连接.
  close() {
    this._socket?.close();
    this._socket = null;
  }

  /// 发送数据.
  send(String data) {
    this._socket?.sendString(data);
  }

  sendUint8List(Uint8List data) {
    this._socket?.sendByteBuffer(data.buffer);
  }

  /// 获取连接状态.
  WebSocketState state() {
    return WebSocketState.values[this._socket?.readyState ?? 3];
  }
}
