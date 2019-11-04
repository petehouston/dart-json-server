import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'utils.dart';

const keyData = 'data';
const keyHost = 'host';
const keyPort = 'port';

const defaultHost = '127.0.0.1';
const defaultPort = '1711';

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

    if (!this.config.containsKey(keyHost)) {
      this.config[keyHost] = defaultHost;
    }

    if (!this.config.containsKey(keyPort)) {
      this.config[keyPort] = defaultPort;
    }

    // set init
    this.initialized = true;
  }

  Future start() async {
    if (!this.initialized) {
      throw Exception('server is not initialized');
    }

    this.server = await HttpServer.bind(
      this.config[keyHost],
      int.parse(this.config[keyPort]),
      v6Only: false,
    );

    Log.i('Server is started at http://${config[keyHost]}:${config[keyPort]}');

    await for (var request in this.server) {
      request.response
        ..headers.contentType = ContentType('application', 'json', charset: 'utf-8');
      this._requestHandler(request);
    }
  }

  _requestHandler(req) async {
    try {
      var apiPath = req.requestedUri.path;

      if (!this.database.containsKey(apiPath)) {
        req.response.statusCode = HttpStatus.notFound;
        req.response.write(res404);
      } else {
        req.response.write(jsonEncode(this.database[apiPath]));
      }

      await req.response.close();
    } catch (e) {
      Log.e('${e}');
    }
  }
}
