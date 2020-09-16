library sm_websocket;

import 'dart:io' as io;

import 'package:sm_websocket/sm_websocket.dart';

class WebSocket implements IWebSocket {
  io.WebSocket _socket;

  OnSuccess _onSuccess;
  OnFail _onFail;
  OnClose _onClose;
  OnMessage _onMessage;

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
    this._open(url);
  }

  _open(String url) async {
    this.close();

    try {
      this._socket = await io.WebSocket.connect(url);

      if (this._socket.readyState == io.WebSocket.open) {
        if (_onSuccess != null) {
          _onSuccess();
        }
      }

      this._socket.listen((event) {
        if (_onMessage != null) {
          _onMessage(event);
        }
      }, onDone: () {
        if (_onClose != null) {
          _onClose();
        }
        this._socket = null;
      });
    } catch (e) {
      if (_onFail != null) {
        _onFail();
      }
      this._socket = null;
    }
  }

  /// 关闭 WebSocket 连接.
  close() {
    this._socket?.close();
    this._socket = null;
  }

  /// 发送数据.
  send(String data) {
    this._socket?.add(data);
  }

  /// 获取连接状态.
  WebSocketState state() {
    return WebSocketState.values[this._socket?.readyState ?? 3];
  }
}
