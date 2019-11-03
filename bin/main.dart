import 'dart:io';

import 'package:json_server/src/json_server.dart';
import 'package:args/args.dart';

main(List<String> arguments) async {

  ArgResults argResults;
  final parser = ArgParser()
    ..addOption('data', abbr: 'd');
  argResults = parser.parse(arguments);

  if (argResults['data'] == null) {
    stderr.write('Error: option --data is required');
    exit(1);
  }

  Map<String, String> config = new Map();
  config['data'] = argResults['data'];
  JsonServer server = JsonServer(config: config);
  await server.init();
  await server.start();
}
