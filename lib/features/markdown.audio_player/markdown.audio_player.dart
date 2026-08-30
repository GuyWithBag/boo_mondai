import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        ButtonVariant,
        MarkdownAudioPlayerProgress,
        MarkdownHelper,
        ScaleHelper,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        TextColor,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:theme_variants/theme_variants.dart';

class MarkdownAudioPlayer extends HookWidget {
  const MarkdownAudioPlayer({
    required this.alt,
    this.contentScale = 1,
    super.key,
    required this.uri,
    this.title,
    this.options,
  });

  final Uri uri;
  final String? alt;
  final String? title;
  final String? options;
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

    final String source = MarkdownHelper.resolveAttachmentUrl(uri) ?? '';

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
            error.value ?? alt ?? '',
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
                    MarkdownAudioPlayerProgress(
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
