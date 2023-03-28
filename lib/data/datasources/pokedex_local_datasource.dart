import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_with_riverpod/data/models/favorite_pokemon.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon_details.dart';
import 'package:pokedex_with_riverpod/pokedex_constants.dart';
import 'package:pokedex_with_riverpod/shared/clients/local_client/shared_prefs_storage_service.dart';
import 'package:pokedex_with_riverpod/shared/clients/local_client/storage_service.dart';

abstract class FavoritePokemonDataSource {
  Future<bool> addFavorite(PokemonDetails pokemon);
  Future removeAsFavorite(PokemonDetails pokemon);
  Future<List<PokemonDetails>> fetchFavoritePokemons();
}

class LocalFavoritePokemonDataSource extends FavoritePokemonDataSource {
  final LocalStorageClient localStorageClient;
  LocalFavoritePokemonDataSource(this.localStorageClient);

  @override
  Future<bool> addFavorite(PokemonDetails pokemon) async {
    final data = await getFavouritePokemonList();
    final listIsAvailableOnCache = _listIsAvailableOnCache(data);
    final listIsEmpty = _listOnCacheIsEmpty(data);
    if (!listIsAvailableOnCache) {
      //save to new list
      FavoritePokemons fav = FavoritePokemons(pokemons: [pokemon]);
      return localStorageClient.set(
          PokedexConstants.favortitePokemonPath, favoritePokemonsToJson(fav));
    } else if (!listIsEmpty && !pokemonExistsInList(data!, pokemon)) {
      final newFavoritePokemon = saveToExistingList(data, pokemon);
      return localStorageClient.set(PokedexConstants.favortitePokemonPath,
          favoritePokemonsToJson(newFavoritePokemon));
    }
    return false;
  }

  bool pokemonExistsInList(String data, PokemonDetails pokemon) {
    FavoritePokemons favoritePokemon = favoritePokemonsFromJson(data);
    return favoritePokemon.pokemons.any((element) {
      return element.id == pokemon.id;
    });
  }

  FavoritePokemons saveToExistingList(String data, PokemonDetails pokemon) {
    FavoritePokemons favoritePokemon = favoritePokemonsFromJson(data);
    favoritePokemon.pokemons.add(pokemon);
    return favoritePokemon;
  }

  Future<String?> getFavouritePokemonList() async {
    final data =
        await localStorageClient.get(PokedexConstants.favortitePokemonPath);
    if (data != null) {
      return data.toString();
    } else {
      return null;
    }
  }

  bool _listIsAvailableOnCache(String? data) {
    return data != null;
  }

  bool _listOnCacheIsEmpty(String? data) {
    final listIsAvailableOnCache = _listIsAvailableOnCache(data);
    if (!listIsAvailableOnCache) {
      return true;
    }
    final favoritePokemons = favoritePokemonsFromJson(data!);
    return favoritePokemons.pokemons.isEmpty;
  }

  @override
  Future<List<PokemonDetails>> fetchFavoritePokemons() async {
    final favoritePokemonsAsString = await getFavouritePokemonList();
    if (!_listIsAvailableOnCache(favoritePokemonsAsString)) {
      return <PokemonDetails>[];
    } else {
      final favoritePokemons =
          favoritePokemonsFromJson(favoritePokemonsAsString!);
      return favoritePokemons.pokemons;
    }
  }

  @override
  Future removeAsFavorite(PokemonDetails pokemon) async {
    //  to remove as favorite i have to get the list first,
    final data = await getFavouritePokemonList();
    // then run a check if the list is availabe
    final listIsAvailableOnCache = _listIsAvailableOnCache(data);
    //if list is available then i check through the list to see if pokemon is
    if (listIsAvailableOnCache && pokemonExistsInList(data!, pokemon)) {
      final favoritePokemons = favoritePokemonsFromJson(data);
      favoritePokemons.pokemons
          .removeWhere((element) => element.id == pokemon.id);
      return localStorageClient.set(PokedexConstants.favortitePokemonPath,
          favoritePokemonsToJson(favoritePokemons));
    }
    return false;
  }
}

final localFavoritePokemonDataSourceProvider =
    Provider<FavoritePokemonDataSource>((ref) {
  final localStorageClient = ref.watch(sharedPreferenceClientProvider);
  return LocalFavoritePokemonDataSource(localStorageClient);
});
