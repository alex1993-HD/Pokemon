import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:practicaresponse/dialogs/filter_dialog.dart';
import 'package:practicaresponse/models/pokemon.dart';
import 'package:practicaresponse/models/types.dart';
import 'package:practicaresponse/repo/pokemon_repo.dart';
import 'package:practicaresponse/screens/second_page.dart';
import 'package:practicaresponse/utils/functions.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// cuando se crea una pantalla pasa por build

// cuando se hace un setState se refresca el build (se vuelve a generar)

// lo que haces es quitar del Map de filtros {"generation", "types"} uno de esos

// en este ejemplo vamos a quitar generation {"types"}

// cuando se vuelve a hacer el build se recorre todos los elementos de filtros, y como ya solo esta "types"
// solo se crea el chip de "types"

// a su vez la funcion filterPokemon() siempre refresca la lista de pokemon basada en "filters" como en
// filters ya solo esta types ya no va filtrar por "generation"

// filterPokemon hace un setState, lo que significa que todo el build() se va a generar nuevamente

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int offset = 20;

  Future<List<Pokemon>> futurePokemon;
  ScrollController _scrollController = ScrollController();
  final _controller = TextEditingController();

  String msj = '';
  bool busqueda = false;

  Widget typesBuild(types, Pokemon pokemon) {
    List<Widget> ListTypes = [];
    for (String type in types) {
      ListTypes.add(Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: darkenColor(typeColor[type]),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Text(type, style: TextStyle(color: textColor[type])),
      ));
      ListTypes.add(Padding(
        padding: EdgeInsets.only(bottom: 10),
      ));
    }
    return Container(
      child: Column(
        children: ListTypes,
      ),
    );
  }

  bool _isDeleted = false;

  Widget chipsFiltersBuild(context) {
    List<Widget> chipsFilter = [];
    filters.forEach((key, value) {
      msj = 'Resultados de la busqueda/filtración';
      chipsFilter.add(RawChip(
        label: Text('$key : $value'),
        onDeleted: () {
          setState(() {
            _isDeleted = true;
            filters.remove(key);
            filterPokemon(null, null);
            msj = '';
            _controller.clear();
          });
        },
        onPressed: () {},
      ));
    });
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: chipsFilter,
      ),
    );
  }

  Widget buildCardPokemon(Pokemon pokemon) {
    print(pokemon.thumbnail);
    return GestureDetector(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${pokemon.name}",
                style: TextStyle(
                    fontSize: 20,
                    color: textColor[pokemon.type],
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(children: [
                        typesBuild(pokemon.types, pokemon),
                        Text(
                            '${pokemon.generation.replaceAll(RegExp(r'Generation'), 'Gen')}',
                            style: TextStyle(color: textColor[pokemon.type])),
                        Text('${pokemon.isLegendary.substring(0, 6)}',
                            style: TextStyle(color: textColor[pokemon.type])),
                      ]),
                    ),
                    Expanded(
                        child: CachedNetworkImage(imageUrl: pokemon.thumbnail))
                  ],
                ),
              )
            ],
          ),
        ),
        color: typeColor[pokemon.type],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SecondPage(pokemon: pokemon)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("AQUIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");

    void limpiarBusqueda() {
      msj = '';
      filters.remove('name');
      filterPokemon(null, null);
    }

    return Scaffold(
      appBar: AppBar(
        title: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Buscar pokemon...",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
              controller: _controller),
          suggestionsCallback: (String pattern) {
            //Necesito crear una lista de todos los nombres de los pokemon ya esa completos o filtrados
            String pat;
            if (pattern.isEmpty) {
              pat = pattern.toLowerCase();
            } else {
              pat = capitalize(pattern);
            }
            return completePokemon
                    .where((element) {
                      return element.name.startsWith(pat);
                    })
                    .toList()
                    .map((e) => e.name)
                    .toSet()
                    .toList() +
                completePokemon
                    .where((element) {
                      return element.type.startsWith(pat);
                    })
                    .toList()
                    .map((e) => e.type)
                    .toSet()
                    .toList() +
                completePokemon
                    .where((element) => element.generation.startsWith(pat))
                    .toList()
                    .map((e) => e.generation)
                    .toSet()
                    .toList() +
                completePokemon
                    .where((element) => element.isLegendary.startsWith(pat))
                    .toList()
                    .map((e) => e.isLegendary)
                    .toSet()
                    .toList();
          },
          itemBuilder: (context, suggestion) {
            //Tengo que recuperar cada uno de las sugerencias y mostrarlos en un ListTile
            return ListTile(title: Text(suggestion));
          },
          onSuggestionSelected: (suggestion) {
            if (listTypes.contains(suggestion)) {
              filterPokemon('type2', suggestion);
            } else if (listGenerations.contains(suggestion)) {
              filterPokemon('generation', suggestion);
            } else if (suggestion == 'Legendary' ||
                suggestion == 'No legendary') {
              filterPokemon('legendary', suggestion);
            } else {
              filterPokemon('name', suggestion);
            }
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            showNow();
          },
          tooltip: "Filtrar",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear_rounded),
            onPressed: () {
              setState(() {
                _controller.clear();
              });
            },
            tooltip: "Limpiar campo de búsqueda",
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(flex: 1, child: chipsFiltersBuild(context)),
          Text(msj),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                  itemCount:
                      listPokemon.length > 0 && listPokemon.length > offset
                          ? offset
                          : listPokemon.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16),
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder<List<Pokemon>>(
                        future: fetchedPokemon,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot != null) {
                            return buildCardPokemon(listPokemon[index]);
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else {
                            return buildCardPokemon(listPokemon[index]);
                          }
                        });
                  }),
            ),
          ),
        ],
      ),
    );
  }

  PokeRepo pokeRepo;
  Future<List<Pokemon>> fetchedPokemon;
  List<Pokemon> listPokemon = [];
  List<Pokemon> completePokemon = [];
  List<Pokemon> buscarPokemon = [];
  String type = "All";
  String generation = "All";
  int valorInicialHP = 0, valorFinalHP = 0;
  int valorInicialAtk = 0, valorFinalAtk = 0;
  int valorInicialDef = 0, valorFinalDef = 0;
  int valorInicialSP = 0, valorFinalSP = 0;
  bool type1act = false;
  Map<String, dynamic> filters = {};

  Map<String, Function> filterFunctions = {
    'type1': (elem, type) => elem.types.contains(type),
    'type2': (elem, type) => elem.types.contains(type),
    'generation': (elem, generation) => elem.generation == generation,
    'hp': (elem, values) => values[0] <= elem.hp && values[1] >= elem.hp,
    'attack': (elem, values) =>
        values[0] <= elem.attack && values[1] >= elem.attack,
    'defense': (elem, values) =>
        values[0] <= elem.defense && values[1] >= elem.defense,
    'speed': (elem, values) =>
        values[0] <= elem.speed && values[1] >= elem.speed,
    'legendary': (elem, state) => elem.isLegendary == state,
    'name': (elem, name) => elem.name.contains(name)
  };

  // a todos los filtros se les debe de agregar la opción (limpiar/todos) <- Hecho

  // se tiene que cambiar el nombre de esta funcion por filterByType <- Hecho

  // se tiene que hacer un filtro por lvl HP range <- Hecho

  // se tiene que hacer un filtro por lvl SP range <- Hecho

  // se tiene que hacer un filtro por lvl Def range <- Hecho

  // se tiene que hacer un filtro por lvl AtK range <- Hecho

  // se tiene que hacer un filtro por Legendario o no legendario <-Hecho

  // se tiene que hacer un filtro por generación <- Hecho

  // bool whereGeneration(element) {
  //   return element.generation;
  // }

  void filterPokemon(filter, value) {
    if (filter != null) {
      setState(() {
        this.filters[filter] = value;
      });
    }
    this.listPokemon = this.completePokemon;
    this.filters.forEach((f, v) {
      setState(() {
        this.listPokemon = this
            .listPokemon
            .where((element) => filterFunctions[f](element, v))
            .toList();
      });
    });
  }

  Future<List<Pokemon>> fetchListPokemon() async {
    List<Pokemon> newListPokemon =
        await pokeRepo.fetchPokemon(listPokemon.length);
    setState(() {
      this.completePokemon = completePokemon + newListPokemon;
      this.filterPokemon(null, null);
    });
    return listPokemon;
  }

  @override
  void initState() {
    super.initState();
    pokeRepo = PokeRepo();
    fetchedPokemon = fetchListPokemon();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        if (offset + 20 <= this.listPokemon.length) {
          offset += 20;
        } else {
          offset = this.listPokemon.length;
        }
      });
    }
  }

  void showNow() {
    print("longitud ${this.listPokemon.length}");
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        print("longituddsadsadsassa ${this.listPokemon.length}");

        return Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              title: Text("Filtrar por..."),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Container(
                  child: new FilterDialog(
                filterPokemon: this.filterPokemon,
              )),
            ));
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}
