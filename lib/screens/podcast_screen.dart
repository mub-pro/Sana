import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:original_sana/models/models.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:original_sana/widgets/custom_icon_button.dart';

import '../custom_icon_icons.dart';

class PodcastScreen extends StatefulWidget {
  final Podcast podcast;
  PodcastScreen({this.podcast});
  @override
  _PodcastScreenState createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen>
    with SingleTickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration();
  Duration _position = Duration();

  void _playSound(String url) async {
    int result = await audioPlayer.play(url);
    if (result == 1) {
      setState(() {
        _isPlaying = true;
      });
    }

    audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration(seconds: 0);
      });
    });
  }

  void _pauseSound() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _seekTo(int second) async {
    await audioPlayer.seek(Duration(seconds: second));
  }

  void forward() {
    if (_position.inSeconds <= _duration.inSeconds - 5) {
      _seekTo(_position.inSeconds + 5);
      // await audioPlayer.seek(_position + Duration(seconds: 10));
    }
  }

  void backward() {
    if (_position.inSeconds >= 5) {
      _seekTo(_position.inSeconds - 5);
      // await audioPlayer.seek(_position - Duration(seconds: 10));
    }
  }

  void getDuration()  {
     audioPlayer.setUrl(widget.podcast.url);
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
       _duration = event;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDuration();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetInfo(
        builder: (context, deviceInfo) {
          return Stack(
            fit: StackFit.expand,
            children: [
              //Image
              Image.network(
                widget.podcast.image,
                fit: BoxFit.cover,
              ),
              //Back Button
              Positioned(
                top: MediaQuery.of(context).size.height * 0.06,
                left: MediaQuery.of(context).size.width * 0.04,
                child: WidgetInfo(
                  builder: (context, deviceInfo) {
                    return IconButton(
                      iconSize: deviceInfo.deviceType == DeviceType.Mobile ? 50.0 : 100.0,
                      icon: Icon(
                        CustomIcon.left_open,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await audioPlayer.dispose();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              //Name
              Positioned(
                top: deviceInfo.height * 0.2,
                left: 0,
                right: 0,
                child: Text(
                  widget.podcast.name,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: deviceInfo.deviceType == DeviceType.Mobile
                          ? 30.0
                          : 50.0,
                      fontFamily: 'Dubai M',
                      color: Colors.white),
                ),
              ),
              //Icons
              Positioned(
                bottom: 100.0,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    //Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Replay 5 sec
                        CustomIconButton(
                          onTap: () {
                            print('back 10 secs');
                            backward();
                          },
                          icon: CustomIcon.replay_5,
                          size: deviceInfo.deviceType == DeviceType.Mobile
                              ? 50.0
                              : 100.0,
                          color: Colors.white,
                        ),
                        //Play
                        CustomIconButton(
                          onTap: () {
                            _isPlaying
                                ? _pauseSound()
                                : _playSound(widget.podcast.url);
                          },
                          icon: _isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_filled_rounded,
                          size: deviceInfo.deviceType == DeviceType.Mobile
                              ? 140.0
                              : 250.0,
                          color: Colors.white,
                        ),
                        //Forward 5 sec
                        CustomIconButton(
                          onTap: () {
                            print('skip 10 secs');
                            forward();
                          },
                          icon: CustomIcon.forward_5,
                          size: deviceInfo.deviceType == DeviceType.Mobile
                              ? 50.0
                              : 100.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    //Slider
                    Container(
                      padding: deviceInfo.deviceType == DeviceType.Mobile
                          ? const EdgeInsets.symmetric(horizontal: 0)
                          : EdgeInsets.symmetric(
                              horizontal: deviceInfo.width * 0.1),
                      child: Column(
                        children: [
                          Slider(
                            activeColor: Colors.orangeAccent,
                            inactiveColor: Colors.white,
                            value: _position.inSeconds.toDouble(),
                            min: 0,
                            max: _duration.inSeconds.toDouble(),
                            onChanged: (double value) {
                                setState(() {
                                  _seekTo(value.toInt());
                                });


                            },
                          ),
                          //Duration
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Text(
                                  '${_position.toString().substring(2, 7)}',
                                  style: TextStyle(
                                      fontFamily: 'Dubai B',
                                      color: Colors.white,
                                      fontSize: deviceInfo.deviceType ==
                                              DeviceType.Mobile
                                          ? 15.0
                                          : 35.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: Text(
                                  '${_duration.toString().substring(2, 7)}',
                                  style: TextStyle(
                                      fontFamily: 'Dubai B',
                                      color: Colors.white,
                                      fontSize: deviceInfo.deviceType ==
                                              DeviceType.Mobile
                                          ? 15.0
                                          : 35.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
