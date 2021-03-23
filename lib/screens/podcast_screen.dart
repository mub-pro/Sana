import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration();
  Duration _position = Duration();

  void _playSound(String url) async {
    int result = await _audioPlayer.play(url);
    if (result == 1) {
      setState(() {
        _isPlaying = true;
      });
    }

    _audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

    _audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration(seconds: 0);
      });
    });
  }

  void _pauseSound() async {
    int result = await _audioPlayer.pause();
    if (result == 1) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _seekTo(int second) async {
    await _audioPlayer.seek(Duration(seconds: second));
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

  void getDuration() {
    _audioPlayer.setUrl(widget.podcast.url);
    _audioPlayer.onDurationChanged.listen((event) {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetInfo(
        builder: (context, deviceInfo) {
          return Stack(
            alignment: Alignment.center,
            children: [
              //Image
              CachedNetworkImage(
                imageUrl: widget.podcast.image,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
              ),
              //Back Button
              Positioned(
                top: MediaQuery.of(context).size.height * 0.06,
                left: MediaQuery.of(context).size.width * 0.04,
                child: WidgetInfo(
                  builder: (context, deviceInfo) {
                    return IconButton(
                      iconSize: deviceInfo.deviceType == DeviceType.Mobile
                          ? 50.0
                          : 100.0,
                      icon: Icon(
                        CustomIcon.left_open,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              //Name
              Positioned(
                top: deviceInfo.height * 0.15,
                child: Text(
                  widget.podcast.name,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: deviceInfo.width * .1,
                      fontFamily: 'Dubai M',
                      color: Colors.white),
                ),
              ),
              //Icons
              Positioned(
                bottom: deviceInfo.height * .1,
                // right: 0,
                // left: 0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Replay 5 sec
                        CustomIconButton(
                          onTap: () {
                            print('back 10 secs');
                            backward();
                          },
                          icon: CustomIcon.replay_5,
                          size: deviceInfo.width * .11,
                          color: Colors.white,
                        ),
                        SizedBox(width: deviceInfo.width * .06),
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
                          size: deviceInfo.width * .3,
                          color: Colors.white,
                        ),
                        SizedBox(width: deviceInfo.width * .06),
                        //Forward 5 sec
                        CustomIconButton(
                          onTap: () {
                            print('skip 10 secs');
                            forward();
                          },
                          icon: CustomIcon.forward_5,
                          size: deviceInfo.width * .11,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Container(
                      width: deviceInfo.width * .94,
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
                                      fontSize: deviceInfo.width * .035),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: Text(
                                  '${_duration.toString().substring(2, 7)}',
                                  style: TextStyle(
                                      fontFamily: 'Dubai B',
                                      color: Colors.white,
                                      fontSize: deviceInfo.width * .035),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
