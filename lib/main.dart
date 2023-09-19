import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/joke_bloc.dart';
import 'database/joke_database.dart';
import 'screens/joke_list_screen.dart';

void main() {
  runApp(JokeApp());
}

class JokeApp extends StatelessWidget {
  final jokeCubit = JokeCubit(AppDatabase());

  JokeApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Fetch jokes every minute
    Timer.periodic(const Duration(seconds: 20), (Timer t) => jokeCubit.fetchJokes());

    // Load jokes from the database when the app is launched
    jokeCubit.loadJokesFromDatabase();

    return MaterialApp(
      title: 'Joke App',
      home: BlocProvider(
        create: (context) => jokeCubit,
        child: const JokeListScreen(),
      ),
    );
  }
}