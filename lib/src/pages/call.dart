import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import '../utils/settings.dart';
import './video.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// Creates a call page with given channel name.
  const CallPage({Key key, this.channelName}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  // static final _users = <int>[];
  static final Map<int, ClientRole> _users = {};
  final _infoStrings = <String>[];
  bool muted = false;
  final Map<String, int> config = {
    "audioBitrate": 400, 
    "audioSampleRate": 1,
    "height": 180,
    "videoBitrate": 400, 
    "videoFramerate": 15, 
    "videoGop": 30, 
    "width": 320, 
  };
  ChannelProfile profile = ChannelProfile.LiveBroadcasting;
  ClientRole role;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    // await _injectAgoraStream();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.setChannelProfile(profile);
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
    AgoraRtcEngine.addInjectStreamUrl('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', AgoraLiveInjectStreamConfig.fromJson(config));
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  Future<void> _injectAgoraStream() async {
    await AgoraRtcEngine.addInjectStreamUrl('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', AgoraLiveInjectStreamConfig.fromJson(config));
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        if (_users.length == 0) {
          role = ClientRole.Broadcaster;
        } else {
          role = ClientRole.Audience;
        }
        AgoraRtcEngine.setClientRole(role);
        final info = 'userJoined: $uid role: $role';
        _infoStrings.add(info);
        _users[uid] = role;
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
    
    // Map<String, dynamic> toJson() => {'url': 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', 'uid': _users[0], 'status': status};

    // Map<String, dynamic> toJson() {
    //   int status;
    //   Map<String, dynamic> result = {'url': 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', 'uid': _users[0], 'status': status};
    //   String url = result['url'];
    //   int uid = result['uid']; 
    //   setState(() {
    //     final info = 'url: $url uid: $uid status: $status';
    //     _infoStrings.add(info);
    //   });
    //   return result;
    // };
    // AgoraRtcEngine.onStreamInjectedStatus(toJson());
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid, ClientRole role) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Agora Flutter QuickStart'),
      // ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                Expanded(
                  flex: 4,
                  child: VideoApp(),
                ),
                Expanded(
                  flex: 6,
                  child: _viewRows(),
                ),
              ]),
            _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
