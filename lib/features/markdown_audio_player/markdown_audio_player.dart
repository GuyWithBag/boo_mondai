import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        ButtonVariant,
        SurfaceBorder,
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        TextColor,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:theme_variants/theme_variants.dart';

class MarkdownAudioPlayer extends StatefulWidget {
  const MarkdownAudioPlayer({
    required this.source,
    required this.label,
    super.key,
  });

  final String source;
  final String label;

  @override
  State<MarkdownAudioPlayer> createState() => _MarkdownAudioPlayerState();
}

class _MarkdownAudioPlayerState extends State<MarkdownAudioPlayer> {
  late final AudioPlayer _player;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _loadSource();
  }

  @override
  void didUpdateWidget(MarkdownAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      _loadSource();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadSource() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (_isRemoteSource(widget.source)) {
        await _player.setUrl(widget.source);
      } else {
        await _player.setFilePath(widget.source);
      }
      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Audio unavailable';
      });
    }
  }

  Future<void> _togglePlayback(PlayerState playerState) async {
    if (_isLoading || _error != null) return;

    if (playerState.processingState == ProcessingState.completed) {
      await _player.seek(Duration.zero);
      await _player.play();
      return;
    }

    if (playerState.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final titleStyle = textStyle.resolve(tokens, const [
      TextSize.label,
      TextWeight.strong,
      TextColor.baseline,
    ]);
    final timeStyle = textStyle.resolve(tokens, const [
      TextSize.labelSmall,
      TextWeight.body,
      TextColor.muted,
    ]);
    final containerStyle = surfaceStyle.resolve(tokens, const [
      SurfaceColor.baseline,
      SurfaceShape.roundedXsm,
      SurfaceBorder.baseline,
      SurfaceShadow.none,
      SurfacePadding.none,
    ]);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: tokens.spaceScaffoldMaxWidth.w),
      child: Surface(
        style: containerStyle,
        child: Padding(
          padding: EdgeInsets.all(tokens.spaceLayoutPaddingSm.w),
          child: StreamBuilder<PlayerState>(
            stream: _player.playerStateStream,
            initialData: _player.playerState,
            builder: (context, playerStateSnapshot) {
              final playerState =
                  playerStateSnapshot.data ?? _player.playerState;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Button.iconSmall(
                    onPressed: _error == null
                        ? () => _togglePlayback(playerState)
                        : null,
                    icon: _iconFor(playerState),
                    color: ButtonColor.baseline,
                    variant: ButtonVariant.elevated,
                    tokens: tokens,
                  ),
                  SizedBox(width: tokens.spaceLayoutGapSm.w),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _error ?? widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titleStyle,
                        ),
                        SizedBox(height: tokens.spaceLayoutGapXsm.h),
                        _AudioProgress(
                          player: _player,
                          isEnabled: !_isLoading && _error == null,
                          textStyle: timeStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  IconData _iconFor(PlayerState playerState) {
    if (_isLoading ||
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
  });

  final AudioPlayer player;
  final bool isEnabled;
  final TextStyle textStyle;

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
                    trackHeight: 4.h,
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
