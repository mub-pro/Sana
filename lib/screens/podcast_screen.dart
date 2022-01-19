import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:original_sana/database/moor/favorites.dart';
import 'package:original_sana/models/models.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:original_sana/widgets/custom_icon_button.dart';
import 'package:original_sana/widgets/helper_widgets.dart';
import 'package:provider/provider.dart';

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
  AudioPlayerState _audioPlayerState = AudioPlayerState.PAUSED;
  Duration _duration = Duration();
  Duration _position = Duration();

  void _playSound(String url) async {
    await _audioPlayer.play(url);
  }

  void _pauseSound() async {
    await _audioPlayer.pause();
  }

  void _seekTo(int second) async {
    Duration newPosition = Duration(seconds: second);
    await _audioPlayer.seek(newPosition);
  }

  void forward() {
    int remain = _duration.inSeconds - _position.inSeconds;
    if (remain >= 5) {
      _seekTo(_position.inSeconds + 5);
    }
  }

  void backward() {
    if (_position.inSeconds >= 5) {
      _seekTo(_position.inSeconds - 5);
    }
  }

  Future<void> _setUrl(String url) async {
    await _audioPlayer.setUrl(url);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _audioPlayer.setUrl(widget.podcast.url);

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (this.mounted) {
        setState(() {
          _audioPlayerState = state;
        });
      }
    });

    _audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _position = Duration(seconds: 0);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _audioPlayer.release();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myDatabase = Provider.of<MyDatabase>(context);
    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: SafeArea(
        child: WidgetInfo(
          builder: (context, deviceInfo) {
            return Column(
              children: [
                //back button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    iconSize: deviceInfo.deviceType == DeviceType.Mobile
                        ? 40.0
                        : 90.0,
                    icon: Icon(
                      CustomIcon.left_open,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                //image
                Container(
                  height: deviceInfo.height * .5,
                  margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                  padding: EdgeInsets.only(bottom: 40),
                  child: CachedNetworkImage(
                    imageUrl: widget.podcast.image,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                ),
                // Name
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<bool>(
                        stream: myDatabase.isFavorite(widget.podcast.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data) {
                            //Liked
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      deviceInfo.localWidth * 0.2)),
                              child: GestureDetector(
                                onTap: () {
                                  myDatabase.removeFavorite(widget.podcast.id);
                                },
                                child: Icon(CustomIcon.heart,
                                    color: Color(0xffFCFF6C)),
                              ),
                            );
                          }
                          //Not Liked
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    deviceInfo.localWidth * 0.2)),
                            child: GestureDetector(
                              onTap: () {
                                myDatabase.addFavorite(Favorite(
                                    id: widget.podcast.id,
                                    name: widget.podcast.name,
                                    image: widget.podcast.image,
                                    category: 'podcast'));
                              },
                              child: Icon(CustomIcon.heart_empty,
                                  color: Color(0xffFCFF6C)),
                            ),
                          );
                        },
                      ),
                      Text(
                        widget.podcast.name,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontSize: deviceInfo.width * .06,
                            fontFamily: 'Dubai M',
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                //Slider
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackShape: CustomTrackShape(),
                      activeTrackColor: Color(0xffFCFF6C),
                      inactiveTrackColor: Colors.grey.shade800,
                      trackHeight: 2.0,
                      thumbColor: Color(0xffFCFF6C),
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 7.0),
                    ),
                    child: Slider(
                      value: _position.inSeconds.toDouble(),
                      min: 0,
                      max: _duration.inSeconds.toDouble(),
                      onChanged: (double value) {
                        setState(() {
                          _seekTo(value.toInt());
                        });
                      },
                    ),
                  ),
                ),
                //Duration
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_position.toString().substring(2, 7)}',
                        style: TextStyle(
                            fontFamily: 'Dubai B',
                            color: Colors.grey,
                            fontSize: deviceInfo.width * .035),
                      ),
                      Text(
                        '${_duration.toString().substring(2, 7)}',
                        style: TextStyle(
                            fontFamily: 'Dubai B',
                            color: Colors.grey,
                            fontSize: deviceInfo.width * .035),
                      ),
                    ],
                  ),
                ),
                //Icons
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
                      size: deviceInfo.width * .09,
                      color: Colors.white,
                    ),
                    SizedBox(width: deviceInfo.width * .1),
                    //Play - Pause
                    CustomIconButton(
                      onTap: () {
                        _audioPlayerState == AudioPlayerState.PLAYING
                            ? _pauseSound()
                            : _playSound(widget.podcast.url);
                      },
                      icon: _audioPlayerState == AudioPlayerState.PLAYING
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_filled_rounded,
                      size: deviceInfo.width * .25,
                      color: Color(0xffFCFF6C),
                    ),

                    SizedBox(width: deviceInfo.width * .1),
                    //Forward 5 sec
                    CustomIconButton(
                      onTap: () {
                        print('skip 10 secs');
                        forward();
                      },
                      icon: CustomIcon.forward_5,
                      size: deviceInfo.width * .09,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
