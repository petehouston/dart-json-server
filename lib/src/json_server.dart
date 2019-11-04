import 'dart:async';
import 'dart:convert';
import 'dart:io';

const keyData = 'data';
const keyHost = 'host';
const keyPort = 'port';

const defaultHost = '127.0.0.1';
const defaultPort = 1711;

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
      this.config[keyHost] = defaultHost;
    }

    if (!this.config.containsKey(keyPort)) {
      this.config[keyPort] = defaultPort as String;
    }

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
    try {
      this.server = await HttpServer.bind(
        this.config[keyHost],
        int.parse(this.config[keyPort]),
        v6Only: false,
      );

      stdout.write('Server is started at http://${config[keyHost]}:${config[keyPort]}');

      req.response
        ..headers.contentType = ContentType('application', 'json', charset: 'utf-8');

      var apiPath = req.requestedUri.path;

      if (!this.database.containsKey(apiPath)) {
        req.response.statusCode = HttpStatus.notFound;
        req.response.write(res404);
      } else {
        req.response.write(jsonEncode(this.database[apiPath]));
      }

      await req.response.close();
    } catch (e) {
      stderr.write('Error: ${e}\n');
      exit(2);
    }
  }
}
