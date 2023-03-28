import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_with_riverpod/data/models/paginated_response.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon_details.dart';
import 'package:pokedex_with_riverpod/shared/clients/remote_client/dio_client_respone.dart';

import '../../shared/clients/remote_client/network_client.dart';

abstract class PokemonDataSource {
  Future<PaginatedResponse<Pokemon>> getPokemons(int offset);
  Future<PokemonDetails> getPokemonDetails(Pokemon pokemon);
}

class PokedexRemoteDataSource implements PokemonDataSource {
  final NetworkClient networkClient;
  PokedexRemoteDataSource(this.networkClient);

  @override
  Future<PaginatedResponse<Pokemon>> getPokemons(int offset) async {
    try {
      final Response response = await networkClient
          .get('https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=11');

      return PaginatedResponse.fromJson(response.data,
          results: List<Pokemon>.from(
            response.data['results'].map((x) => Pokemon.fromJson(x)),
          ));
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
      rethrow;
    }
  }

  @override
  Future<PokemonDetails> getPokemonDetails(Pokemon pokemon) async {
    try {
      final Response response = await networkClient.get(pokemon.url);
      return PokemonDetails.fromJsonRemote(response.data, false);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

final pokemonRemoteDataSourceProvider = Provider<PokemonDataSource>(((ref) {
  final dioNetwokClient = ref.watch(dioNetworkClientProvider);
  return PokedexRemoteDataSource(dioNetwokClient);
}));
