
import 'package:dam_u3_practica1_bd/Materia.dart';
import 'package:dam_u3_practica1_bd/Tarea.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BD{
  static Future<Database> _abrirDB() async{
    return openDatabase(
      join(await getDatabasesPath(), "practica1.db"),
      onCreate: (db, version) {
        db.execute("CREATE TABLE MATERIA(IDMATERIA TEXT PRIMARY KEY, NOMBRE TEXT, SEMESTRE TEXT, DOCENTE TEXT)");
        db.execute("CREATE TABLE TAREA(IDTAREA INTEGER PRIMARY KEY AUTOINCREMENT, IDMATERIA TEXT, F_ENTREGA TEXT, DESCRIPCION TEXT, CONSTRAINT FK_TAREA_MATERIA FOREIGN KEY(IDMATERIA) REFERENCES MATERIA(IDMATERIA))");
      }, version: 1
    );
  }

  static Future<int> insertarMateria(Materia m) async{
    Database db = await _abrirDB();
    return db.insert("MATERIA", m.toJSON(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> insertarTarea(Tarea t) async{
    Database db = await _abrirDB();
    return db.insert("TAREA", t.toJSON(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Materia>> mostrarMaterias() async{
    Database db = await _abrirDB();
    List<Map<String, dynamic>> resultado = await db.query("MATERIA");
    return List.generate(resultado.length, (index) {
      return Materia(
          idMateria: resultado[index]["IDMATERIA"],
          nombre: resultado[index]["NOMBRE"],
          semestre: resultado[index]["SEMESTRE"],
          docente: resultado[index]["DOCENTE"]
      );
    });
  }

  static Future<List<Tarea>> mostrarTareas() async{
    Database db = await _abrirDB();
    List<Map<String, dynamic>> resultado = await db.query("TAREA");
    return List.generate(resultado.length, (index) {
      return Tarea(
          idTarea: resultado[index]["IDTAREA"],
          idMateria: resultado[index]["IDMATERIA"],
          f_entrega: resultado[index]["F_ENTREGA"],
          descripcion: resultado[index]["DESCRIPCION"]
      );
    });
  }

  static Future<int> actualizarMateria(Materia m) async{
    Database db = await _abrirDB();
    return db.update("MATERIA", m.toJSON(), where: "IDMATERIA=?", whereArgs: [m.idMateria]);
  }

  static Future<int> actualizarTarea(Tarea t) async{
    Database db = await _abrirDB();
    return db.update("TAREA", t.toJSON(), where: "IDTAREA=?", whereArgs: [t.idTarea]);
  }

  static Future<int> borrarMateria(String idMateria) async{
    Database db = await _abrirDB();
    return db.delete("MATERIA", where: "IDMATERIA=?", whereArgs: [idMateria]);
  }

  static Future<int> borrarTarea(int idTarea) async{
    Database db = await _abrirDB();
    return db.delete("TAREA", where: "IDTAREA=?", whereArgs: [idTarea]);
  }

}