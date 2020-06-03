import 'package:flutter/material.dart';
import './navigationBar/destination.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

//for zhengwen to put search bar (just need to change the text here and link the page in ./pages/destinationView)


// initialise the Emoji Parser here
var parser = EmojiParser();

class SecondaryPage extends StatelessWidget {
  const SecondaryPage({ Key key, this.destination }) : super(key: key);

  final Destination destination;
  
  @override
  Widget build(BuildContext context) {
    final displayTitle = parser.emojify('${destination.title} :ok_hand:');
    return Scaffold(
      appBar: AppBar(
        title: Text('${displayTitle}'),
        backgroundColor: destination.color,
      ),
      backgroundColor: destination.color[50],
      body: SizedBox.expand(
        child: InkWell(
          child: Center(
            child: AboutUsList(),
          ),
        ),
      ),
    );
  }
}

// custom WiseWords Class
class WiseWords {
  String name;
  String desc;

  WiseWords({ this.desc, this.name });
}

// Returns AboutUsState which contains list of reviews
class AboutUsList extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUsList> {
  static final smile = parser.emojify(':smile:');
  static final fire = parser.emojify(':fire:');
  static final sunglasses = parser.emojify(':sunglasses:');
  static final japanese_goblin = parser.emojify(':japanese_goblin:');
  static final heart = parser.emojify(':heart:');
  static final alien = parser.emojify(':alien:');

  List<WiseWords> words = [
    WiseWords(name: 'Tamelly ${smile}', desc: 'WeOKE! has helped me improve my singing!'),
    WiseWords(name: 'Guan Yew ${fire}', desc: 'Gonna sign up for Singapore Idol once covid is over!'),
    WiseWords(name: 'Zheng Wen ${sunglasses}', desc: 'WeOKE-ing with my colleagues during breaks at work has made my WFH experience even more awesome!'),
    WiseWords(name: 'Jin Wen ${japanese_goblin}', desc: 'We hope that everyone will be OK with WeOKE!'),
    WiseWords(name: 'Kang Ming ${alien}', desc: 'We love BrainHack 2020! ${heart} '),
  ]; 

  Widget wordsTemplate(word) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              word.desc,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              )
            ),
            SizedBox(height: 6.0),
            Text(
              word.name,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14.0, 
                color: Colors.grey[800]
              )
            )
          ])
        )
      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: words.map((item) => wordsTemplate(item)).toList()
      )
    );
  }
}
