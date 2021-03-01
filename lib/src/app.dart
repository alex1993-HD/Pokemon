import 'package:flutter/material.dart';
import 'package:practicaresponse/screens/my_home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lista de Pokemones",
      home: MyHomePage(),
    );
  }
}
