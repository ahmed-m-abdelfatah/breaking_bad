import 'package:flutter/material.dart';

import '../../app_router.dart';
import '../../constants/my_colors.dart';
import '../../data_layer/models/characters.dart';

class CharacterItem extends StatelessWidget {
  final Character character;
  const CharacterItem({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      padding: EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: MyColors.myWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            charactersDetailsScreen,
            arguments: character,
          );
        },
        child: GridTile(
          child: Hero(
            tag: character.charId,
            child: Container(
              color: MyColors.myGrey,
              child: character.image.isNotEmpty // there is an image
                  ? FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading.gif',
                      image: character.image,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/place_holder.png',
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ), // there is an no image
            ),
          ),
          footer: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            color: Colors.black45,
            alignment: Alignment.bottomCenter,
            child: Text(
              character.name,
              style: TextStyle(
                height: 1.3,
                color: MyColors.myWhite,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
