import 'package:json_server/json_server.dart' as json_server;
import 'dart:io';

main() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print("Serving at ${server.address}:${server.port}");

  await for (var request in server) {

    request.response
      ..headers.contentType = ContentType("text", "plain", charset: "utf-8")
      ..write(request.uri.path);
    await request.response.close();
  }
}
