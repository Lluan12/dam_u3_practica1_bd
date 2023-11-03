import 'package:dam_u3_practica1_bd/Materia.dart';
import 'package:dam_u3_practica1_bd/Tarea.dart';
import 'package:dam_u3_practica1_bd/basedatos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override

  Materia estMateria = Materia(idMateria: "", nombre: "", semestre: "", docente: "");
  Tarea estTarea = Tarea(idTarea: 0, idMateria: "", f_entrega: "", descripcion: "");
  bool mostrar = false;
  bool comprobar = false;
  bool light = false;

  int index = 0;
  // Contoller para Materia
  final idMateria = TextEditingController();
  final nombre = TextEditingController();
  final semestre = TextEditingController();
  final docente = TextEditingController();

  // Variables para Tarea
  String idMateria2 = "";
  String f_entrega = "";
  final descripcion = TextEditingController();
  DateTime selectedDate = DateTime.now();

  List<Materia> m = [];
  List<Tarea> t = [];

  void actulizarMateria() async{
    var temp = await BD.mostrarMaterias();
    setState(() {
      m = temp;
    });
  }
  void actulizarTarea() async{
    var temp = await BD.mostrarTareas();
    setState(() {
      t = temp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    actulizarMateria();
    actulizarTarea();
    f_entrega = DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MIS NOTAS", style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: dinamico(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (valor){
          setState(() {
            index = valor;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Badge(child: Icon(Icons.home), label: Text("${t.length}",), isLabelVisible: index!=0), label: "Lista de Tareas"), // TAREAS
          BottomNavigationBarItem(icon: Badge(child: Icon(Icons.feed_outlined), label: Text("${m.length}"), isLabelVisible: index!=1), label:  "Lista de Materias"), // MATERIAS
          BottomNavigationBarItem(icon: Icon(Icons.add_card), label: "Agregar Materia"), // MATERIAS
        ],
      ),
      floatingActionButton: Visibility(
        visible: mostrar,
          child: FloatingActionButton(
              onPressed: (){
                if(m.length > 0){
                  agregarTarea();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No hay Materias para asignar Tarea"),));
                }
              },
              child: Icon(Icons.add))
      ),
    );
  }

  Widget dinamico(){
    index==0 ? mostrar=true: mostrar=false;
    switch (index){
      case 0: {
        return mostrarTareas();
      } // Fin caso 0
      case 1: {
        return mostrarMaterias();
      } // Fin caso 1
      case 2: {
        return agregarMateria();
      } // Fin caso 2
    }
    return Center();
  }

  void agregarTarea(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder){
          return StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: 15, left: 30, right: 30,
                      bottom: MediaQuery.of(context).viewInsets.bottom+50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10,),
                      Text(
                        "TAREAS",
                        style: TextStyle(
                          fontSize: 36, // Tamaño del texto
                          fontWeight: FontWeight.w900, // Peso de la fuente (negrita)
                          color: Colors.black, // Color del texto
                          letterSpacing: 10, // Espaciado entre caracteres
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextField(
                        controller: descripcion,
                        decoration: InputDecoration(
                          label: Text("Descripcion", style: TextStyle(
                            letterSpacing: 15,
                            fontWeight: FontWeight.bold,
                          ),),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Divider(),
                      idMateria2=="" ? Text("Seleccione la Materia", style: TextStyle(fontSize: 20),) : Text(idMateria2, style: TextStyle(fontSize: 20),),
                      PopupMenuButton<String>(
                        onSelected: (String item){setState((){idMateria2 = item;});},
                        icon: Icon(Icons.manage_search),
                        itemBuilder: (BuildContext context){
                          return m.map((Materia item) {
                            return PopupMenuItem<String>(value: item.idMateria, child: Text(item.idMateria));
                          }).toList();
                        },
                      ),
                      SizedBox(height: 10,),
                      Divider(),
                      Text(f_entrega, style: TextStyle(fontSize: 20,),),
                      SizedBox(height: 10,),
                      OutlinedButton(
                        onPressed: () {
                          // INSTALAR PAQUETE PARA MANEJAR FECHAS
                          // flutter pub add intl
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), // Fecha inicial
                            firstDate: DateTime(2023), // Fecha mínima seleccionable
                            lastDate: DateTime(2024), // Fecha máxima seleccionable
                          ).then((pickedDate) {
                            if (pickedDate != null && pickedDate != selectedDate) {
                              selectedDate = pickedDate;
                              setState((){
                                f_entrega = DateFormat('yyyy-MM-dd').format(selectedDate);
                              });
                            }
                          });
                        },
                        child: Text('Seleccione la fecha', style: TextStyle(fontSize: 20)),
                      ),

                      SizedBox(height: 20,),
                      Divider(),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: (){
                                idMateria2 = "";
                                selectedDate = DateTime.now();
                                descripcion.text = "";
                                f_entrega = DateFormat('yyyy-MM-dd').format(selectedDate);
                                Navigator.pop(context);
                              },
                              child: Text("Cancelar")
                          ),
                          ElevatedButton(
                              onPressed: (){
                                var tarea = Tarea(
                                    idTarea: 1,
                                    idMateria: idMateria2,
                                    f_entrega: f_entrega,
                                    descripcion: descripcion.text
                                );
                                BD.insertarTarea(tarea).then((value) {
                                  idMateria2 = "";
                                  selectedDate = DateTime.now();
                                  f_entrega = DateFormat('yyyy-MM-dd').format(selectedDate);
                                  descripcion.text = "";
                                  actulizarTarea();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Tarea agregada")));
                                });
                              },
                              child: Text("Agregar")
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          );
        });
  }

  void updateTarea(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder){
          return (Container(
            padding: EdgeInsets.only(
                top: 15, left: 30, right: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom+50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20,),
                TextField(
                  controller: descripcion,
                  decoration: InputDecoration(
                    label: Text("Descripcion", style: TextStyle(
                      letterSpacing: 15,
                      fontWeight: FontWeight.bold,
                    ),),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20,),
                Divider(),
                Text(idMateria2, style: TextStyle(fontSize: 20),),
                PopupMenuButton<String>(
                  onSelected: (String item){setState((){idMateria2 = item;});},
                  icon: Icon(Icons.manage_search),
                  itemBuilder: (BuildContext context){
                    return m.map((Materia item) {
                      return PopupMenuItem<String>(value: item.idMateria, child: Text(item.idMateria));
                    }).toList();
                  },
                ),
                SizedBox(height: 10,),
                Divider(),
                Text(f_entrega, style: TextStyle(fontSize: 20,),),
                SizedBox(height: 10,),
                OutlinedButton(
                  onPressed: () {
                    // INSTALAR PAQUETE PARA MANEJAR FECHAS
                    // flutter pub add intl
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), // Fecha inicial
                      firstDate: DateTime(2023), // Fecha mínima seleccionable
                      lastDate: DateTime(2024), // Fecha máxima seleccionable
                    ).then((pickedDate) {
                      if (pickedDate != null && pickedDate != selectedDate) {
                        selectedDate = pickedDate;
                        setState((){
                          f_entrega = DateFormat('yyyy-MM-dd').format(selectedDate);
                        });
                      }
                    });
                  },
                  child: Text('Seleccione la fecha', style: TextStyle(fontSize: 20)),
                ),

                SizedBox(height: 20,),
                Divider(),

                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        idMateria2 = "";
                        selectedDate = DateTime.now();
                        descripcion.text = "";
                        f_entrega = DateFormat('yyyy-MM-dd').format(selectedDate);
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar",
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,),)
                    ),
                    ElevatedButton(
                      onPressed: (){
                        estTarea.idMateria = idMateria2;
                        estTarea.f_entrega = f_entrega;
                        estTarea.descripcion = descripcion.text;

                        BD.actualizarTarea(estTarea).then((value) {
                          idMateria2 = "";
                          selectedDate = DateTime.now();
                          f_entrega = DateFormat('yyyy-MM-dd').format(selectedDate);
                          descripcion.text = "";
                          actulizarTarea();
                          estTarea = Tarea(idTarea: 0, idMateria: "", f_entrega: "", descripcion: "");
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Tarea actualizada")));
                        });
                      },
                      child: Text("Actualizar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,),),
                    ),
                  ],
                ),
              ],
            ),
          ));
        });
  }

  void updateMateria(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 5,
        builder: (builder){
          return (Container(
            padding: EdgeInsets.only(
                top: 15, left: 30, right: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom+50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idMateria,
                  enabled: false,
                  decoration: InputDecoration(
                    label: Text("ID",
                      style: TextStyle(
                        letterSpacing: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    suffixIcon: Icon(Icons.verified),
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 15,),
                TextField(
                  controller: nombre,
                  decoration: InputDecoration(
                    label: Text("Materia",
                      style: TextStyle(
                        letterSpacing: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    suffixIcon: Icon(Icons.school),
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 15,),
                TextField(controller: semestre,
                  decoration: InputDecoration(
                    label: Text("Semestre",
                      style: TextStyle(
                        letterSpacing: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    suffixIcon: Icon(Icons.numbers),
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 15,),
                TextField(controller: docente,
                  decoration: InputDecoration(
                    label: Text("Docente",
                      style: TextStyle(
                        letterSpacing: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    suffixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          idMateria.text = "";
                          nombre.text = "";
                          semestre.text = "";
                          docente.text = "";
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar",
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,),)
                    ),
                    ElevatedButton(
                      onPressed: (){
                        var materia = Materia(
                            idMateria: idMateria.text,
                            nombre: nombre.text,
                            semestre: semestre.text,
                            docente: docente.text
                        );
                        BD.actualizarMateria(materia).then((value) {
                          idMateria.text = "";
                          nombre.text = "";
                          semestre.text = "";
                          docente.text = "";
                          actulizarMateria();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Materia actualizada")));
                        });
                      },
                      child: Text("Actualizar",
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,),),
                    ),
                  ],
                ),
              ],
            ),
          ));
        });
  }

  Widget mostrarTareas(){
    return ListView.builder(
        itemCount: t.length,
        itemBuilder: (context, indice){
          return ListTile(
            title: Text(t[indice].descripcion),
            subtitle: Text(t[indice].f_entrega),
            leading: CircleAvatar(child: Text(t[indice].idMateria), radius: 20,),
            trailing: IconButton(
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (builder){
                      return AlertDialog(
                        title: Text("Eliminar Tarea"),
                        content: Text("¿Estas seguro de eliminar esta Tarea?"),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("Cancelar")),
                              TextButton(
                                  onPressed: (){
                                    BD.borrarTarea(t[indice].idTarea).then((value) {
                                      actulizarTarea();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Tarea Eliminada")));
                                    });
                                  },
                                  child: Text("Aceptar")
                              )
                            ],
                          )

                        ],
                      );
                    }
                );
              },
              icon: Icon(Icons.delete),
            ),
            onTap: (){
              descripcion.text = t[indice].descripcion;
              idMateria2 = t[indice].idMateria;
              f_entrega = t[indice].f_entrega;
              estTarea = t[indice];
              updateTarea();
            },
          );
        }
    );
  }

  Widget agregarMateria(){
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 50, right: 50, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Alinea hijos verticalmente al centro
            children: [
              SizedBox(height: 20,),
              Text(
                "MATERIAS",
                style: TextStyle(
                  fontSize: 36, // Tamaño del texto
                  fontWeight: FontWeight.w900, // Peso de la fuente (negrita)
                  color: Colors.black, // Color del texto
                  letterSpacing: 10, // Espaciado entre caracteres
                ),
              ),

              SizedBox(height: 40,),
              TextField(
                controller: idMateria,
                decoration: InputDecoration(
                  label: Text("ID",
                    style: TextStyle(
                      letterSpacing: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  suffixIcon: Icon(Icons.verified),
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 40,),
              TextField(
                controller: nombre,
                decoration: InputDecoration(
                  label: Text("Materia",
                    style: TextStyle(
                      letterSpacing: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  suffixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),

              ),

              SizedBox(height: 40,),
              TextField(
                controller: semestre,
                decoration: InputDecoration(
                  label: Text("Semestre",
                    style: TextStyle(
                      letterSpacing: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  suffixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 40,),
              TextField(
                controller: docente,
                decoration: InputDecoration(
                  label: Text("Docente",
                    style: TextStyle(
                      letterSpacing: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  suffixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 40,),
              FilledButton(onPressed: (){
                var materia = Materia(
                    idMateria: idMateria.text,
                    nombre: nombre.text,
                    semestre: semestre.text,
                    docente: docente.text
                );
                BD.insertarMateria(materia).then((value) {
                  idMateria.text = "";
                  nombre.text = "";
                  semestre.text = "";
                  docente.text = "";
                  actulizarMateria();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Materia agregada")));
                });
              },
                child: Text("Agregar Materia",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mostrarMaterias(){
    return ListView.builder(
        itemCount: m.length,
        itemBuilder: (context, indice){
          return ListTile(
            title: Text(m[indice].nombre),
            subtitle: Text(m[indice].docente),
            leading: CircleAvatar(child: Text(m[indice].idMateria), radius: 20,),
            trailing: IconButton(
              onPressed: (){
                t.forEach((tarea) {
                  if(tarea.idMateria == m[indice].idMateria){
                    comprobar = true;
                    return;
                  } else{
                    comprobar = false;
                  }
                });
                if(comprobar){
                  showDialog(
                      context: context,
                      builder: (builder){
                        return AlertDialog(
                          title: const Text("Sin Eliminar"),
                          content: const Text("Primero elimine las Tareas asociadas a esta Materia"),
                          actions: [
                            TextButton(onPressed: (){comprobar=true; Navigator.pop(context);}, child: const Text("Aceptar"))
                          ],
                        );
                      }
                  );
                } else {
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return AlertDialog(
                          title: const Text("Eliminar Materia"),
                          content: const Text(
                              "¿Estas seguro de eliminar esta Materia?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancelar")
                                ),
                                TextButton(
                                    onPressed: () {
                                      BD.borrarMateria(m[indice].idMateria).then((value) {
                                        actulizarMateria();
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Materia eliminada")));

                                      });
                                    },
                                    child: const Text("Aceptar")
                                ),
                              ],
                            )
                          ],
                        );
                      }
                  );
                }
              },
              icon: Icon(Icons.delete),
            ),
            onTap: (){
              idMateria.text = m[indice].idMateria;
              nombre.text = m[indice].nombre;
              semestre.text = m[indice].semestre;
              docente.text = m[indice].docente;
              updateMateria();
            },
          );
        }
    );
  }

}