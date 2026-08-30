import 'package:boo_mondai/lib.barrel.dart' show TextField, ToolBarScope;
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';

class MarkdownTextInput extends HookWidget {
  const MarkdownTextInput({
    super.key,
    required this.data,
    required this.resolvedTextStyle,
    required this.variants,
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
    required this.placeholderTextStyle,
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
  final TextStyle placeholderTextStyle;
  final TextStyle resolvedTextStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLines;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsets scrollPadding;
  final Iterable<Object> variants;
  final bool useToolBar;
  final bool allowAttachments;

  @override
  Widget build(BuildContext context) {
    final internalController = useTextEditingController(text: data);
    final effectiveController = controller ?? internalController;
    final internalFocusNode = useFocusNode();
    final effectiveFocusNode = focusNode ?? internalFocusNode;
    final toolBarController = useToolBar ? ToolBarScope.maybeOf(context) : null;

    useEffect(() {
      if (effectiveController.text != data) {
        effectiveController.text = data;
      }
      return null;
    }, [data, effectiveController]);

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

    return TextField(
      variants: variants,
      controller: effectiveController,
      focusNode: effectiveFocusNode,
      enabled: enabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      placeholder: placeholder,
      placeholderTextStyle: placeholderTextStyle,
      style: resolvedTextStyle,
      keyboardType: keyboardType ?? TextInputType.multiline,
      textInputAction: textInputAction ?? TextInputAction.newline,
      obscureText: obscureText,
      maxLines: maxLines,
      expands: expands,
      textAlignVertical: textAlignVertical,
      scrollPadding: scrollPadding,
    );
  }
}
