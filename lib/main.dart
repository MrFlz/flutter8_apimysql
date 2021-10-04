import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_api_mysql/Models/Rol.dart';
import 'package:http/http.dart' as http; //encapsula paquete importado en un objeto para ser fácil su acceso y manipulación

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late Future<List<Rol>> _futlistRoles;

  String apiurl="http://192.168.100.43:5000/role/aget/";
  var item;

  Future<List<Rol>> _getRoles() async {
    final response = await http.get(Uri.parse(apiurl));
  
    List<Rol> roles = [];

    if(response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      // print(jsonData["data"][0]["id"]); // ejemplo sobre la obtención de un dato a lo largo del json

      //agregar objetos de tipo rol en la lista creada anteriormente
      for ( item in jsonData){
        roles.add(
          Rol(item["roleid"], item["rolename"])
        );
      }
      return roles;

    }else{
      throw Exception ("Algo fallo en la conexión (creeeo xd )");
    }  
  }

  @override
  void initState() { // función propia de Flutter que se ejecuta al abrirse una ventana, es lo primero que se ejecuta
    super.initState();   
    _futlistRoles = _getRoles() ;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_api_mysql',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('API dotnet + mysql'),
        ),
        body: FutureBuilder (
          future: _futlistRoles,
          builder: (context, snapshot) {
            if (snapshot.hasData){
              print(snapshot.data);
              return ListView(
                children: _listRoles(snapshot.data)
              );

            }else if(snapshot.hasError){
              print(snapshot.error.toString() + "<=== este es el error cachado" );
              return const Text("errorzaso");

            }
            return const Center(
              child: CircularProgressIndicator()                
            );
          },        
        )
        
        /*Center(
          // ignore: deprecated_member_use
          child: RaisedButton(
            child: const Text("Get API"),
              onPressed: ()=>{ //para que funcione, el Center no debe ser CONST
                // ignore: avoid_print
                print("Presionaste get api"),
                _listadoGifs = _getGifs(),
                _listGifs( item["images"]["downsized"]["url"])
              }
          )
        )*/
      )
    );
  }

  List<Widget> _listRoles(data){
    List<Widget> roles = [];

    for (var rol in data){
      roles.add(
        Card(
          child: Column(
            children: [
              Text(rol.rid.toString()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(rol.rname),
              )
            ]
          )
        )
      );
    }

    return roles;    
  }
  
  // PARA UNA MEJOR VISUALIZACION o algo así jejep... (NOTA: código incompleto)
  /*List<Widget> _listGifs(List<Gif> data){
    List<Widget> gifs = [];

    for (var gif in data){
      gifs.add(
        Card(
          child: Column(
            children: [
              Expanded(child: Image.network(gif.url, fit: BoxFit.fill))
            ]
          )
        )
      );
    }

    return gifs;    
  }*/

}
