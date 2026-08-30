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
    required this.defaultMarkdownAlignment,
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
  final WrapAlignment defaultMarkdownAlignment;
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
      void listener() => isEditing.value = effectiveFocusNode.hasFocus;
      effectiveFocusNode.addListener(listener);
      return () => effectiveFocusNode.removeListener(listener);
    }, [effectiveFocusNode]);

    useEffect(
      () {
        if (toolBarController == null) return null;

        void listener() {
          if (effectiveFocusNode.hasFocus) {
            toolBarController.setActiveTextController(
              effectiveController,
              allowAttachments: allowAttachments,
            );
          } else {
            toolBarController.clearActiveTextController(effectiveController);
          }
        }

        effectiveFocusNode.addListener(listener);
        listener();
        return () {
          effectiveFocusNode.removeListener(listener);
          toolBarController.clearActiveTextController(effectiveController);
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
        onChanged: onChanged,
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
        // Links in inputPreview use the caller's handler or the default
        // launcher. Tapping a link should NOT switch to edit mode, so
        // the GestureDetector above won't interfere because MarkdownBody
        // calls onTapLink and stops the gesture from bubbling.
        contentScale: contentScale,
      ),
    );
  }
}
