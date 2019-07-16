import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

/*
Uncomment this main() method for the StatelessWidget
*/
//void main() => runApp(MaterialApp(title: "Media", home: MyApp()));

void main() => runApp(MaterialApp(title: "Media", home: RandomWords()));

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add from here...
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider();
        }

        final int index = i ~/ 2;
        print("Index: $index, suggestion length: ${_suggestions.length}");
        if (index >= _suggestions.length) {
          print('Called Me.');
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      onTap: () {
        print(pair.asPascalCase);
      },
    );
  }

/*
  Uncomment below for the StatelessWidget
*/

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final wordPair = WordPair.random();
//     return getCenterWidget(wordPair);
//   }

//   Widget getCenterWidget(WordPair wordPair) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Welcome to Flutter'),
//       ),
//       body: Center(
//         child: Text(wordPair.asPascalCase),
//       ),
//     );
//   }
// }
