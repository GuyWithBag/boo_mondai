import 'package:boo_mondai/lib.barrel.dart' show AppTokens, ScaleHelper;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:theme_variants/theme_variants.dart';

class MarkdownAudioPlayerProgress extends StatelessWidget {
  const MarkdownAudioPlayerProgress({
    super.key,
    required this.player,
    required this.isEnabled,
    required this.textStyle,
    required this.contentScale,
  });

  final AudioPlayer player;
  final bool isEnabled;
  final TextStyle textStyle;
  final double contentScale;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return StreamBuilder<Duration?>(
      stream: player.durationStream,
      initialData: player.duration,
      builder: (context, durationSnapshot) {
        final duration = durationSnapshot.data ?? Duration.zero;

        return StreamBuilder<Duration>(
          stream: player.positionStream,
          initialData: player.position,
          builder: (context, positionSnapshot) {
            final position = _clampPosition(
              positionSnapshot.data ?? Duration.zero,
              duration,
            );

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: tokens.colorPrimary,
                    inactiveTrackColor: tokens.colorMuted,
                    thumbColor: tokens.colorPrimaryBright,
                    overlayColor: tokens.colorPrimarySoft,
                    trackHeight: ScaleHelper.getScaledValue(4.h, contentScale),
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: ScaleHelper.getScaledValue(
                        10.r,
                        contentScale,
                      ),
                    ),
                    overlayShape: RoundSliderOverlayShape(
                      overlayRadius: ScaleHelper.getScaledValue(
                        18.r,
                        contentScale,
                      ),
                    ),
                  ),
                  child: Slider(
                    min: 0,
                    max: duration.inMilliseconds <= 0
                        ? 1
                        : duration.inMilliseconds.toDouble(),
                    value: position.inMilliseconds.toDouble(),
                    onChanged: isEnabled
                        ? (value) {
                            player.seek(Duration(milliseconds: value.round()));
                          }
                        : null,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(position), style: textStyle),
                    Text(_formatDuration(duration), style: textStyle),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Duration _clampPosition(Duration position, Duration duration) {
    if (duration <= Duration.zero) return Duration.zero;
    if (position < Duration.zero) return Duration.zero;
    if (position > duration) return duration;
    return position;
  }

  static String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
