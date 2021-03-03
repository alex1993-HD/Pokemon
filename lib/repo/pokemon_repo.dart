import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:practicaresponse/models/pokemon.dart';

class PokeRepo {
  Future<List<Pokemon>> fetchPokemon(int offeset) async {
    final response = await http.get(
        'https://gist.githubusercontent.com/erickdsama/0a62fbee2cb8e2346f8d95ec045e9abb/raw/8697b1457ed37df9d32fb8b1a35186651ea8d8b4/pokemon.json');
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
