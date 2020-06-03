import 'dart:async';

import 'package:agora_flutter_quickstart/src/pages/call.dart';
import 'package:agora_flutter_quickstart/src/services/database.dart';
import 'package:agora_flutter_quickstart/src/utils/parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SongConsole extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// Creates a call page with given channel name.
  const SongConsole({Key key, this.channelName}) : super(key: key);

  @override
  _SongConsoleState createState() => _SongConsoleState();
}
  
class _SongConsoleState extends State<SongConsole>{
  TextEditingController searchTextEdittingController = TextEditingController();  
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream songListStream;

  @override
  void initState() {
    getKTVRoomList();
    super.initState();
  }

  void getKTVRoomList() async {
    await databaseMethods.getSongList(widget.channelName).then((value){
      setState(() {
        songListStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: songListStream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: searchTextEdittingController,
              onSubmitted: (value) {
                databaseMethods.createOrUpdateKtvRoom(widget.channelName, {
                  'index': snapshot.data.documents.length,
                  'url': value
                });
                searchTextEdittingController.clear();
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                // contentPadding: const EdgeInsets.only(left: 14.0, bottom: 3.0, top: 3.0),
                border: InputBorder.none,
                hintText: 'Enter Video Url',
                hintStyle: TextStyle(color: Colors.black54),
              ),
            ),
            // leading: Icon(Icons.exit_to_app),
            actions:[
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.queue_music),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
              
            ]
          ),
          endDrawer: Drawer(
            child: Column(
              children: [
                Container(
                  height: 100,
                  child: DrawerHeader(
                    child: Text('Song Queue', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),),
                  ),
                ),
                Expanded(
                  child: snapshot.hasData ?
                    ListView.builder(
                      padding: EdgeInsets.only(top: 0.0),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        var songname = SongNameParser.getSongName(snapshot.data.documents[index].data['url']);
                        return Ink(
                          // color: Colors.lightBlue.withAlpha(100),
                          child: ListTile(
                            title: Text('${songname}'),
                            onTap: () {},
                            leading: IconButton(
                              icon: Icon(Icons.arrow_upward),
                              onPressed: () {},
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {},
                            )
                          ),
                        );
                      },
                    )
                    : Container()
                ),
              ]
            ),
          ),
          body: Container() 
          // CallPage(
          //       channelName: widget.channelName,
          //     ),
        );
      }
    );
  }
}