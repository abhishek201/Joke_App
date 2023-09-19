//This class will be used to display joke list on the screen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joke_app/bloc/joke_bloc.dart';
import 'package:joke_app/model/joke.dart';

class JokeListScreen extends StatelessWidget {
  const JokeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jokes'),
      ),
      body: BlocBuilder<JokeCubit, List<Joke>>(
        builder: (context, jokes) {
          if(jokes.isEmpty){
            return const Center(child: Text('No Jokes Found'));
          } else {
            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(jokes[index].text),
                );
              },
            );
          }

        },
      ),
    );
  }
}