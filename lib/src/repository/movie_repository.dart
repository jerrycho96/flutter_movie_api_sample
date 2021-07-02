import 'package:dio/dio.dart';
import 'package:flutter_movie_api_sample/src/model/movie.dart';

class MovieRepository {
  late var _dio;

  MovieRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org',
        queryParameters: {'api_key': 'adaa4e192283312f04aa20e770ebdd4c'},
      ),
    );
  }

  Future<List<Map<String, dynamic>>> loadGenre() async {
    var response = await _dio.get('/3/genre/movie/list');
    if (response.data != null) {
      // 리스트 타입으로 변경
      var data = response.data['genres'] as List;
      return data.map((genre) => genre as Map<String, dynamic>).toList();
    } else {
      return [];
    }
  }

  Future<List<Movie>> loadMovieListWithGenre(int activeGenreId) async {
    var response = await _dio.get('/3/discover/movie',
        queryParameters: {'with_genres': activeGenreId});
    if (response.data != null && response.data['results'] != null) {
      // 리스트 타입으로 변경
      var data = response.data['results'] as List;
      return data.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      return [];
    }
  }
}
