import 'package:dio/dio.dart';

abstract class PostRepository {
  Future<Response> fetchPost({required int offset});
}

class PostServices extends PostRepository {
  Dio dio = Dio();
  @override
  Future<Response> fetchPost({required int offset}) async{
    var response = await dio.get(
        "https://pokeapi.co/api/v2/pokemon?limit=20&offset=$offset",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        )
    );
    return response;
  }

}