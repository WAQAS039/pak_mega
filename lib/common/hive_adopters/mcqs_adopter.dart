import 'package:hive/hive.dart';
import 'package:pak_mega_mcqs/common/model/mcqs_db_model.dart';

class MCQsAdopter extends TypeAdapter<MCQsDbModel>{

  @override
  int get typeId => 1;

  @override
  MCQsDbModel read(BinaryReader reader) {
    final name = reader.read();
    final categoriesList = reader.read();
    return MCQsDbModel(name: name, categories: categoriesList);
  }


  @override
  void write(BinaryWriter writer, MCQsDbModel obj) {
    writer.write(obj.name);
    writer.write(obj.categoriesList);
  }

}