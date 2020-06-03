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
  Stream ktvRoomStream;

  @override
  void initState() {
    getKTVRoomList();
    super.initState();
  }

  void getKTVRoomList() async {
    await databaseMethods.getKtvRoom(widget.channelName).then((value){
      setState(() {
        ktvRoomStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ktvRoomStream,
      builder: (context, snapshot) {
        var songlist;
        try {
          songlist = snapshot.data['songlist'];
        } catch (e) {
          songlist = [];
        }
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: searchTextEdittingController,
              onSubmitted: (value) {
                databaseMethods.createOrUpdateKtvRoom(widget.channelName, value);
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
                    child: Text('Song List', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),),
                  ),
                ),
                Expanded(
                  child: snapshot.hasData ?
                    ListView.builder(
                      padding: EdgeInsets.only(top: 0.0),
                      itemCount: songlist.length,
                      itemBuilder: (context, index) {
                        var songUrl = songlist[index];
                        var songname = SongNameParser.getSongName(songUrl);
                        return Ink(
                          // color: Colors.lightBlue.withAlpha(100),
                          child: ListTile(
                            title: Text('${songname}'),
                            onTap: () {},
                            leading: IconButton(
                              icon: Icon(Icons.arrow_upward),
                              onPressed: () {
                                databaseMethods.insertSong(widget.channelName, songUrl, songlist);
                              },
                            ),
                            trailing:  IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                databaseMethods.deleteSong(widget.channelName, songUrl);
                              },
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
          body: SingleChildScrollView(
            child : snapshot.hasData && songlist.length > 0 ? Column(
              children: [
                Text('Now Playing (cos its first in the list)'),
                Container(
                  margin: EdgeInsets.all(16),
                  child: snapshot.hasData ? Center(child: Text(SongNameParser.getSongName(songlist[0]), style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.w700),)) 
                  : CircularProgressIndicator(),
                ),
                Text(snapshot.hasData ? songlist[0] : '', style: TextStyle(fontSize: 11),),
              ],
            ) 
            : Text('add songs to play!')
            // CallPage(
            //       channelName: widget.channelName,
            //     ),
          ),
        );
      }
    );
  }
}