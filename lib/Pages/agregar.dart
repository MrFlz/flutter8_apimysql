import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_api_mysql/Pages/consultar.dart';
import 'package:http/http.dart' as http; //encapsula paquete importado en un objeto para ser fácil su acceso y manipulación

class AgregaInput extends StatelessWidget {
  AgregaInput(/* this.rid, */ {Key? key}) : super(key: key); //inicializamos la variable por recibir en el constructor de la clase

  final ButtonStyle _style = ElevatedButton.styleFrom( //estilo del botón (pueden usarlo varios botones y crearse varios styles)
    textStyle: const TextStyle(
      fontSize: 20
    )
  );
  final _tectrl_tf_rolename = TextEditingController(); // Crea un controlador de texto. Lo usaremos para recuperar el valor actual del TField
  
  String posturl='http://192.168.100.43:5000/role/apost/';
  //final int rid; //agregamos variable a recibir
  
  Future<http.Response> _postRoles(String rolename) { //necesario especificar el tipo de variable aún cuando las comas las separen, si no se especifica, se convertirá en dynamic, causando posibles conflictos
    return http.post(
      Uri.parse(posturl),
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
      title: 'Agregar Page',
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agregando Rol...'),
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
          //Text(rid.toString())
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
              title: const Text("Agregar nombre del rol"),
              content: const Text("¿Desea agregar este rol?"),
              actions: [
                TextButton(
                  onPressed: (){
                    _postRoles(_tectrl_tf_rolename.text); //llamar al future para actualizar mandando lo ingresado en el TextField
                    Navigator.pop( _ ); //cierra el alertDialog
                    Navigator.pop( _ ); //cierra esta clase (ventana input agregar)  
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> Consulta() ),                              
                    );
                  },
                  child: const Text("Agregar")
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