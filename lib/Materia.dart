class Materia{
  String idMateria;
  String nombre;
  String semestre;
  String docente;

  Materia({
    required this.idMateria,
    required this.nombre,
    required this.semestre,
    required this.docente,
  });

  Map<String, dynamic> toJSON(){
    return {
      "idMateria" : idMateria,
      "nombre" : nombre,
      "semestre" : semestre,
      "docente" : docente,
    };
  }
}