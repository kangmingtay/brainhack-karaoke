import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  
  @override
  void initState() {
    super.initState();
    // final file = File();
    _controller = VideoPlayerController.network('https://r5---sn-gvnuxaxjvh-n8v6.googlevideo.com/videoplayback?expire=1591173174&ei=1gvXXqfrN4W37QTkp5WoDA&ip=178.35.230.10&id=o-AERpw2P-FHR-D7Mi-jGh0UiBmpUX2fxK153vv9auuV5A&itag=18&source=youtube&requiressl=yes&mh=H-&mm=31%2C29&mn=sn-gvnuxaxjvh-n8v6%2Csn-gvnuxaxjvh-n8vk&ms=au%2Crdu&mv=m&mvi=4&pl=18&initcwndbps=1181250&vprv=1&mime=video%2Fmp4&gir=yes&clen=8109118&ratebypass=yes&dur=265.009&lmt=1546315554990141&mt=1591151500&fvip=5&fexp=23882513&c=WEB&txp=5531432&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRgIhAK7kVDrtMl4kbkclSHSzS68SAvrD61D7_Fyg2KNEDXGJAiEAzQGUktTMq-sPEoqWVsM7Nlz_19t8IdlXDVV5srffi08%3D&sig=AOq0QJ8wRAIge9tC_289Qh6u4bLQMROhH0XEBBtxqeBk9I9JNxhFMUMCIHYM6X6om9EaYiVsQJZMuKhLdOIjgcrbrtuZrOGJWCKf&video_id=ZakEbWobIj0&title=Plain+White+T%27s+-+Hey+There+Delilah+%28Karaoke+Version%29');
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
        body: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
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