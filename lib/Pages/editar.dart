import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_api_mysql/Models/Rol.dart';
import 'package:http/http.dart' as http; //encapsula paquete importado en un objeto para ser fácil su acceso y manipulación

import 'package:barcode_scan/barcode_scan.dart';

class Edita extends StatefulWidget {
  Edita({Key? key}) : super(key: key);  
  @override
  State<Edita> createState() => _EditaState();  
}

class _EditaState extends State<Edita>{
  ScanResult ? _scanResult;
  final ButtonStyle _style = ElevatedButton.styleFrom( //estilo del botón (pueden usarlo varios botones y crearse varios styles)
    textStyle: const TextStyle(
      fontSize: 20
    )
  );
  final _tectrl_tf_roleid = TextEditingController(); // Crea un controlador de texto. Lo usaremos para recuperar el valor actual del TField
  
  String geturl="http://192.168.100.43:5000/role/aget/";  
  //var item;
  var qrcontent=0; 
  var result;
  int rid=0; //parámetro para enviar al input de enviar

  List<Widget> _listRoles(data){
    List<Widget> roles = [];
    for (var rol in data){
      roles.add(
        Card(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              title: Text(rol.rid.toString()),
              subtitle: Text(rol.rname),
              leading: CircleAvatar(
                child: Text(rol.rname.substring(0,2))
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onLongPress: () {
                rid = int.parse(rol.rid.toString()); //se asigna el id del rol para enviarla a otra clase
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> EditaInput(rid)), //se pasa el parámetro deseado, este mismo debe existir en la clase a enviar                                     
                );
              }
            ),
          ),
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
      //agregar objetos de tipo rol en la lista creada anteriormente
      for (var item in jsonData){
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
      for (var item in jsonData){
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
    setState(() {
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
      theme: ThemeData(
        primarySwatch: Colors.orange
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Rol'),  
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
      future:  _scanResult==null ? _getRoles() : _getRoles_byId(), //si no hay escaneo, muestra todo, si hay, filtra
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
        //rid = int.parse(_tectrl_tf_roleid.text); //todavía nel
      }, 
      child: const Text("Buscar")          
    );
  }  
  //END PERSONAL WIDGETS <===================

  // INIT FUNCIONES / METODOS <==================  
  // INIT FUNCIONES / METODOS <==================
}

class EditaInput extends StatelessWidget {
  EditaInput(this.rid, {Key? key}) : super(key: key); //inicializamos la variable por recibir en el constructor de la clase

  final ButtonStyle _style = ElevatedButton.styleFrom( //estilo del botón (pueden usarlo varios botones y crearse varios styles)
    textStyle: const TextStyle(
      fontSize: 20
    )
  );
  final _tectrl_tf_rolename = TextEditingController(); // Crea un controlador de texto. Lo usaremos para recuperar el valor actual del TField
  
  String puturl='http://192.168.100.43:5000/role/aput/';
  final int rid; //agregamos variable a recibir
  
  Future<http.Response> _putRoles(String rolename, String id) { //necesario especificar el tipo de variable aún cuando las comas las separen, si no se especifica, se convertirá en dynamic, causando posibles conflictos
    return http.put(
      Uri.parse(puturl+id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'rolename': rolename,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Editar Page',
      theme: ThemeData(
        primarySwatch: Colors.orange
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Editando Rol...'),
        ),
        body: cuerpo(context)
      ),
    );
  }

  Widget cuerpo(BuildContext context){
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _tf_rolename(),
          const SizedBox(height: 10),
          _bt_update(context),
          Text(rid.toString())
        ]
      )
    );
  }

  Widget _tf_rolename(){
    String charPattern=r'(^[a-zA-Z]*$)'; //expresion regular para una CADENA de caracteres, sin admitir espacios

    return Expanded(  //limita el tamaño de expansión del textfield (oséase: ancho)
      child: TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(charPattern)), //solo permite el contenido de una expresion regular
          LengthLimitingTextInputFormatter(15) //limita el tamaño de la cadena
        ],
        //keyboardType: const TextInputType.numberWithOptions(), //cambia el tipo de teclado, no necesario para caracteres
        controller: _tectrl_tf_rolename, //asociamos el TextEditingController como propiedad del TextField
        decoration: const InputDecoration( //preferible const por los datos que maneja
          hintText: "Input new Rolename...",
          fillColor: Colors.white,
          filled: true
        )
      )
    );
  }

  Widget _bt_update(BuildContext context){
    return ElevatedButton(
      style: _style,
      onPressed: (){ // investigar sobre el ()=>{} es necesario? 
        if(_tectrl_tf_rolename.text.isEmpty || _tectrl_tf_rolename.text.length < 4){
          showDialog( //alerta del rolename no aceptado por null, espacios o falta caracteres mínimos 4
            context: context,          
            builder: ( _ ) => AlertDialog(
              title: const Text("Rolename no aceptado :("),
              content: const Text("¡Ingrese al menos 4 caracteres sin espacios!"),
              actions: [
                TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Aceptar",
                  style: TextStyle(
                    color: Colors.blue
                  )
                )
              )
              ]
            )          
          );
        } else if(_tectrl_tf_rolename.text.length >= 4){
          showDialog( //alerta sobre gaurdar los datos antes de Actualizar
            context: context, 
            builder: ( _ ) => AlertDialog(
              title: const Text("Actualizar nombre del rol"),
              content: const Text("¿Estas seguro de guardar estos datos?"),
              actions: [              
                TextButton(
                  onPressed: (){                                
                    _putRoles(_tectrl_tf_rolename.text,rid.toString()); //llamar al future para actualizar mandando lo ingresado en el TextField
                    Navigator.pop( _ ); //cierra el alertDialog
                    Navigator.pop( _ ); //cierra esta clase (ventana input editar)                    
                  },
                  child: const Text("Guardar")
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar",
                    style: TextStyle(
                      color: Colors.red
                    )
                  )
                )
              ]
            ) 
          );
        } else {
          print("algún error en los AlertDialog :c");
        }        
        /* _putRoles(_tectrl_tf_rolename.text); //llamar al future para actualizar mandando lo ingresado en el TextField           
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=> Edita() )                                
        ); */
      }, 
      child: const Text("Actualizar")          
    );
  } 
}