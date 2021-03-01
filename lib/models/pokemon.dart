import 'package:practicaresponse/models/abilities.dart';
import 'package:practicaresponse/models/stats.dart';
import 'package:practicaresponse/models/types.dart';
import 'package:practicaresponse/utils/functions.dart';

String defaultLinkPokemonThumbnails =
    "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/thumbnails/";

String defaultLinkPokemonImage =
    "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/";

class Pokemon {
  String name, generation, gen, type, photo, thumbnail;
  double height, weight;
  List<String> abilities;
  List<String> types;
  int total, hp, attack, defense, speedAttack, speedDefense, speed;
  //List<Stats> base_stats;

  Pokemon(
      {this.name,
      this.generation,
      this.gen,
      this.type,
      this.photo,
      this.thumbnail,
      this.abilities,
      this.types,
      // this.base_stats,
      this.height,
      this.weight,
      this.total,
      this.hp,
      this.attack,
      this.defense,
      this.speedAttack,
      this.speedDefense,
      this.speed});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<dynamic> variations = json["variations"];

    Map<String, dynamic> firstVariation = variations[0];

    String photoUrlThumbail = defaultLinkPokemonThumbnails +
        json["num"].toString().padLeft(3, '0') +
        ".png";
    String photoUrlImage = defaultLinkPokemonImage +
        json["num"].toString().padLeft(3, '0') +
        ".png";
    print(photoUrlThumbail);
    String typePokemon = firstVariation["types"][0];
    List<String> abilities = [];
    for (var ability in firstVariation['abilities']) {
      abilities.add(ability.toString());
    }
    List<String> types = [];
    for (var type in firstVariation['types']) {
      types.add(type.toString());
    }
    String description = firstVariation['description'];
    String des, des_completo;

    des_completo = getGenerationFromDescription(description);
    des = des_completo.replaceFirst("eration", "");

    Map<String, dynamic> stat = firstVariation['stats'];
    return Pokemon(
      height: firstVariation["height"].toDouble(),
      weight: firstVariation["weight"].toDouble(),
      abilities: abilities,
      types: types,
      total: stat['total'],
      hp: stat['hp'],
      attack: stat['attack'],
      defense: stat['defense'],
      speedAttack: stat['speedAttack'],
      speedDefense: stat['speedDefense'],
      speed: stat['speed'],
      name: json['name'].toString().toLowerCase(),
      generation: des_completo,
      gen: des,
      type: typePokemon,
      photo: photoUrlImage,
      thumbnail: photoUrlThumbail,
    );
  }
}
