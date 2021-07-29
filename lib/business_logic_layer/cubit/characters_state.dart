part of 'characters_cubit.dart';

@immutable
abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Character> characters;

  CharactersLoaded(this.characters);
}

class CharactersError extends CharactersState {
  final String errorMessage;

  CharactersError(this.errorMessage);
}

class QuotesLoaded extends CharactersState {
  final List<Quote> quotes;

  QuotesLoaded(this.quotes);
}

class QuotesError extends CharactersState {
  final String errorMessage;

  QuotesError(this.errorMessage);
}
