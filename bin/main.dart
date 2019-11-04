import 'package:json_server/src/json_server.dart';
import 'dart:io';
import 'package:args/args.dart';

main(List<String> arguments) async {
  exitCode = 0;

  ArgResults results = parseArgs(arguments);

  Map<String, String> config = Map();
  config['data'] = results['data'];
  config['host'] = results['host'];
  config['port'] = results['port'];

  validateInput(config);

  try {
    JsonServer server = JsonServer(config: config);
    await server.init();
    await server.start();
  } catch (e) {
    stderr.write('Error: ${e}\n');
    exit(1);
  }
}

ArgResults parseArgs(List<String> args) {
  final parser = ArgParser()
                  ..addOption('data', abbr: 'd')
                  ..addOption('host', abbr: 'h', defaultsTo: '127.0.0.1')
                  ..addOption('port', abbr: 'p', defaultsTo: '1711');

  ArgResults argResults = parser.parse(args);
  // validate required arguments
  if (argResults['data'] == null) {
    stderr.write('Error: option --data is missing.\n');
    printHelp();
    exit(1);
  }

  return argResults;
}

validateInput(Map<String, String> input) {
  File path = File(input['data']);
  if (!path.existsSync()) {
    stderr.write('Error: file does not exist, ${input['data']}\n');
    exit(1);
  }
}

printHelp() {
  var help = '''
Launch a JSON API server from a source.
 
Usage: jserver --data <json_file>
-h, --help            Print this usage information.
-d, --data            Path to JSON file. Required.
-h, --host            Server address. Default: 127.0.0.1
-p, --port            Specify port to use. Default: 1711

Example:
  \$ jserver --data ~/server/api.json
  \$ jserver -d ~/api.json -h 127.0.0.1 -p 9999
''';
  stdout.write(help);
}