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

  int _index = 0;
  final idMateria = TextEditingController();
  final nombre = TextEditingController();
  final semestre = TextEditingController();
  final docente = TextEditingController();

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
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BD"),
      ),
      body: dinamico(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.ad_units), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: ""),
        ],
        currentIndex: _index,
        onTap: (valor){
          setState(() {
            _index = valor;
          });
        },
      ),
    );
  }
  Widget dinamico(){
    switch(_index){
      case 5: {
        return ListView.builder(
            itemCount: m.length,
            itemBuilder: (context, indice){
              return ListTile(
                title: Text("${m[indice].nombre}"),
                subtitle: Text("${m[indice].docente}"),
                leading: CircleAvatar(child: Text("${m[indice].semestre}"), radius: 15,),
                trailing: IconButton(
                  onPressed: (){
                    BD.borrarMateria(m[indice].idMateria).then((value) {
                      actulizarMateria();
                    });
                  },
                  icon: Icon(Icons.delete),
                ),
                //onTap: (){
                //  estMateria = m[indice];
                //  setState(() {
                //    _index = 2;
                //  });
                //},
              );
            });
      }
      case 1: {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: idMateria,
                decoration: InputDecoration(
                  labelText: "ID MATERIA: "
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: nombre,
                decoration: InputDecoration(
                    labelText: "NOMBRE: "
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: semestre,
                decoration: InputDecoration(
                    labelText: "SEMESTRE: "
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: docente,
                decoration: InputDecoration(
                    labelText: "DOCENTE: "
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: (){
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
                    });
                  },
                  child: const Text("AGREGAR MATERIA")
              )
            ],
          ),
        );
      }
      case 2:{
        return Center(
          child: Column(
            children: [
              Text("Seleccionar Materia"),
              SizedBox(height: 10,),
              PopupMenuButton<String>(onSelected: (String item){idMateria2 = item;}, itemBuilder: (BuildContext context){
                return m.map((Materia item) {
                  return PopupMenuItem<String>(value: item.idMateria, child: Text(item.idMateria));
                }).toList();
              }, ),
              SizedBox(height: 10,),
              TextButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), // Fecha inicial
                    firstDate: DateTime(2023), // Fecha mínima seleccionable
                    lastDate: DateTime(2024), // Fecha máxima seleccionable
                  ).then((pickedDate) {
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                      setState(() {
                        f_entrega = DateFormat('yyyy-MM-dd').format(selectedDate);
                      });
                    }
                  });
                },
                child: Text('Seleccionar Fecha'),
              ),
              SizedBox(height: 10,),
              Text(f_entrega),
              SizedBox(height: 10,),
              TextField(
                controller: descripcion,
                decoration: InputDecoration(
                    labelText: "DESCRIPCION:"
                ),
              ),
              SizedBox(height: 10,),
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
                      f_entrega = "";
                      descripcion.text = "";
                      actulizarTarea();
                    });
                  },
                  child: const Text("AGREGAR TAREA")
              )
            ],
          ),
        );
      }
      case 0: {
        return ListView.builder(
            itemCount: t.length,
            itemBuilder: (context, indice){
              return ListTile(
                title: Text("${t[indice].descripcion}"),
                subtitle: Text("${t[indice].f_entrega}"),
                leading: CircleAvatar(child: Text("${t[indice].idMateria}"), radius: 15,),
                trailing: IconButton(
                  onPressed: (){
                    BD.borrarTarea(t[indice].idTarea).then((value) {
                      actulizarTarea();
                    });
                  },
                  icon: Icon(Icons.delete),
                ),
                //onTap: (){
                //  estMateria = m[indice];
                //  setState(() {
                //    _index = 2;
                //  });
                //},
              );
            });
      }
      default: {
        return Center();
      }
    }
  }
}
