import 'package:boo_mondai/core/core.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonVariant,
        ButtonColor,
        MarkdownText,
        MarkdownTextMode,
        VariantTextField,
        TextFieldFrame,
        TextFieldTone,
        TextFieldSize;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

typedef EditableTextValueSave = Future<void> Function(String value);

class EditableTextValue extends HookWidget {
  const EditableTextValue({
    required this.value,
    required this.onSave,
    this.editingValue,
    this.enabled = true,
    this.placeholder,
    this.textStyle,
    this.maxLines = 1,
    this.isMarkdown = false,
    this.markdownMode = MarkdownTextMode.input,
    this.fieldVariants = const [
      TextFieldSize.normal,
      TextFieldFrame.underline,
      TextFieldTone.neutral,
    ],
    super.key,
    this.textAlign,
  });

  final String value;
  final String? editingValue;
  final EditableTextValueSave onSave;
  final bool enabled;
  final String? placeholder;
  final TextStyle? textStyle;
  final int? maxLines;
  final bool isMarkdown;
  final MarkdownTextMode markdownMode;
  final Iterable<Object> fieldVariants;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final isEditing = useState(false);
    final isSaving = useState(false);
    final controller = useTextEditingController(text: editingValue ?? value);
    final markdownValue = useState(editingValue ?? value);
    final focusNode = useFocusNode();

    useEffect(() {
      if (!isEditing.value) {
        controller.text = editingValue ?? value;
        markdownValue.value = editingValue ?? value;
      }
      return null;
    }, [editingValue, value, isEditing.value]);

    Future<void> save() async {
      if (isSaving.value) return;

      isSaving.value = true;
      try {
        await onSave(isMarkdown ? markdownValue.value : controller.text);
        isEditing.value = false;
      } finally {
        isSaving.value = false;
      }
    }

    void cancel() {
      controller.text = editingValue ?? value;
      markdownValue.value = editingValue ?? value;
      isEditing.value = false;
    }

    void edit() {
      controller.text = editingValue ?? value;
      markdownValue.value = editingValue ?? value;
      isEditing.value = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
        controller.selection = TextSelection.collapsed(
          offset: controller.text.length,
        );
      });
    }

    if (isEditing.value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMarkdown)
            MarkdownText(
              data: markdownValue.value,
              controller: controller,
              focusNode: focusNode,
              onChanged: (value) {
                markdownValue.value = value;
              },
              mode: markdownMode,
              enabled: !isSaving.value,
              maxLines: maxLines,
              placeholder: placeholder,
              baseTextStyle: textStyle,
              textInputAction: maxLines == 1
                  ? TextInputAction.done
                  : TextInputAction.newline,
              variants: fieldVariants,
            )
          else
            VariantTextField(
              controller: controller,
              focusNode: focusNode,
              enabled: !isSaving.value,
              maxLines: maxLines,
              placeholder: placeholder,
              textStyle: textStyle,
              textInputAction: maxLines == 1
                  ? TextInputAction.done
                  : TextInputAction.newline,
              onSubmitted: maxLines == 1 ? (_) => save() : null,
              variants: fieldVariants,
            ),
          SizedBox(height: tokens.spaceLayoutGapSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Button.icon(
                icon: Icons.close,
                variant: ButtonVariant.flat,
                onPressed: isSaving.value ? null : cancel,
              ),
              SizedBox(width: tokens.spaceLayoutGapSm),
              Button.icon(
                icon: Icons.check,
                color: ButtonColor.success,
                variant: ButtonVariant.flat,
                onPressed: isSaving.value ? null : save,
              ),
            ],
          ),
        ],
      );
    }

    final valueWidget = isMarkdown && value.trim().isNotEmpty
        ? MarkdownText(
            data: value,
            baseTextStyle: textStyle,
            maxLines: maxLines,
          )
        : Text(
            value,
            style: textStyle,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: maxLines == null ? null : TextOverflow.ellipsis,
          );

    return Row(
      spacing: tokens.spaceLayoutGapSm,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: TextHelper.textAlignToMainAxisalignment(textAlign),
      children: [
        Flexible(child: valueWidget),
        if (enabled) ...[Button.iconSmall(icon: Icons.edit, onPressed: edit)],
      ],
    );
  }
}
