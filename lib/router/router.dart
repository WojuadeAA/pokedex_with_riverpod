import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon_details.dart';
import 'package:pokedex_with_riverpod/presentation/screens/mobile_screen.dart';
import 'package:pokedex_with_riverpod/presentation/screens/pokemon_details_screen.dart';
import 'package:pokedex_with_riverpod/shared/extentions/string_extentions.dart';

part 'routes.dart';

final router = GoRouter(
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('${state.error}'),
    ),
  ),
  initialLocation: Routes.root,
  routes: [
    GoRoute(
      path: Routes.root,
      builder: (context, GoRouterState state) => const MobileScreen(),
      routes: [
        GoRoute(
          path: Routes.pokemonDetailsScreen.removeSlash(),
          builder: (context, GoRouterState state) {
            return PokemonDetailsScreen(pokemon: state.extra as PokemonDetails);
          },
        ),
        // GoRoute(
        //   path: Routes.pinAuth.removeSlash(),
        //   builder: (context, state) => const PinAuthScreen(),
        // ),
      ],
    )
  ],
);
