import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final filterPokemon;
  FilterDialog({@required this.filterPokemon});

  @override
  _FilterDialogState createState() =>
      _FilterDialogState(filterPokemon: this.filterPokemon);
}

class _FilterDialogState extends State<FilterDialog> {
  final filterPokemon;

  _FilterDialogState({@required this.filterPokemon});

  List<Widget> buildGenerations() {
    List<int> listGenerations = [1, 2, 3, 4, 5, 6, 7];
    List<Widget> generationsWidgets = [];
    for (int gen in listGenerations) {
      generationsWidgets.add(GestureDetector(
        child: Container(
            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
            width: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Center(
                  child: Text(
                gen.toString(),
                style: TextStyle(fontWeight: FontWeight.w700),
              )),
            )),
        onTap: () {
          this.filterPokemon('generation', gen);
        },
      ));
    }
    return generationsWidgets;
  }

  List<String> listTypes = [
    "Normal",
    "Fighting",
    "Flying",
    "Poison",
    "Ground",
    "Rock",
    "Bug",
    "Ghost",
    "Steel",
    "Fire",
    "Water",
    "Grass",
    "Electric",
    "Psychic",
    "Ice",
    "Dragon",
    "Dark",
    "Fairy",
    "Unknown",
    "Shadow"
  ];

  String dropdownValue = "Grass";
  RangeValues _currentRangeValuesHP = const RangeValues(0, 0);
  RangeValues _currentRangeValuesAttack = const RangeValues(0, 0);
  RangeValues _currentRangeValuesDefense = const RangeValues(0, 0);
  RangeValues _currentRangeValuesVelocidad = const RangeValues(0, 0);
  bool _isswitched = false;

  @override
  Widget build(BuildContext context) {
    print("sadlkjsakldjsakljdkslajd");
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Elige una generación",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: buildGenerations(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Elige un tipo: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.only(right: 5)),
              DropdownButton<String>(
                value: dropdownValue,
                iconSize: 24,
                elevation: 16,
                underline: Container(
                  height: 2,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    this.filterPokemon('types', newValue);
                  });
                },
                items: listTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
              ),
            ]),
          ),
          Column(
            children: [
              Text(
                "Puntos de base: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Text('HP'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Center(child: Text('0')),
                      width: 10,
                    ),
                  ),
                  Expanded(
                    child: RangeSlider(
                      values: _currentRangeValuesHP,
                      min: 0,
                      max: 500,
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValuesHP = values;
                          this.filterPokemon('hp', [
                            _currentRangeValuesHP.start.round(),
                            _currentRangeValuesHP.end.round()
                          ]);
                        });
                      },
                      divisions: 10,
                      labels: RangeLabels(
                          _currentRangeValuesHP.start.round().toString(),
                          _currentRangeValuesHP.end.round().toString()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Center(child: Text('500')),
                      width: 25,
                    ),
                  ),
                ],
              ),
              Text('Ataque'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Center(child: Text('0')),
                    width: 30,
                  ),
                  Expanded(
                    child: RangeSlider(
                      values: _currentRangeValuesAttack,
                      min: 0,
                      max: 500,
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValuesAttack = values;
                          this.filterPokemon('attack', [
                            _currentRangeValuesAttack.start.round(),
                            _currentRangeValuesAttack.end.round()
                          ]);
                        });
                      },
                      divisions: 10,
                      labels: RangeLabels(
                          _currentRangeValuesAttack.start.round().toString(),
                          _currentRangeValuesAttack.end.round().toString()),
                    ),
                  ),
                  Container(
                    child: Center(child: Text('500')),
                    width: 30,
                  ),
                ],
              ),
              Text('Defensa'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Center(child: Text('0')),
                    width: 30,
                  ),
                  Expanded(
                    child: RangeSlider(
                      values: _currentRangeValuesDefense,
                      min: 0,
                      max: 500,
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValuesDefense = values;
                          this.filterPokemon('defense', [
                            _currentRangeValuesDefense.start.round(),
                            _currentRangeValuesDefense.end.round()
                          ]);
                        });
                      },
                      divisions: 10,
                      labels: RangeLabels(
                          _currentRangeValuesDefense.start.round().toString(),
                          _currentRangeValuesDefense.end.round().toString()),
                    ),
                  ),
                  Container(
                    child: Center(child: Text('500')),
                    width: 30,
                  ),
                ],
              ),
              Text('Velocidad'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Center(child: Text('0')),
                    width: 30,
                  ),
                  Expanded(
                    child: RangeSlider(
                      values: _currentRangeValuesVelocidad,
                      min: 0,
                      max: 500,
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValuesVelocidad = values;
                          this.filterPokemon('speed', [
                            _currentRangeValuesVelocidad.start.round(),
                            _currentRangeValuesVelocidad.end.round()
                          ]);
                        });
                      },
                      divisions: 10,
                      labels: RangeLabels(
                          _currentRangeValuesVelocidad.start.round().toString(),
                          _currentRangeValuesVelocidad.end.round().toString()),
                    ),
                  ),
                  Container(
                    child: Center(child: Text('500')),
                    width: 30,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Mostrar pokemones legendarios: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Switch(
                      value: _isswitched,
                      onChanged: (value) {
                        setState(() {
                          _isswitched = value;
                          this.filterPokemon('legendary', _isswitched);
                        });
                      }),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
