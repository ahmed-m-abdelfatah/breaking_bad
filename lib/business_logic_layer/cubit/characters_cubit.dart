import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data_layer/models/characters.dart';
import '../../data_layer/models/quote.dart';
import '../../data_layer/repository/characters_repository.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  // make an object from CharactersCubit class
  static CharactersCubit get(context) => BlocProvider.of(context);

  final CharactersRepository charactersRepository;
  CharactersCubit(this.charactersRepository) : super(CharactersInitial());
  List<Character> characters = [];

  List<Character> getAllCharacters() {
    charactersRepository.getAllCharacters().then(
      (characters) {
        this.characters = characters;
        emit(CharactersLoaded(characters));
      },
    ).catchError(
      (errorMessage) {
        print(errorMessage);
        emit(CharactersError(errorMessage));
      },
    );
    return characters;
  }

  void getQuotes(String charName) {
    charactersRepository.getCharacterQuotes(charName).then(
      (quotes) {
        print('The quotes are from $charName');
        print('First quotes = ${quotes[0].quote}');
        print('Total quotes = ${quotes.length}');
        emit(QuotesLoaded(quotes)); // put quotes list in QuotesLoaded state
      },
    ).catchError(
      (errorMessage) {
        print(errorMessage);
        emit(CharactersError(errorMessage));
      },
    );
  }
}
