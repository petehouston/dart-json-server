import 'dart:async';
import 'dart:convert';
import 'dart:io';

const keyData = 'data';
const keyHost = 'host';
const keyPort = 'port';
const res404 = '''
{
  "message": "not found"
}
''';

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
    if (!this.config.containsKey(keyData)) {
      return Future.error('Missing key `data` in config');
    }

    var dbPath = this.config[keyData];
    this.database = jsonDecode(File(dbPath).readAsStringSync());

    // init server
    if (!this.config.containsKey(keyHost)) {
      this.config[keyHost] = '127.0.0.1';
    }

    if (!this.config.containsKey(keyPort)) {
      this.config[keyPort] = '8080';
    }

    this.server = await HttpServer.bind(InternetAddress.loopbackIPv4, int.parse(this.config[keyPort]));

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
      ..headers.contentType = ContentType('application', 'json', charset: 'utf-8');

    var apiPath = req.requestedUri.path;

    if (!this.database.containsKey(apiPath)) {
      req.response.write('{"error": "API not found"}');
    } else {
      req.response.write(jsonEncode(this.database[apiPath]));
    }

    await req.response.close();
  }
}
