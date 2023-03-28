import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon.dart';
import 'package:pokedex_with_riverpod/domain/get_pokemon_providers.dart';
import 'package:pokedex_with_riverpod/shared/utils/loading_skeletons.dart';
import 'package:pokedex_with_riverpod/shared/utils/utils.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'pokemon_card.dart';

class AllPokemons extends ConsumerStatefulWidget {
  const AllPokemons({Key? key}) : super(key: key);

  @override
  ConsumerState<AllPokemons> createState() => _AllPokemonsState();
}

class _AllPokemonsState extends ConsumerState<AllPokemons>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final controller = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final pokemonCountProvider = ref.watch(pokedexCountProvider);
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;

    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: pokemonCountProvider.when(
          data: (pokemonCount) {
            return GridView.builder(
              controller: controller,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: sizingInformation.deviceScreenType ==
                          DeviceScreenType.tablet
                      ? 4
                      : 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      getValue(sizingInformation, orientation, mediaQuery)),
              itemCount: pokemonCount,
              itemBuilder: (_, index) {
                final AsyncValue<Pokemon> currentPokemonPageFromIndex = ref
                    .watch(paginatePokemonProvider(index ~/ 11))
                    .whenData((pageData) => pageData.results[index % 11]);

                return ProviderScope(
                  overrides: [
                    currentPokemonPageProvider
                        .overrideWithValue(currentPokemonPageFromIndex)
                  ],
                  child: const PokemonPageWidget(),
                );
              },
            );
          },
          loading: () {
            return Skeleton(
              width: double.maxFinite,
              height: mediaQuery.size.height * 0.8,
            );
          },
          error: (error, stackTrace) {
            return const Text('Error');
          },
        ),
      );
    });
  }
}

class PokemonPageWidget extends ConsumerWidget {
  const PokemonPageWidget({super.key});

  @override
  Widget build(context, ref) {
// Here we don't need to do anything but listen to the currentTransactionPageProvider's
    // AsyncValue that was overridden in the ListView's builder
    final AsyncValue<Pokemon?> currentPokemonPage =
        ref.watch(currentPokemonPageProvider);
    return currentPokemonPage.when(
        data: (Pokemon? pokemon) {
          return GestureDetector(
            child: PokemonCard(pokemon: pokemon!),
          );
        },
        error: (error, stackTrace) => const Text('error'),
        loading: () {
          return const Skeleton(
            width: double.infinity,
            height: 55,
          );
        });
  }
}
