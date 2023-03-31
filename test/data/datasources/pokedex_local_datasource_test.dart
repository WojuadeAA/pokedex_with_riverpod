import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_with_riverpod/data/datasources/pokedex_local_datasource.dart';
import 'package:pokedex_with_riverpod/shared/clients/local_client/storage_service.dart';

import '../models/favorite_pokemon_mock_data.dart';

void main() {
  late LocalStorageClient mockLocalStorageClient;
  late FavoritePokemonDataSource favoritePokemonDataSource;

  setUpAll(() {
    mockLocalStorageClient = MockLocalClient();
    favoritePokemonDataSource =
        LocalFavoritePokemonDataSource(mockLocalStorageClient);
  });

  group("favorite Pokemons Test", () {
    test("get favorite pokemons returns a string", () async {
      when(() => mockLocalStorageClient.get(any())).thenAnswer((_) async {
        return kfavoritePokemonJsonData;
      });
      final response = await favoritePokemonDataSource.fetchFavoritePokemons();
      expect(response, kfavoritePokemonJsonData);
    });
    // test("get pokemons details returns a Pokemon details Object", () async {
    //   when(() => mockLocalStorageClient.get(any())).thenAnswer((_) async {
    //     return Response(
    //         requestOptions: RequestOptions(),
    //         statusCode: 200,
    //         data: kPokemonDetailsData);
    //   });
    //   final response =
    //       await favoritePokemonDataSource.getPokemonDetails(kPokemon);
    //   expect(
    //       response, PokemonDetails.fromJsonRemote(kPokemonDetailsData, false));
    // });
  });
}

class MockLocalClient extends Mock implements LocalStorageClient {}
