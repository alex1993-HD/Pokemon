import 'dart:convert';

import 'package:practicaresponse/models/abilities.dart';
import 'package:practicaresponse/models/stats.dart';
import 'package:practicaresponse/models/types.dart';
import 'package:practicaresponse/utils/functions.dart';

String defaultLinkPokemonThumbnails =
    "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/thumbnails/";

String defaultLinkPokemonImage =
    "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/";

class Pokemon {
  String name, type, photo, thumbnail;
  double height, weight;
  List<String> abilities;
  List<String> types;
  int total, hp, attack, defense, speedAttack, speedDefense, speed, generation;
  bool isLegendary;

  Pokemon(
      {this.name,
      this.generation,
      this.type,
      this.photo,
      this.thumbnail,
      this.abilities,
      this.types,
      this.height,
      this.weight,
      this.total,
      this.hp,
      this.attack,
      this.defense,
      this.speedAttack,
      this.speedDefense,
      this.speed,
      this.isLegendary});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    String photoUrlThumbail = defaultLinkPokemonThumbnails +
        json["pokedex_number"].toString().padLeft(3, '0') +
        ".png";
    String photoUrlImage = defaultLinkPokemonImage +
        json["pokedex_number"].toString().padLeft(3, '0') +
        ".png";
    print(photoUrlThumbail);
    String typePokemon = json["types"][0];
    List<String> abilities = [];
    for (var ability in json['abilities']) {
      abilities.add(ability.toString());
    }
    List<String> types = [];
    for (var type in json['types']) {
      types.add(type.toString());
    }
    return Pokemon(
        height: json["height"].toDouble(),
        weight: json["weight"].toDouble(),
        abilities: abilities,
        types: types,
        total: json['total'],
        hp: json['hp'],
        attack: json['attack'],
        defense: json['defense'],
        speedAttack: json['speedAttack'],
        speedDefense: json['speedDefense'],
        speed: json['speed'],
        name: json['name'].toString().toLowerCase(),
        generation: json['generation'],
        type: capitalize(typePokemon),
        photo: photoUrlImage,
        thumbnail: photoUrlThumbail,
        isLegendary: json['is_legendary']);
  }
}
