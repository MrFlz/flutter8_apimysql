import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_api_mysql/Pages/editar.dart';
import 'package:http/http.dart' as http;

class EditaInput extends StatelessWidget {
  EditaInput(this.rid, {Key? key}) : super(key: key); //inicializamos la variable por recibir en el constructor de la clase

  final ButtonStyle _style = ElevatedButton.styleFrom( //estilo del botón (pueden usarlo varios botones y crearse varios styles)
    textStyle: const TextStyle(
      fontSize: 20
    )
  );
  final _tectrl_tf_rolename = TextEditingController(); // Crea un controlador de texto. Lo usaremos para recuperar el valor actual del TField
  
  String puturl='http://192.168.100.43:5000/role/aput/';
  String strid=""; //inicializamos una string para posteriormente enlazarla a la url
  final int rid; //agregamos variable a recibir  
  //String rolename=""; // dato a actualizar

  Future<http.Response> _putRoles(String rolename) {
    strid = rid.toString(); //se convierte el id del rol en string para poder enlazarce al url

    return http.put(
      Uri.parse(puturl+strid),
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
      title: 'Editar Rol',
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
      onPressed: (){ // el => es necesario para usar el context en Navigator
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
                    _putRoles(_tectrl_tf_rolename.text); //llamar al future para actualizar mandando lo ingresado en el TextField
                    Navigator.pop( _ ); //cierra el alertDialog
                    Navigator.pop( _ ); //cierra ventana input editar
                    /* Navigator.push( //abre ventana editar //ya no es necesario, porque ya se repinta en automatico, solo basta cerrarlo para regresar a la anterior (ya actualizada)
                      context,
                      MaterialPageRoute(
                        builder: ( _ )=> Edita()
                      )
                    ); */
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


