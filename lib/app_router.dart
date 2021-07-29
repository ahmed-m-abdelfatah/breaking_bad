import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_logic_layer/cubit/characters_cubit.dart';
import 'data_layer/models/characters.dart';
import 'data_layer/repository/characters_repository.dart';
import 'data_layer/web_services/characters_web_seervices.dart';
import 'presentation_layer/screens/character_details_screen.dart';
import 'presentation_layer/screens/characters_screen.dart';

const charactersScreen = '/';
const charactersDetailsScreen = '/characters_details';

class AppRouter {
  late CharactersCubit charactersCubitOne;
  late CharactersCubit charactersCubitTwo;
  late CharactersRepository charactersRepository;

  AppRouter() {
    charactersRepository = CharactersRepository(CharactersWebSeervices());
    charactersCubitOne = CharactersCubit(charactersRepository);
    charactersCubitTwo = CharactersCubit(charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return _goToCharactersScreen();

      case charactersDetailsScreen:
        final selectedCharacter = settings.arguments as Character;
        return _goToCharacterDetailsScreen(selectedCharacter);
    }
  }

  MaterialPageRoute<dynamic> _goToCharactersScreen() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => charactersCubitOne,
        child: CharactersScreen(),
      ),
    );
  }

  MaterialPageRoute<dynamic> _goToCharacterDetailsScreen(
    Character selectedCharacter,
  ) {
    return MaterialPageRoute(
        builder: (_) => BlocProvider(
              create: (_) => charactersCubitTwo,
              child: CharacterDetailsScreen(character: selectedCharacter),
            ));
  }
}
