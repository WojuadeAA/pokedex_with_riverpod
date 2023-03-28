import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon_details.dart';
import 'package:pokedex_with_riverpod/domain/favorite_pokemon_providers.dart';
import 'package:pokedex_with_riverpod/presentation/widgets/pokemon_card.dart';
import 'package:pokedex_with_riverpod/presentation/widgets/pokemon_stat.dart';
import 'package:pokedex_with_riverpod/shared/utils/loading_skeletons.dart';
import 'package:pokedex_with_riverpod/shared/utils/utils.dart';

class PokemonDetailsScreen extends StatefulWidget {
  final PokemonDetails pokemon;
  const PokemonDetailsScreen({Key? key, required this.pokemon})
      : super(key: key);

  @override
  State<PokemonDetailsScreen> createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget buildAttribute(String name, String value, BuildContext context) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pokemon = widget.pokemon;

    return SafeArea(
      child: Scaffold(
          body: CustomScrollView(
            slivers: [
              Consumer(
                builder: (context, ref, child) {
                  final appbarBackgroundColor =
                      ref.watch(dominantColorProvider(pokemon.imageUrl));

                  return appbarBackgroundColor.maybeWhen(
                    data: (data) {
                      return SliverAppBar(
                          backgroundColor: data,
                          pinned: true,
                          leading: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                ref.invalidate(fetchFavoritePokemonsProvider);
                                context.pop();
                              }),
                          expandedHeight: 250,
                          flexibleSpace: child);
                    },
                    orElse: () => SliverAppBar(
                        backgroundColor: Colors.grey[200],
                        pinned: true,
                        expandedHeight: 250,
                        flexibleSpace: child),
                  );
                },
                child: FlexibleSpaceBar(
                  background: Hero(
                    tag: pokemon.id,
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, bottom: 10),
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  CachedNetworkImageProvider(pokemon.imageUrl),
                              fit: BoxFit.contain)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Container()),
                            Text(
                              pokemon.name,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(removeBrackets(pokemon.types.toString()),
                                style: Theme.of(context).textTheme.headline4),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              pokemon.id.toString().length == 1
                                  ? pokemon.id.toString().padLeft(2, "#00")
                                  : pokemon.id.toString().padLeft(3, '#0'),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    padding:
                        const EdgeInsets.only(left: 30, bottom: 10, top: 15),
                    color: Colors.white,
                    child: Row(children: [
                      buildAttribute(
                          'Height', pokemon.height.toString(), context),
                      const SizedBox(
                        width: 10,
                      ),
                      buildAttribute(
                          'Weight', pokemon.weight.toString(), context)
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 25),
                    color: Colors.white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Base stats",
                              style: Theme.of(context).textTheme.headline3),
                          const SizedBox(
                            height: 4,
                          ),
                          const Divider(
                            height: 12,
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          ...pokemon.stats.map((stat) {
                            var index = pokemon.stats.indexOf(stat);
                            return PokemonStat(stat: stat, index: index);
                          }).toList()
                        ]),
                  )
                ]),
              )
            ],
          ),
          floatingActionButton: Consumer(builder: (context, ref, _) {
            final isFavoritePokemon =
                ref.watch(isFavoritePokemonProvider(pokemon));
            return isFavoritePokemon.when(
              data: (isFavorite) {
                return FloatingActionButton(
                  backgroundColor: const Color(0xFF3558CD),
                  onPressed: () {
                    isFavorite
                        ? ref
                            .read(addToFavoriteProvider)
                            .removePokemonAsFavorite(pokemon)
                        : ref
                            .read(addToFavoriteProvider)
                            .addPokemonToFavorite(widget.pokemon);
                    ref.invalidate(fetchFavoritePokemonsProvider);
                  },
                  child:
                      Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                );
              },
              error: (error, stackTrace) {
                return Text(error.toString());
              },
              loading: () {
                return const CircleSkeleton();
              },
            );
          })),
    );
  }
}
