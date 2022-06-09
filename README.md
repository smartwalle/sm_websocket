# websocket

WebSocket client for Dart.

## Getting Started

```dart
import 'package:sm_websocket/sm_websocket.dart';

IWebSocket ws = WebSocket();

ws.onSuccess(() {
print("连接成功");
});

ws.onFailed(() {
print("连接失败");
});

ws.onMessage((data) {
print(data);
});

ws.onClose(() {
print("断开连接");
});

ws.open("ws://127.0.0.1:6656/ws");
```
