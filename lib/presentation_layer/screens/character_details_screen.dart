import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import '../../business_logic_layer/cubit/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data_layer/models/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({Key? key, required this.character})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CharactersCubit.get(context).getQuotes(character.name);

    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildContainerBody(),
                SizedBox(height: 500), // to make title of appbar scroll to top
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.80,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          character.nickName,
          style: TextStyle(color: MyColors.myWhite),
          textAlign: TextAlign.start,
        ),
        background: Hero(
          tag: character.charId,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Container _buildContainerBody() {
    return Container(
      margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _characterInfo(
            title: 'Job: ',
            value: character.jobs.join(' / '),
          ),
          _devider(endIndentWidth: 315),
          _characterInfo(
            title: 'Appeared in: ',
            value: character.categoryForTwoSeries,
          ),
          _devider(endIndentWidth: 250),
          character.breakingBadSeasonsAppearance.isEmpty
              ? Container()
              : _characterInfo(
                  title: 'Seasons: ',
                  value: character.breakingBadSeasonsAppearance.join(' / '),
                ),
          character.breakingBadSeasonsAppearance.isEmpty
              ? Container()
              : _devider(endIndentWidth: 280),
          _characterInfo(
            title: 'Status: ',
            value: character.statusDeadOrAlive,
          ),
          _devider(endIndentWidth: 290),
          character.betterCallSaulSeasonsAppearance.isEmpty
              ? Container()
              : _characterInfo(
                  title: 'Better call saul seasons: ',
                  value: character.betterCallSaulSeasonsAppearance.join(' / '),
                ),
          character.betterCallSaulSeasonsAppearance.isEmpty
              ? Container()
              : _devider(endIndentWidth: 150),
          _characterInfo(
            title: 'Actor / Actress: ',
            value: character.actorName,
          ),
          _devider(endIndentWidth: 235),
          SizedBox(height: 20),
          BlocBuilder<CharactersCubit, CharactersState>(
            builder: (context, state) {
              return _checkIfQuotesAreLoaded(state);
            },
          )
        ],
      ),
    );
  }

  Row _characterInfo({
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          title,
          maxLines: 1,
          style: TextStyle(
            color: MyColors.myWhite,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                color: MyColors.myWhite,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Divider _devider({required double endIndentWidth}) {
    return Divider(
      color: MyColors.myYellow,
      height: 30,
      thickness: 2,
      endIndent: endIndentWidth,
    );
  }

// Start Quote text
  Widget _checkIfQuotesAreLoaded(state) {
    if (state is QuotesLoaded) {
      return _displayRandomQuoteOrCleanSpace(state);
    } else {
      return Container();
    }
  }

  Widget _displayRandomQuoteOrCleanSpace(state) {
    List quotes = state.quotes;

    if (quotes.length != 0) {
      int randomQuoteIndex = Random().nextInt(quotes.length - 1);
      return _buildQuoteText(quotes, randomQuoteIndex);
    } else {
      return Container();
    }
  }

  Column _buildQuoteText(List<dynamic> quotes, int randomQuoteIndex) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Total Quotes For ${character.name} = ${quotes.length}',
              style: TextStyle(
                color: MyColors.myWhite,
                fontSize: 18,
              ),
              softWrap: true,
            ),
          ],
        ),
        SizedBox(height: 16),
        Center(
          child: DefaultTextStyle(
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: MyColors.myWhite,
              shadows: [
                Shadow(
                  blurRadius: 5,
                  color: MyColors.myWhite,
                  offset: Offset(0.3, 0),
                )
              ],
            ),
            child: AnimatedTextKit(
              pause: Duration(seconds: 1),
              repeatForever: true,
              animatedTexts: [
                FlickerAnimatedText(quotes[randomQuoteIndex].quote),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
