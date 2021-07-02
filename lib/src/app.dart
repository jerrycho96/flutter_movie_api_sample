import 'package:flutter/material.dart';
import 'package:flutter_movie_api_sample/src/controller/movie_controller.dart';
import 'package:provider/provider.dart';

import 'components/category_movie_list.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late MovieController _movieController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _movieController = Provider.of<MovieController>(context, listen: false);
  }

  Widget _genreTag(Map<String, dynamic> genre) {
    var isActive = _movieController.activeGenreId == genre['id'];
    return GestureDetector(
      onTap: () {
        _movieController.changeCategory(genre);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          // borderRadius: BorderRadius.circular(30),
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: isActive ? Colors.grey : Colors.white,
        ),
        child: Text(
          genre['name'],
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Category'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: _movieController.loadGenre(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              // 데이터가 존재하는지 체크
              if (snapshot.data != null) {
                return Consumer<MovieController>(
                  builder: (context, value, child) {
                    return SingleChildScrollView(
                      // 가로 스크롤
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(snapshot.data!.length,
                            (index) => _genreTag(snapshot.data![index])),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          CategoryMovieList(),
        ],
      ),
    );
  }
}
