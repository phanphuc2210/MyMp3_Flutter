import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class PositionSeekWidget extends StatefulWidget {
  bool detail;
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) seekTo;

  PositionSeekWidget(
      {required this.currentPosition,
      required this.duration,
      required this.seekTo,
      required this.detail});

  @override
  _PositionSeekWidgetState createState() => _PositionSeekWidgetState();
}

class _PositionSeekWidgetState extends State<PositionSeekWidget> {
  late Duration _visibleValue;
  late bool detail;
  bool listenOnlyUserInterraction = false;
  double get percent => widget.duration.inMilliseconds == 0
      ? 0
      : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _visibleValue = widget.currentPosition;
    detail = widget.detail;
  }

  @override
  void didUpdateWidget(PositionSeekWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInterraction) {
      _visibleValue = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NeumorphicSlider(
          min: 0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: percent * widget.duration.inMilliseconds.toDouble(),
          style: SliderStyle(
            variant: Colors.blue.shade900,
            accent: Colors.blue.shade400,
          ),
          height: detail ? 8 : 4,
          onChangeEnd: (newValue) {
            setState(() {
              listenOnlyUserInterraction = false;
              widget.seekTo(_visibleValue);
            });
          },
          onChangeStart: (_) {
            setState(() {
              listenOnlyUserInterraction = true;
            });
          },
          onChanged: (newValue) {
            setState(() {
              final to = Duration(milliseconds: newValue.floor());
              _visibleValue = to;
            });
          },
        ),
        const SizedBox(
          height: 4,
        ),
        detail
            ? Padding(
                padding: const EdgeInsets.only(left: 3.5, right: 3.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(durationToString(widget.currentPosition),
                        style: const TextStyle(color: Colors.white60)),
                    Text(
                      durationToString(widget.duration),
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              )
            : const SizedBox()
      ],
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  final twoDigitMinutes =
      twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  final twoDigitSeconds =
      twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return '$twoDigitMinutes:$twoDigitSeconds';
}
