import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        ButtonVariant,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        TextColor,
        TextSize,
        TextWeight,
        ScaleHelper,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:theme_variants/theme_variants.dart';

class MarkdownAudioPlayer extends HookWidget {
  const MarkdownAudioPlayer({
    required this.source,
    required this.label,
    this.contentScale = 1,
    super.key,
  });

  final String source;
  final String label;
  final double contentScale;

  Future<void> _togglePlayback({
    required AudioPlayer player,
    required PlayerState playerState,
    required bool isLoading,
    required String? error,
  }) async {
    if (isLoading || error != null) return;

    if (playerState.processingState == ProcessingState.completed) {
      await player.seek(Duration.zero);
      await player.play();
      return;
    }

    if (playerState.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = useMemoized(AudioPlayer.new);
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final playerStateSnapshot = useStream(
      player.playerStateStream,
      initialData: player.playerState,
    );

    useEffect(() {
      var isDisposed = false;

      Future<void> loadSource() async {
        isLoading.value = true;
        error.value = null;

        try {
          if (_isRemoteSource(source)) {
            await player.setUrl(source);
          } else {
            await player.setFilePath(source);
          }
          if (isDisposed) return;
          isLoading.value = false;
        } catch (_) {
          if (isDisposed) return;
          isLoading.value = false;
          error.value = 'Audio unavailable';
        }
      }

      loadSource();

      return () {
        isDisposed = true;
      };
    }, [player, source]);

    useEffect(() => player.dispose, [player]);

    final tokens = context.themeTokens<AppTokens>();
    final titleStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.label,
        TextWeight.strong,
        TextColor.baseline,
      ]),
      contentScale,
    );
    final timeStyle = ScaleHelper.getTextStyleWithScaledFontSize(
      textStyle.resolve(tokens, const [
        TextSize.labelSmall,
        TextWeight.body,
        TextColor.muted,
      ]),
      contentScale,
    );
    final containerStyle = surfaceStyle.resolve(tokens, const [
      // SurfaceColor.muted,
      SurfaceShape.roundedXsm,
      // SurfaceBorder.none,
      SurfaceShadow.none,
      SurfacePadding.sm,
    ]);
    final scaledContainerStyle = containerStyle.copyWith(
      decoration: containerStyle.decoration.copyWith(
        borderRadius: BorderRadius.circular(
          tokens.radiusSurfaceXsm.r * contentScale,
        ),
      ),
      padding: containerStyle.padding is EdgeInsets
          ? ScaleHelper.getScaledEdgeInsets(
              containerStyle.padding! as EdgeInsets,
              contentScale,
            )
          : containerStyle.padding,
    );
    final rowGap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapSm.w,
      contentScale,
    );
    final progressGap = ScaleHelper.getScaledValue(
      tokens.spaceLayoutGapXsm.h,
      contentScale,
    );

    return Surface(
      style: scaledContainerStyle,
      child: Column(
        children: [
          Text(
            error.value ?? label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: rowGap,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: progressGap),
                    _AudioProgress(
                      player: player,
                      isEnabled: !isLoading.value && error.value == null,
                      textStyle: timeStyle,
                      contentScale: contentScale,
                    ),
                  ],
                ),
              ),
              Button.iconSmall(
                onPressed: error.value == null
                    ? () => _togglePlayback(
                        player: player,
                        playerState:
                            playerStateSnapshot.data ?? player.playerState,
                        isLoading: isLoading.value,
                        error: error.value,
                      )
                    : null,
                icon: _iconFor(
                  playerStateSnapshot.data ?? player.playerState,
                  isLoading: isLoading.value,
                ),
                color: ButtonColor.baseline,
                variant: ButtonVariant.elevated,
                contentScale: contentScale,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconFor(PlayerState playerState, {required bool isLoading}) {
    if (isLoading ||
        playerState.processingState == ProcessingState.loading ||
        playerState.processingState == ProcessingState.buffering) {
      return Icons.hourglass_empty;
    }
    if (playerState.playing) return Icons.pause;
    if (playerState.processingState == ProcessingState.completed) {
      return Icons.replay;
    }
    return Icons.play_arrow;
  }

  static bool _isRemoteSource(String source) {
    final uri = Uri.tryParse(source.trim());
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }
}

class _AudioProgress extends StatelessWidget {
  const _AudioProgress({
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
