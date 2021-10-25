import 'package:flutter/material.dart';
import 'package:flutter_api_mysql/Pages/agregar.dart';
import 'package:flutter_api_mysql/Pages/consultar.dart';
import 'package:flutter_api_mysql/Pages/editar.dart';
import 'package:flutter_api_mysql/Pages/eliminar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Test by MrFlz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '.NET API CRUD + mysql + navigator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("¿Qué desea hacer?"),
            const SizedBox(
              height: 15.0,
              width: 15.0,
            ),
            eb_consultar(),
            eb_agregar(),
            eb_editar(),
            eb_eliminar()
          ],
        ),
      )
    );
  }

  Widget eb_agregar(){
    return ElevatedButton(
      child: const Text("Agregar"),
      style: ElevatedButton.styleFrom( //asignarle color de back y fore ground al elevated button
        primary: Colors.green //background
        //onPrimary: Colors.green //foreground, default: blanco 
      ),
      onPressed: ()=>{                
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=> AgregaInput() ),                                     
        )
      }
    );
  }

  Widget eb_consultar(){
    return ElevatedButton(
      child: const Text("Consultar"),
      onPressed: ()=>{                
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=> Consulta() ),                                     
        )
      }
    );
  }

  Widget eb_editar(){
    return ElevatedButton(
      child: const Text("Editar"),
      style: ElevatedButton.styleFrom( //asignarle color de back y fore ground al elevated button
        primary: Colors.orange //background
        //onPrimary: Colors.green //foreground, default: blanco 
      ),
      onPressed: ()=>{                
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=> Edita() ),                                     
        )
      }
    );
  }

  Widget eb_eliminar(){
    return ElevatedButton(
      child: const Text("Eliminar"),
      style: ElevatedButton.styleFrom( //asignarle color de back y fore ground al elevated button
        primary: Colors.red, //background
        //onPrimary: Colors.green //foreground, default: blanco 
      ),
      onPressed: ()=>{                
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=> Elimina() ),                                     
        )
      }
    );
  }
}