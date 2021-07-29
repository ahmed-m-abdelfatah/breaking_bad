import '../models/characters.dart';
import '../models/quote.dart';
import '../web_services/characters_web_seervices.dart';

// to get data from charactersWebSeervices and put it into characters<Character>
class CharactersRepository {
  final CharactersWebSeervices charactersWebSeervices;
  CharactersRepository(this.charactersWebSeervices);

  Future<List<Character>> getAllCharacters() async {
    final characters = await charactersWebSeervices.getAllCharacters();
    return characters.map((char) => Character.fromJson(char)).toList();
  }

  Future<List<Quote>> getCharacterQuotes(String charName) async {
    final quotes = await charactersWebSeervices.getCharacterQuotes(charName);
    return quotes.map((charQuotes) => Quote.fromJson(charQuotes)).toList();
  }
}
