import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_with_riverpod/data/datasources/pokedex_remote_datasource.dart';
import 'package:pokedex_with_riverpod/data/models/paginated_response.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon_details.dart';
import 'package:pokedex_with_riverpod/shared/clients/remote_client/network_client.dart';

import '../models/paginated_response_mock_data.dart';
import '../models/pokemon_details_mock_data.dart';

void main() {
  late MockNetworkClient mockNetworkClient;
  late PokemonDataSource pokemonDataSource;

  setUpAll(() {
    mockNetworkClient = MockNetworkClient();
    pokemonDataSource = PokedexRemoteDataSource(mockNetworkClient);
  });

  group("fetch Pokemons Test", () {
    test("get pokemons returns a Paginated Response on Success", () async {
      when(() => mockNetworkClient.get(any())).thenAnswer((_) async {
        return Response(
            requestOptions: RequestOptions(),
            statusCode: 200,
            data: kPaginatedResponseJsonData);
      });
      final response = await pokemonDataSource.getPokemons(0);
      expect(response, const PaginatedResponse<Pokemon>());
    });
    test("get pokemons details returns a Pokemon details Object", () async {
      when(() => mockNetworkClient.get(any())).thenAnswer((_) async {
        return Response(
            requestOptions: RequestOptions(),
            statusCode: 200,
            data: kPokemonDetailsData);
      });
      final response = await pokemonDataSource.getPokemonDetails(kPokemon);
      expect(
          response, PokemonDetails.fromJsonRemote(kPokemonDetailsData, false));
    });
  });
}

class MockNetworkClient extends Mock implements NetworkClient {}
