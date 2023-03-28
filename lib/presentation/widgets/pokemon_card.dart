import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon_details.dart';
import 'package:pokedex_with_riverpod/domain/get_pokemon_providers.dart';
import 'package:pokedex_with_riverpod/shared/utils/utils.dart';

import '../../../../router/router.dart';
import '../../../../shared/utils/loading_skeletons.dart';
import '../../data/models/pokemon.dart';

final dominantColorProvider =
    FutureProvider.family<Color, String>((ref, String imageUrl) async {
  final dominantColor = await getDominantColor(imageUrl);
  return dominantColor!;
});

class PokemonCard extends ConsumerStatefulWidget {
  final Pokemon pokemon;
  const PokemonCard({Key? key, required this.pokemon}) : super(key: key);

  @override
  ConsumerState<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends ConsumerState<PokemonCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pokemonDetails = ref.watch(getPokemonDetailsProvider(widget.pokemon));

    return LayoutBuilder(builder: (_, constraints) {
      return pokemonDetails.when(data: (PokemonDetails pokemonDetails) {
        final color = ref.watch(dominantColorProvider(pokemonDetails.imageUrl));
        return GestureDetector(
          onTap: () {
            context.push(Routes.pokemonDetailsScreen, extra: pokemonDetails);
          },
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.only(left: 5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                color: color.when(
                  data: (data) => data,
                  error: (error, stackTrace) => Colors.grey[200],
                  loading: () => Colors.grey[200],
                ),
                width: double.infinity,
                height: constraints.maxHeight * 0.55,
                child: Hero(
                  tag: pokemonDetails.id,
                  child: CachedNetworkImage(
                    imageUrl: pokemonDetails.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, _) => Container(
                      height: constraints.maxHeight * 0.55,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.02,
              ),
              Text(
                pokemonDetails.id.toString().length == 1
                    ? pokemonDetails.id.toString().padLeft(2, "#00")
                    : pokemonDetails.id.toString().padLeft(3, '#0'),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: constraints.maxHeight * 0.02,
              ),
              Text(
                pokemonDetails.name,
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: constraints.maxHeight * 0.02,
              ),
              FittedBox(
                child: Text(
                  removeBrackets(pokemonDetails.types.toString()),
                  style: Theme.of(context).textTheme.bodyText1,
                  softWrap: true,
                ),
              ),
            ]),
          ),
        );
      }, loading: () {
        return Skeleton(
          width: double.infinity,
          height: constraints.maxHeight * 0.55,
        );
      }, error: ((error, stackTrace) {
        return Text(error.toString());
      }));
    });
  }
}
