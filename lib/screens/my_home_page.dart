import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:practicaresponse/dialogs/filter_dialog.dart';
import 'package:practicaresponse/models/pokemon.dart';
import 'package:practicaresponse/models/types.dart';
import 'package:practicaresponse/repo/pokemon_repo.dart';
import 'package:practicaresponse/screens/second_page.dart';
import 'package:practicaresponse/utils/functions.dart';

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

  String msj = '';
  bool busqueda = false;

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Widget typesBuild(types, Pokemon pokemon) {
    List<Widget> ListTypes = [];
    for (String type in types) {
      ListTypes.add(Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: darkenColor(typeColor[type]),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Text(type, style: TextStyle(color: Colors.white)),
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
      if (key != 'name') {
        chipsFilter.add(RawChip(
          label: Text('$key : $value'),
          onDeleted: () {
            setState(() {
              _isDeleted = true;
              filters.remove(key);
              filterPokemon(null, null);
            });
          },
          onPressed: () {},
        ));
      }
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
                "${capitalize(pokemon.name)}",
                style: TextStyle(fontSize: 20, color: textColor[pokemon.type]),
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
                        Text('${pokemon.gen}',
                            style: TextStyle(color: textColor[pokemon.type]))
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

    final _controller = TextEditingController();

    Widget activarBotonCancelarBusqueda(busqueda) {
      if (busqueda == true) {
        return IconButton(
          icon: Icon(Icons.clear_rounded),
          onPressed: () {
            setState(() {
              //_controller.clear();
              limpiarBusqueda();
              busqueda = false;
            });
          },
        );
      } else {
        return Container();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          cursorColor: Colors.white,
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
          onChanged: (textBusqueda) {
            if (textBusqueda.isNotEmpty) {
              // Cuando lo escriba deben aparecer los pokemones que escriba el usuario
              setState(() {
                busqueda = true;
                msj = 'Resultados de la busqueda:';
                filterPokemon('name', textBusqueda);
              });
            } else {
              // Regresamos a la lista personalizada o completa
              setState(() {
                limpiarBusqueda();
                busqueda = false;
              });
            }
          },
          //controller: _controller,
        ),
        leading: IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            showNow();
          },
        ),
        actions: [activarBotonCancelarBusqueda(busqueda)],
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
                            //return verificarFiltroTipos(snapshot.data[index]);
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
  Map<String, dynamic> filters = {};

  Map<String, Function> filterFunctions = {
    'types': (elem, type) => elem.types.contains(type),
    'generation': (elem, generation) => elem.generation == generation,
    'hp': (elem, values) => values[0] <= elem.hp && values[1] >= elem.hp,
    'attack': (elem, values) =>
        values[0] <= elem.attack && values[1] >= elem.attack,
    'defense': (elem, values) =>
        values[0] <= elem.defense && values[1] >= elem.defense,
    'speed': (elem, values) =>
        values[0] <= elem.speed && values[1] >= elem.speed,
    'legendary': (elem, values) => elem.legendary,
    'name': (elem, name) => elem.name.contains(name)
  };

  // a todos los filtros se les debe de agregar la opción (limpiar/todos) <- Hecho

  // se tiene que cambiar el nombre de esta funcion por filterByType <- Hecho

  // se tiene que hacer un filtro por lvl HP range <- Hecho

  // se tiene que hacer un filtro por lvl SP range <- Hecho

  // se tiene que hacer un filtro por lvl Def range <- Hecho

  // se tiene que hacer un filtro por lvl AtK range <- Hecho

  // se tiene que hacer un filtro por Legendario o no legendario

  // se tiene que hacer un filtro por generación <- Hecho

  bool whereGeneration(element) {
    return element.generation;
  }

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
