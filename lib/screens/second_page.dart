import 'package:flutter/material.dart';
import 'package:practicaresponse/main.dart';
import 'package:practicaresponse/models/abilities.dart';
import 'package:practicaresponse/models/pokemon.dart';
import 'package:practicaresponse/models/stats.dart';
import 'package:practicaresponse/models/types.dart';

import 'package:practicaresponse/repo/pokemon_repo.dart';
import 'package:practicaresponse/utils/functions.dart';

class SecondPage extends StatefulWidget {
  //const SecondPage({Key key}) : super(key: key);

  Pokemon pokemon;
  SecondPage({@required this.pokemon});

  @override
  _SecondPageState createState() => _SecondPageState(pokemon: this.pokemon);
}

class _SecondPageState extends State<SecondPage> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Pokemon pokemon;
  _SecondPageState({this.pokemon});

  Widget abilitiesBuild(abilities) {
    List<Widget> ListAbility = [];
    for (String ability in abilities) {
      ListAbility.add(Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white38,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(ability),
      ));
      ListAbility.add(Padding(
        padding: EdgeInsets.only(right: 10),
      ));
    }
    return Container(
      child: Row(
          children: ListAbility, mainAxisAlignment: MainAxisAlignment.center),
    );
  }

  Widget typesBuild(types) {
    List<Widget> ListTypes = [];
    for (String type in types) {
      ListTypes.add(Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: darkenColor(typeColor[type]),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(type, style: TextStyle(color: textColor[pokemon.type])),
      ));
      ListTypes.add(Padding(
        padding: EdgeInsets.only(right: 10),
      ));
    }
    return Container(
      child: Row(
        children: ListTypes,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Card(
            color: typeColor[pokemon.type],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: ListView(
                children: [
                  Column(children: [
                    Image.network(pokemon.photo, width: 300, height: 300),
                    Text("${capitalize(pokemon.name)}",
                        style: TextStyle(
                            color: textColor[pokemon.type], fontSize: 30)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 1, 0, 10),
                      child: Text('Generación ${pokemon.generation}',
                          style: TextStyle(
                              color: textColor[pokemon.type], fontSize: 14)),
                    ),
                    Column(
                      children: [
                        Text('Habilidades: ',
                            style: TextStyle(color: textColor[pokemon.type])),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Container(child: abilitiesBuild(pokemon.abilities)),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        Text(
                            "Alto: ${pokemon.height} m  Peso: ${pokemon.weight} kg",
                            style: TextStyle(color: textColor[pokemon.type])),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        Text("Tipos: ",
                            style: TextStyle(color: textColor[pokemon.type])),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Container(child: typesBuild(pokemon.types)),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        Text('Puntos de base'),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        Card(
                          child: Row(
                            children: [
                              Column(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Column(children: [
                                        Text(
                                          'PS',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          '${pokemon.hp}',
                                          textAlign: TextAlign.center,
                                        )
                                      ]),
                                      Column(children: [
                                        Text(
                                          'Ataque',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          '${pokemon.attack}',
                                          textAlign: TextAlign.center,
                                        )
                                      ]),
                                      Column(children: [
                                        Text(
                                          'Defensa',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          '${pokemon.defense}',
                                          textAlign: TextAlign.center,
                                        )
                                      ]),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Velocidad\nde Ataque',
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            '${pokemon.speedAttack}',
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Velocidad\nde Defensa',
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            '${pokemon.speedDefense}',
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                      Column(children: [
                                        Text(
                                          'Velocidad\n',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          '${pokemon.speed}',
                                          textAlign: TextAlign.center,
                                        )
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                              Column(children: [
                                Text(
                                  'Total',
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '${pokemon.total}',
                                  textAlign: TextAlign.center,
                                )
                              ])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                ],
              )),
            )),
      ),
    );
  }

  @override
  void initState() {
    print("daskjdhkjsahdjksahdjahsdjkhas");
    // TODO: implement initState
    super.initState();
  }
}
