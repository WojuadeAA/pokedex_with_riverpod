import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_with_riverpod/domain/favorite_pokemon_providers.dart';
import 'package:pokedex_with_riverpod/presentation/widgets/favorite_pokemon_card.dart';
import 'package:pokedex_with_riverpod/shared/utils/utils.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../shared/utils/loading_skeletons.dart';
import '../screens/pokemon_details_screen.dart';

class FavoritePokemonsScreen extends StatelessWidget {
  const FavoritePokemonsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;

    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Consumer(builder: (context, ref, child) {
        final favoritePokemons = ref.watch(fetchFavoritePokemonsProvider);
        return favoritePokemons.when(
            data: (pokemonList) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: sizingInformation.deviceScreenType ==
                            DeviceScreenType.tablet
                        ? 4
                        : 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio:
                        getValue(sizingInformation, orientation, mediaQuery)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemCount: pokemonList.length,
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          PokemonDetailsScreen(pokemon: pokemonList[index]))),
                  child: FavoritePokemonCard(
                    pokemon: pokemonList[index],
                  ),
                ),
              );
            },
            error: ((error, stackTrace) => Text(error.toString())),
            loading: () => const Skeleton());
      });
    });
  }
}
