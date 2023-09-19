//This class will be used to store data in model class
class Joke {
  //unique id of joke
  final int id;
  //text of joke
  final String text;
  Joke({required this.id, required this.text});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['text'] = text;
    return map;
  }
}
