import 'dart:async';
import 'dart:convert';
import 'dart:io';

class JsonServer {
  Map<String, dynamic> config = Map();
  Map<String, dynamic> database;
  bool initialized = false;
  HttpServer server;

  JsonServer({config}) {
    this.config = config;
  }

  dynamic getConfig(prop) {
    return this.config[prop];
  }

  Future init() async {
    // load database from config path
    if (!this.config.containsKey('data')) {
      return Future.error('Missing key `data` in config');
    }

    var dbPath = this.config['data'];
    this.database = jsonDecode(File(dbPath).readAsStringSync());

    // init server
    if (!this.config.containsKey('ip')) {
      this.config['ip'] = '127.0.0.1';
    }

    if (!this.config.containsKey('port')) {
      this.config['port'] = '8080';
    }

    this.server = await HttpServer.bind(InternetAddress.loopbackIPv4, int.parse(this.config['port']));

    // set init
    this.initialized = true;
  }

  Future start() async {
    if (!this.initialized) {
      throw Exception('server is not initialized');
    }
    await for (var request in this.server) {
      this._requestHandler(request);
    }
  }

  _requestHandler(req) async {
    req.response
      ..headers.contentType = ContentType("application", "json", charset: "utf-8");

    var apiPath = req.requestedUri.path;

    if (!this.database.containsKey(apiPath)) {
      req.response.write('{"error": "API not found"}');
    } else {
      req.response.write(jsonEncode(this.database[apiPath]));
    }

    await req.response.close();
  }
}
