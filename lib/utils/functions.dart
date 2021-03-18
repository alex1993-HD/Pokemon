import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

Map<String, Color> typeColor = {
  "Bug": Colors.green[900],
  "Dark": Colors.black,
  "Dragon": Colors.cyan[800],
  "Electric": Colors.yellow,
  "Fairy": Colors.pink[700],
  "Fighting": Colors.deepOrange[900],
  "Fire": Colors.red[900],
  "Flying": Colors.blueGrey,
  "Ghost": Colors.deepPurple[400],
  "Grass": Colors.green,
  "Ground": Colors.brown[700],
  "Ice": Colors.lightBlue[200],
  "Normal": Colors.brown[300],
  "Poison": Colors.deepPurple[600],
  "Psychic": Colors.pinkAccent,
  "Rock": Colors.brown[900],
  "Steel": Color(0xffaaffcc),
  "Water": Colors.blue[900],
};

Map<String, Color> textColor = {
  "Bug": Colors.white,
  "Dark": Colors.white,
  "Dragon": Colors.white,
  "Electric": Colors.black,
  "Fairy": Colors.white,
  "Fighting": Colors.white,
  "Fire": Colors.white,
  "Flying": Colors.white,
  "Ghost": Colors.white,
  "Grass": Colors.white,
  "Ground": Colors.white,
  "Ice": Colors.black,
  "Mormal": Colors.white,
  "Poison": Colors.white,
  "Psychic": Colors.white,
  "Rock": Colors.white,
  "Steel": Colors.black,
  "Water": Colors.white,
};

Map<String, Color> textBaseStatColor = {
  "HP": Colors.white,
  "Attack": Colors.black,
  "Defense": Colors.black,
  "Speed Attack": Colors.white,
  "Speed Defense": Colors.black,
  "Speed": Colors.white,
};

Color darkenColor(Color color) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl
      .withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0))
      .withAlpha(hsl.alpha - 0.3);
  return hslDark.toColor();
}

String getGenerationFromDescription(String description) {
  RegExp regexp = new RegExp(r'Generation\s[0-9]');
  return regexp.allMatches(description).map((m) => m[0]).toList()[0];
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

List<String> listGenerations = [
  "Generation 1",
  "Generation 2",
  "Generation 3",
  "Generation 4",
  "Generation 5",
  "Generation 6",
  "Generation 7"
];

List<bool> listLegendary = [true, false];
