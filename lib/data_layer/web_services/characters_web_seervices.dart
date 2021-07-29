import 'package:dio/dio.dart';

class DioApiDataAndEndPoints {
  static String _baseUrl = 'https://www.breakingbadapi.com/api/';
  static String _charactersPathUrl = 'characters';
  static String _quotePathUrl = 'quote';
}

// to get data from api and put it into repository
class CharactersWebSeervices {
  late Dio dio;

  CharactersWebSeervices() {
    BaseOptions options = BaseOptions(
      baseUrl: DioApiDataAndEndPoints._baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000, // 20 sec
      receiveTimeout: 20 * 1000,
    );

    dio = Dio(options);
  }

  Future<List<dynamic>> getAllCharacters() async {
    try {
      return await _getAllCharactersJson();
    } catch (e) {
      return _errorEmptyList(e);
    }
  }

  Future<List<dynamic>> getCharacterQuotes(String charName) async {
    try {
      return await _getAllCharacterQuoteJson(charName);
    } catch (e) {
      return _errorEmptyList(e);
    }
  }

  Future<dynamic> _getAllCharactersJson() async {
    Response response = await dio.get(
      DioApiDataAndEndPoints._charactersPathUrl,
    );
    return response.data; // Json List
  }

  Future<dynamic> _getAllCharacterQuoteJson(String charName) async {
    Response response = await dio.get(
      DioApiDataAndEndPoints._quotePathUrl,
      queryParameters: {
        'author': charName,
      },
    );
    return response.data; // Json List
  }

  List<dynamic> _errorEmptyList(Object e) {
    print(e.toString());
    return [];
  }
}
