import 'package:isar/isar.dart';
part 'note.g.dart'; // run : dart run build_runner build

@Collection()
class Note {
  Id id = Isar.autoIncrement; //increase as we create new note
  late String text;
}
