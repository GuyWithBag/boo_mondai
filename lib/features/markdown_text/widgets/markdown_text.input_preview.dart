import 'package:boo_mondai/lib.barrel.dart'
    show
        ToolBarScope,
        TextField,
        MarkdownTextBody,
        MarkdownAttachmentUrlResolver;
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class MarkdownTextInputPreview extends HookWidget {
  const MarkdownTextInputPreview({
    super.key,
    required this.data,
    required this.resolvedTextStyle,
    required this.variants,
    required this.contentScale,
    this.controller,
    this.focusNode,
    this.enabled,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines,
    this.expands = false,
    this.textAlignVertical,
    required this.scrollPadding,
    this.onTapLink,
    this.resolveAttachmentUrl,
    this.imageConstraints,
    this.audioConstraints,
    required this.defaultMarkdownAlignment,
    this.fitContent = false,
    required this.useToolBar,
    required this.allowAttachments,
  });

  final String data;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final TextStyle resolvedTextStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLines;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsets scrollPadding;
  final Iterable<Object> variants;
  final MarkdownTapLinkCallback? onTapLink;
  final MarkdownAttachmentUrlResolver? resolveAttachmentUrl;
  final BoxConstraints? imageConstraints;
  final BoxConstraints? audioConstraints;
  final WrapAlignment defaultMarkdownAlignment;
  final bool fitContent;
  final double contentScale;
  final bool useToolBar;
  final bool allowAttachments;

  @override
  Widget build(BuildContext context) {
    final internalController = useTextEditingController(text: data);
    final effectiveController = controller ?? internalController;

    final internalFocusNode = useFocusNode();
    final effectiveFocusNode = focusNode ?? internalFocusNode;
    final toolBarController = useToolBar ? ToolBarScope.maybeOf(context) : null;

    final isEditing = useState(effectiveFocusNode.hasFocus);

    useEffect(() {
      if (effectiveController.text != data) {
        effectiveController.text = data;
      }
      return null;
    }, [data, effectiveController]);

    useEffect(() {
      final handleChanged = onChanged;
      if (handleChanged == null) return null;

      void listener() => handleChanged(effectiveController.text);

      effectiveController.addListener(listener);
      return () => effectiveController.removeListener(listener);
    }, [effectiveController, onChanged]);

    useEffect(() {
      void listener() => isEditing.value = effectiveFocusNode.hasFocus;
      effectiveFocusNode.addListener(listener);
      return () => effectiveFocusNode.removeListener(listener);
    }, [effectiveFocusNode]);

    useEffect(
      () {
        if (toolBarController == null) return null;

        void listener() {
          if (effectiveFocusNode.hasFocus) {
            toolBarController.show(
              textController: effectiveController,
              focusNode: effectiveFocusNode,
              allowAttachments: allowAttachments,
            );
          } else {
            toolBarController.hide(textController: effectiveController);
          }
        }

        effectiveFocusNode.addListener(listener);
        listener();
        return () {
          effectiveFocusNode.removeListener(listener);
          toolBarController.hide(textController: effectiveController);
        };
      },
      [
        effectiveFocusNode,
        effectiveController,
        toolBarController,
        allowAttachments,
      ],
    );

    if (isEditing.value) {
      return TextField(
        variants: variants,
        controller: effectiveController,
        focusNode: effectiveFocusNode,
        enabled: enabled,
        onSubmitted: onSubmitted,
        placeholder: placeholder,
        style: resolvedTextStyle,
        keyboardType: keyboardType ?? TextInputType.multiline,
        textInputAction: textInputAction ?? TextInputAction.newline,
        obscureText: obscureText,
        maxLines: maxLines,
        expands: expands,
        textAlignVertical: textAlignVertical,
        scrollPadding: scrollPadding,
        autofocus: true,
      );
    }

    return GestureDetector(
      onTap: () {
        isEditing.value = true;
        effectiveFocusNode.requestFocus();
      },
      child: MarkdownTextBody(
        resolvedTextStyle: resolvedTextStyle,
        data: effectiveController.text,
        selectable: false,
        defaultAlignment: defaultMarkdownAlignment,
        fitContent: fitContent,
        // Links in inputPreview use the caller's handler or the default
        // launcher. Tapping a link should NOT switch to edit mode, so
        // the GestureDetector above won't interfere because MarkdownBody
        // calls onTapLink and stops the gesture from bubbling.
        contentScale: contentScale,
        resolveAttachmentUrl: resolveAttachmentUrl,
        imageConstraints: imageConstraints,
        audioConstraints: audioConstraints,
      ),
    );
  }
}
