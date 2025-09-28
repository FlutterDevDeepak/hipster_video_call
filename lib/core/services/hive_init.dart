
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

const String kUsersBox = 'users_box';

Future<void> initHiveAndOpenBoxes() async {
  final supportDir = await getApplicationDocumentsDirectory();
  Hive.init(supportDir.path); 
  await Hive.openBox<Map>(kUsersBox); 
}
