import 'dart:async' show Future;
import 'dart:io' show Platform;

import 'package:di/di.dart' show Module;
import 'package:redstone/redstone.dart' as app;
import 'package:redstone_web_socket/redstone_web_socket.dart' as ws;
import 'package:redstone_mapper/mapper.dart' show Field, NotEmpty,
                                                  Validator, encodeJson;
import 'package:redstone_mapper/plugin.dart' show getMapperPlugin, Decode;
import 'package:redstone_web_socket/redstone_web_socket.dart' show getWebSocketPlugin;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_static/shelf_static.dart' show createStaticHandler;
import 'package:http_parser/http_parser.dart' show CompatibleWebSocket;

void main() {
  // Provide static content:
  final webRoot = Platform.script.resolve('../build/web').toFilePath();
  app.setShelfHandler(
    createStaticHandler(
        webRoot,
        defaultDocument: "index.html",
      serveFilesOutsidePath: false
    )
  );

  app.addPlugin(getMapperPlugin());
  app.addPlugin(getWebSocketPlugin());

  app.addModule(
      new Module()
        ..bind(MessageSubscribers)
  );

  app.setupConsoleLog();
  app.start();
}

@app.Group('/messages')
class MessageService {
  final Validator _validator;
  MessageSubscribers _subscribers;

  MessageService(MessageSubscribers this._subscribers)
      : _validator = new Validator(Message);

  @app.Route('/', methods: const [app.POST])
  shelf.Response create(@Decode() Message message) {
    if (_validator.execute(message) != null) {
      return new shelf.Response(400);
    }

    _notifySubscribers(message);

    return new shelf.Response(202);
  }

  Future _notifySubscribers(Message message) async {
    _subscribers.notifyAll(message);
  }
}

@ws.WebSocketHandler("/ws")
class MessageSubscriptionEntryPoint {
  MessageSubscribers _subscribers;

  MessageSubscriptionEntryPoint(MessageSubscribers this._subscribers);

  @ws.OnOpen()
  void onOpen(ws.WebSocketSession session) {
    _subscribers.addSubscriber(session.connection);
  }

  @ws.OnClose()
  void onClose(ws.WebSocketSession session) {
    _subscribers.removeSubscriber(session.connection);
  }
}

class MessageSubscribers {

  final List<CompatibleWebSocket> _connections = new List<CompatibleWebSocket>();

  void addSubscriber(CompatibleWebSocket conn) {
    _connections.add(conn);
  }

  void removeSubscriber(CompatibleWebSocket conn) {
    _connections.remove(conn);
  }

  void notifyAll(Message message) {
    final json = encodeJson(message);
    _connections.forEach((conn) => conn.add(json));
  }
}

class Message {
  @Field()
  @NotEmpty()
  String recipient;

  @Field()
  String sender;

  @Field()
  @NotEmpty()
  String body;
}