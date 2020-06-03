import 'dart:async';

import 'package:agora_flutter_quickstart/src/pages/call.dart';
import 'package:agora_flutter_quickstart/src/services/database.dart';
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
    databaseMethods.working().then((value) {
      print(value);
    });
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
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchTextEdittingController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            // contentPadding: const EdgeInsets.only(left: 14.0, bottom: 3.0, top: 3.0),
            border: InputBorder.none,
            hintText: 'Search url videos',
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
              // color: Colors.white,
              height: 100,
              child: DrawerHeader(
                child: Text('Song Queue', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),),
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   crossAxisAlignment: CrossAxisAlignment.stretch,
                //   children: <Widget>[
                //     Text('Guide to Make Money'),
                //   ],
                // ),
                
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: songListStream,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  return snapshot.hasData ?
                    ListView.builder(
                      padding: EdgeInsets.only(top: 0.0),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Ink(
                          // color: Colors.lightBlue.withAlpha(100),
                          child: ListTile(
                            title: Text("${snapshot.data.documents[index].data["songname"]}"),
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
                    : Container();
                }
              ),
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
}