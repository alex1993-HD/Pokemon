import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:practicaresponse/models/pokemon.dart';

class PokeRepo {
  Future<List<Pokemon>> fetchPokemon(int offeset) async {
    final response = await http.get(
        'https://raw.githubusercontent.com/robert-z/simple-pokemon-json-api/master/data/pokemon.json');
    print("Estoy dentro de fetch Pokemon");
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Pokemon> pokemon = [];
      for (var result in jsonResponse) {
        pokemon.add(Pokemon.fromJson(result));
      }

      return pokemon;
    } else {
      throw Exception('Fallo al cargar un Pokemon');
    }
  }

  
}
