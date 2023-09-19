import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import '../database/joke_database.dart';
import '../model/joke.dart';

class JokeCubit extends Cubit<List<Joke>> {
  final AppDatabase _database;

  JokeCubit(this._database) : super([]);
  //this function is used to fetch joke from server and store it in database
  void fetchJokes() async {
    final response = await http.get(Uri.parse('https://geek-jokes.sameerkumar.website/api?format=json'));
    if (response.statusCode == 200) {
      final jokeText = jsonDecode(response.body)['joke'];
      final joke = Joke(id: DateTime.now().millisecondsSinceEpoch, text: jokeText);

      var jokesList = await _database.getAllJokes();
      jokesList.insert(0, joke);
      if (jokesList.length > 10) {
        jokesList.removeLast();
        await _database.deleteOldJokes(jokesList.length - 10);
      }
      await _database.insertJoke(joke);
      emit(jokesList);
    } else {
      throw Exception('Failed to fetch joke');
    }
  }
  //this function is used to fetch jokes from database and display it on the first time
  void loadJokesFromDatabase() async {
    final jokesList = await _database.getAllJokes();
    emit(jokesList);
  }
}
