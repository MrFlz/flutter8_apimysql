import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_api_mysql/Models/Rol.dart';
import 'package:http/http.dart' as http; //encapsula paquete importado en un objeto para ser fácil su acceso y manipulación
import 'package:barcode_scan/barcode_scan.dart';

class Consulta extends StatefulWidget {
  const Consulta({Key? key}) : super(key: key);  
  @override
  State<Consulta> createState() => _ConsultaState();
}

class _ConsultaState extends State<Consulta>{
  ScanResult ? _scanResult;

  final ButtonStyle _style = ElevatedButton.styleFrom( //estilo del botón (pueden usarlo varios botones y crearse varios styles)
    textStyle: const TextStyle(
      fontSize: 20
    )
  );
  final _tectrl_tf_roleid = TextEditingController(); // Crea un controlador de texto. Lo usaremos para recuperar el valor actual del TField
  
  String geturl="http://192.168.100.43:5000/role/aget/";
  var item;
  var qrcontent=0;
  var result;

  List<Widget> _listRoles(data){
    List<Widget> roles = [];
    for (var rol in data){
      roles.add(
        Card(
          child: Column(
            children: [
              Text(rol.rid.toString()),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(rol.rname),
              )
            ]
          )
        )
      );
    }
    return roles;    
  }

  Future<List<Rol>> _getRoles() async {
    final response = await http.get(Uri.parse(geturl));
    List<Rol> roles = [];

    if(response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      // print(jsonData["data"][0]["id"]); // ejemplo sobre la obtención de un dato a lo largo del json

      //agregar objetos de tipo rol en la lista creada anteriormente
      for ( item in jsonData){   
        if (mounted) { // mounted comprueba si state del objeto (roles) está actualmente en una tree, esto es necesario cuando se llama setState en un método async, aquí se usa para repintar la lista ACTUALIZADA
          setState(() {
            roles.add(
              Rol(item["roleid"], item["rolename"])
            );
          });
        }
      }
      return roles;
    }else{
      throw Exception ("Algo fallo en la conexión (creeeo xd )");
    }  
  }

  Future<List<Rol>> _getRoles_byId() async {
    final response = await http.get(Uri.parse(geturl));
    List<Rol> roles = [];

    if(response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      //filtrar y ****agregar objetos de tipo rol en la lista creada anteriormente
      for ( item in jsonData){
        if(item["roleid"]==qrcontent){
          roles.add(
            Rol(item["roleid"], item["rolename"])
          );
          break;
        }       
      }
      return roles;
    }else{
      throw Exception ("Algo fallo en la conexión (creeeo xd )");
    }  
  }

  Future<void> _ft_qr_scan() async {
    result = await BarcodeScanner.scan();
    setState(() { // validar this lógica?
      if(result.toString().isNotEmpty){
        _scanResult = result; //asiga el resultado directo del escaneo al tipo de resultado que contiene métodos para obtener la data obtenida del 1er resultado 
        qrcontent = int.parse(_scanResult!.rawContent); //el resultado es un string, pero el qrcontent es int  
        print("*********************** RESULTADO: "+qrcontent.toString()+"**********************");
      } else {
        print("*********************** Escaneo Cancelado **********************");
      }
    });
  }

  @override
  void initState() { // función propia de Flutter que se ejecuta al abrirse una ventana, es lo primero que se ejecuta
    super.initState();       
  }

  @override
  void dispose() {        
    super.dispose();
    _tectrl_tf_roleid.dispose(); // Limpia el controlador cuando el Widget se descarte
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'flutter_api_mysql',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Consultar Rol'),
        ),
        body: cuerpo(),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            _ft_qr_scan(); //se ejecuta el metodo future scann
          },
          tooltip: 'Escanear',
          child: const Icon(Icons.qr_code),
        )
      )
    );
  }

  // INIT PERSONAL WIDGETS <==================
  Widget cuerpo(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              _tf_roleid(),
              const SizedBox(height: 10),
              _bt_findbyid()
            ]
          ),
          _ftbdr_lv_roleslist(),
          Text(qrcontent.toString())
          /*_scanResult==null ? const Text('Waiting data...'): 
            Text('Contenido: ${_scanResult!.rawContent}')*/
        ]
      )
    );
  }

  Widget _ftbdr_lv_roleslist(){
    return FutureBuilder (
      future:  _scanResult==null && qrcontent==0 ? _getRoles() : _getRoles_byId(), //si no hay escaneo, muestra todo, si hay, filtra
      builder: (context, snapshot) {
        if (snapshot.hasData){
          return Expanded(
            child: ListView(
              children: _listRoles(snapshot.data)
            )
          );
        }else if(snapshot.hasError){
          print(snapshot.error.toString() + "<=== este es el error cachado" );
          return const Text("errorzaso");
        }
        return const Center(
          child: CircularProgressIndicator()            
        );
      },        
    );
  }
  
  Widget _tf_roleid(){
    return Expanded(  //limita el tamaño de expansión del textfield (oséase: ancho)       
      child: TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: const TextInputType.numberWithOptions(),
        controller: _tectrl_tf_roleid, //asociamos el TextEditingController como propiedad del TextField
        decoration: const InputDecoration( //preferible const por los datos que maneja
          hintText: "Filtrar by id",
          fillColor: Colors.white,
          filled: true
        )
      )
    );
  }

  Widget _bt_findbyid(){
    return ElevatedButton(
      style: _style,
      onPressed: (){        
        //_getRoles(); //validar si algo hace? :/ 
        print(_tectrl_tf_roleid.text); //se recupera el valor del controller asociado al textField y shá uwu
      }, 
      child: const Text("Buscar")          
    );
  } 
  //END PERSONAL WIDGETS <===================
}
