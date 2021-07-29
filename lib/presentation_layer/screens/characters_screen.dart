import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../business_logic_layer/cubit/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data_layer/models/characters.dart';
import '../widgets/character_item.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> _allCharacters;
  late List<Character> _searchedCharacters;
  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // to make an object of CharactersCubit
    // BlocProvider.of<CharactersCubit>(context).getAllCharacters(); // old_method
    CharactersCubit.get(context).getAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool _connected = connectivity != ConnectivityResult.none;
          if (_connected) {
            return _buildBlocWidget();
          } else {
            return _buildNoInternetWidget();
          }
        },
        child: _showLoadingIndiactor(),
      ),
    );
  }

  // AppBar
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: MyColors.myYellow,
      leading: _isSearching
          ? BackButton(
              color: MyColors.myGrey,
            )
          : Container(),
      centerTitle: true,
      title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
      actions: _buildAppBarActions(),
    );
  }

  TextField _buildSearchField() {
    TextStyle _searchTextStyle = TextStyle(
      color: MyColors.myGrey,
      fontSize: 18,
    );

    return TextField(
      controller: _searchTextController,
      cursorColor: MyColors.myGrey,
      decoration: InputDecoration(
        hintText: 'Find A Character ...',
        hintStyle: _searchTextStyle,
        border: InputBorder.none,
      ),
      style: _searchTextStyle,
      onChanged: (String searchText) {
        _addSearchedItemsToList(searchText);
      },
    );
  }

  Text _buildAppBarTitle() {
    return Text(
      'Characters',
      style: TextStyle(color: MyColors.myGrey),
    );
  }

  List<IconButton> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: MyColors.myGrey,
          ),
        )
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: Icon(
            Icons.search,
            color: MyColors.myGrey,
          ),
        )
      ];
    }
  }

  // Body

  BlocBuilder _buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state is CharactersLoaded) {
          _allCharacters = state.characters;
          return _buildLoadedListWidget();
        } else {
          return _showLoadingIndiactor();
        }
      },
    );
  }

  SingleChildScrollView _buildLoadedListWidget() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(
          children: [
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _searchTextController.text.isEmpty
                  ? _allCharacters.length
                  : _searchedCharacters.length,
              itemBuilder: (context, index) {
                return CharacterItem(
                  character: _searchTextController.text.isEmpty
                      ? _allCharacters[index]
                      : _searchedCharacters[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Center _showLoadingIndiactor() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Center _buildNoInternetWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Can't Connect .. Check Your Internet",
              style: TextStyle(
                fontSize: 20,
                color: MyColors.myGrey,
              ),
            ),
            Image.asset('assets/images/no_internet.png'),
          ],
        ),
      ),
    );
  }

  // Search
  void _addSearchedItemsToList(String searchText) {
    _searchedCharacters = _allCharacters
        .where(
          (character) => character.name.toLowerCase().startsWith(searchText),
        )
        .toList();
    setState(() {});
  }

  void _startSearch() {
    // to get back button in new route
    ModalRoute.of(context)!.addLocalHistoryEntry(
      LocalHistoryEntry(onRemove: _stopSearch),
    );
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    _clearSearch();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchTextController.clear();
    });
  }
}
