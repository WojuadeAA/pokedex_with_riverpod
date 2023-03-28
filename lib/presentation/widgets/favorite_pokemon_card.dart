import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon_details.dart';
import 'package:pokedex_with_riverpod/presentation/widgets/pokemon_card.dart';

import '../../../../shared/utils/utils.dart';

class FavoritePokemonCard extends ConsumerWidget {
  final PokemonDetails pokemon;
  const FavoritePokemonCard({Key? key, required this.pokemon})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(dominantColorProvider(pokemon.imageUrl));

    return LayoutBuilder(
      builder: (_, constraints) => Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.only(left: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            color: color.asData?.value,
            width: double.infinity,
            height: constraints.maxHeight * 0.55,
            child: Hero(
              tag: "favourite ${pokemon.id}",
              child: CachedNetworkImage(
                imageUrl: pokemon.imageUrl,
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
            pokemon.id.toString().length == 1
                ? pokemon.id.toString().padLeft(2, "#00")
                : pokemon.id.toString().padLeft(3, '#0'),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          Text(
            pokemon.name,
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.02,
          ),
          FittedBox(
            child: Text(
              removeBrackets(pokemon.types.toString()),
              style: Theme.of(context).textTheme.bodyText1,
              softWrap: true,
            ),
          ),
        ]),
      ),
    );
  }
}
