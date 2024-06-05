import 'package:logging/logging.dart';

final Logger logger = Logger('AppLogger');

void setupLogger() {
  Logger.root.level = Level.ALL; // Change this to set the default level of logging
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
