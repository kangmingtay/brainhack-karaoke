// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// void main() => runApp(VideoApp(channel: IOWebSocketChannel.connect('ws://echo.websocket.org'),));

// class VideoApp extends StatefulWidget {
//   // final WebSocketChannel channel;

//   VideoApp({Key key, @required this.channel})
//       : super(key: key);
//   @override
//   _VideoAppState createState() => _VideoAppState();
// }

// class _VideoAppState extends State<VideoApp> {
//   VideoPlayerController _controller;
//   Future<void> _initializeVideoPlayerFuture;
//   WebSocketChannel channel;
//   @override
//   void initState() {
//     super.initState();
//     // final file = File();
//     _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
//     // Initialize the controller and store the Future for later use.
//     _initializeVideoPlayerFuture = _controller.initialize();

//     // Use the controller to loop the video.
//     _controller.setLooping(true);
//     // channel = IOWebSocketChannel.connect("ws://localhost:1234");
//   }

//   @override
//   Widget build(BuildContext context) {
//     widget.channel.stream.listen((message) {
//       print(message);
//       if (message == 'play') {
//         setState(() {
//           _controller.play();
//         });
//       } else {
//         setState(() {
//           _controller.pause();
//         });
//       }
//       // setState(() {
//       //   _controller.value.isPlaying
//       //       ? _controller.pause()
//       //       : _controller.play();
//       // });
//     });
//     return MaterialApp(
//       title: 'Video Demo',
//       home: Scaffold(
//         body: 
//             Center(
//               child: _controller.value.initialized
//                   ? AspectRatio(
//                       aspectRatio: _controller.value.aspectRatio,
//                       child: VideoPlayer(_controller),
//                     )
//                   : Container(),
//             ),
//             floatingActionButton: FloatingActionButton(
//               onPressed: () {
//                 if (_controller.value.isPlaying) {
//                   channel.sink.add('play');
//                 } else {
//                   channel.sink.add('pause');
//                 }
//               },
//               child: Icon(
//                 _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//               ),
//             ),
//         // ),
//         ),
//       // ),
//     );
//   }

//   @override
//   void dispose() {
//      _controller.dispose();
//     channel.sink.close();
//     super.dispose();
//   }
// }

import 'package:agora_flutter_quickstart/src/services/database.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;
  Stream ktvRoomStream;
  DatabaseMethods databaseMethods = DatabaseMethods();
  Future<void> _initializeVideoPlayerFuture;
  
  void getKTVRoomList() async {
    await databaseMethods.getKtvRoom('1234').then((value){
      setState(() {
        ktvRoomStream = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getKTVRoomList();
    // final file = File();
    databaseMethods.createOrUpdateKtvRoomVideoState('1234', 'pause');
    _controller = VideoPlayerController.network('https://tzw0.github.io/videos/perfect.mp4');
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Demo',
      home: Scaffold(
        body: StreamBuilder(
          stream: ktvRoomStream,
          builder: (context, snapshot) {
            // print(snapshot.data['videostate']);
            // if (snapshot.hasData && snapshot.data['videostate'] == 'play') {
            //   _controller.play();
            // } else if (snapshot.hasData && snapshot.data['videostate'] == 'pause') {
            //   _controller.pause();
            // }
            var state;
            try {
              state = snapshot.data['videostate'];
            } catch (e) {
              state = 'pause';
            }
            print(state);
            if (snapshot.hasData && state == 'play') {
              _controller.play();
            } else if (snapshot.hasData && state == 'pause') {
              _controller.pause();
            }
            return Center(
              child: _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            );
          }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              if (_controller.value.isPlaying) {
                databaseMethods.createOrUpdateKtvRoomVideoState('1234', 'pause'); //when these 2 commented somehow ok
                _controller.pause();
              } else {
                databaseMethods.createOrUpdateKtvRoomVideoState('1234', 'play'); //when these 2 commented somehow ok
                _controller.play();
              }
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}