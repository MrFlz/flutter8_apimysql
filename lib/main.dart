import 'package:flutter/material.dart';
import 'package:flutter_api_mysql/Pages/consultar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API dotnet + mysql',
      theme: ThemeData( 
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'api CRUD mysql + navigator'),
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
            eb_consultar()
          ],
        ),
      )
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
}