import 'package:flutter/material.dart';
import 'package:practicaresponse/main.dart';
import 'package:practicaresponse/models/abilities.dart';
import 'package:practicaresponse/models/pokemon.dart';
import 'package:practicaresponse/models/stats.dart';
import 'package:practicaresponse/models/types.dart';
import 'package:practicaresponse/repo/pokemon_repo.dart';
import 'package:practicaresponse/utils/functions.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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

  List<charts.Series> seriesList;

  List<charts.Series<BaseStats, String>> _createPokeBaseStat() {
    final pokemonBaseStats = [
      BaseStats('HP', pokemon.hp, charts.ColorUtil.fromDartColor(Colors.red)),
      BaseStats('Attack', pokemon.attack,
          charts.ColorUtil.fromDartColor(Colors.orange)),
      BaseStats('Defense', pokemon.defense,
          charts.ColorUtil.fromDartColor(Colors.yellow)),
      BaseStats('Speed Attack', pokemon.speedAttack,
          charts.ColorUtil.fromDartColor(Colors.blue)),
      BaseStats('Speed Defense', pokemon.speedDefense,
          charts.ColorUtil.fromDartColor(Colors.lightGreen)),
      BaseStats(
          'Speed', pokemon.speed, charts.ColorUtil.fromDartColor(Colors.pink)),
    ];

    return [
      charts.Series<BaseStats, String>(
          id: 'Base Stats',
          domainFn: (BaseStats baseStats, _) => baseStats.stat,
          measureFn: (BaseStats baseStats, _) => baseStats.value,
          colorFn: (BaseStats baseStats, _) => baseStats.colorStat,
          data: pokemonBaseStats,
          labelAccessorFn: (BaseStats baseStats, _) =>
              '${baseStats.value.toString()}',
          insideLabelStyleAccessorFn: (BaseStats baseStats, _) =>
              new charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(
                      textBaseStatColor[baseStats.stat])))
    ];
  }

  barChart() {
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: false,
      barGroupingType: charts.BarGroupingType.grouped,
      barRendererDecorator: new charts.BarLabelDecorator<String>(
          outsideLabelStyleSpec: new charts.TextStyleSpec(
              color: charts.ColorUtil.fromDartColor(Colors.black))),
      behaviors: [
        new charts.ChartTitle('Base Stats',
            behaviorPosition: charts.BehaviorPosition.top, innerPadding: 20),
        new charts.ChartTitle('Total: ${pokemon.total}',
            behaviorPosition: charts.BehaviorPosition.bottom, innerPadding: 20)
      ],
    );
  }

  Widget abilitiesBuild(abilities) {
    List<Widget> ListAbility = [];
    int numAbilities = 0;
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
      numAbilities += 1;
    }
    if (numAbilities >= 4) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 26,
        child: ListView(
          children: ListAbility,
          scrollDirection: Axis.horizontal,
        ),
      );
    } else {
      return Container(
        child: Row(
          children: ListAbility,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      );
    }
  }

  Widget typesBuild(types) {
    List<Widget> ListTypes = [];
    for (String type in types) {
      ListTypes.add(Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: darkenColor(typeColor[type]),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(type, style: TextStyle(color: textColor[type])),
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
                    Text("${pokemon.name}",
                        style: TextStyle(
                            color: textColor[pokemon.type],
                            fontSize: 35,
                            fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 1, 0, 5),
                      child: Text('${pokemon.generation}',
                          style: TextStyle(
                              color: textColor[pokemon.type], fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 1, 0, 10),
                      child: Text('${pokemon.isLegendary} pokemon',
                          style: TextStyle(
                              color: textColor[pokemon.type], fontSize: 14)),
                    ),
                    Column(
                      children: [
                        Text('Habilidades: ',
                            style: TextStyle(color: textColor[pokemon.type])),
                        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                        abilitiesBuild(pokemon.abilities),
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
                        SizedBox(
                            child: Card(
                                color: Colors.white,
                                child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: barChart())),
                            height: 360,
                            width: 400),
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
    seriesList = _createPokeBaseStat();
  }
}

class BaseStats {
  String stat;
  int value;
  final charts.Color colorStat;

  BaseStats(this.stat, this.value, this.colorStat);
}
