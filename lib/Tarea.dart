class Tarea{
  int idTarea;
  String idMateria;
  String f_entrega;
  String descripcion;

  Tarea({
    required this.idTarea,
    required this.idMateria,
    required this.f_entrega,
    required this.descripcion
  });

  Map<String, dynamic> toJSON(){
    return {
      "idTarea" : idTarea,
      "idMateria" : idMateria,
      "f_entrega" : f_entrega,
      "descripcion" : descripcion,
    };
  }
}