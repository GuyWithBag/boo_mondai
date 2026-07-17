import 'package:boo_mondai/core/core.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        MarkdownText,
        MarkdownTextMode,
        TextField,
        TextFieldFrame,
        TextFieldSize;
import 'package:flutter/material.dart'
    show
        SizedBox,
        Row,
        TextStyle,
        TextAlign,
        Widget,
        BuildContext,
        WidgetsBinding,
        EdgeInsets,
        TextSelection,
        CrossAxisAlignment,
        TextInputAction,
        MainAxisAlignment,
        Icons,
        Column,
        TextOverflow,
        Text,
        Flexible;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:theme_variants/theme_variants.dart';

class EditableTextValue extends HookWidget {
  const EditableTextValue({
    required this.value,
    required this.onSave,
    this.enabled = true,
    this.placeholder,
    this.textStyle,
    this.maxLines = 1,
    this.isMarkdown = false,
    this.allowMarkdownAttachments = false,
    this.ensureEditActionsAreVisibleWhenKeyboardVisible = true,
    this.fieldVariants = const [TextFieldSize.normal, TextFieldFrame.underline],
    super.key,
    this.textAlign,
    this.placeholderTextStyle,
  });

  final String value;
  final Future<void> Function(String value)? onSave;
  final bool enabled;
  final String? placeholder;
  final TextStyle? textStyle;
  final TextStyle? placeholderTextStyle;
  final int? maxLines;
  final bool isMarkdown;
  final bool allowMarkdownAttachments;
  final bool ensureEditActionsAreVisibleWhenKeyboardVisible;
  final Iterable<Object> fieldVariants;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final isEditing = useState(false);
    final isSaving = useState(false);
    final controller = useTextEditingController(text: value);
    final markdownValue = useState(value);
    final focusNode = useFocusNode();
    final editActionsScrollPadding = EdgeInsets.all(20).copyWith(
      bottom:
          20 +
          (ensureEditActionsAreVisibleWhenKeyboardVisible
              ? 48.h + tokens.spaceLayoutGapSm
              : 0),
    );

    useEffect(() {
      if (!isEditing.value) {
        controller.text = value;
        markdownValue.value = value;
      }
      return null;
    }, [value, isEditing.value]);

    Future<void> save() async {
      if (isSaving.value) return;

      isSaving.value = true;
      try {
        if (onSave != null) {
          await onSave!(isMarkdown ? markdownValue.value : controller.text);
        }
        isEditing.value = false;
      } finally {
        isSaving.value = false;
      }
    }

    void cancel() {
      controller.text = value;
      markdownValue.value = value;
      isEditing.value = false;
    }

    void edit() {
      controller.text = value;
      markdownValue.value = value;
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
              mode: MarkdownTextMode.inputPreview,
              enabled: !isSaving.value,
              maxLines: maxLines,
              placeholder: placeholder,

              baseTextStyle: textStyle,
              textInputAction: maxLines == 1
                  ? TextInputAction.done
                  : TextInputAction.newline,
              variants: fieldVariants,
              allowAttachments: allowMarkdownAttachments,
              scrollPadding: editActionsScrollPadding,
            )
          else
            TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: !isSaving.value,
              maxLines: maxLines,
              placeholder: placeholder,
              style: textStyle,
              textInputAction: maxLines == 1
                  ? TextInputAction.done
                  : TextInputAction.newline,
              onSubmitted: maxLines == 1 ? (_) => save() : null,
              variants: fieldVariants,
              scrollPadding: editActionsScrollPadding,
            ),
          SizedBox(height: tokens.spaceLayoutGapSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Button.iconSmall(
                icon: Icons.close,
                onPressed: isSaving.value ? null : cancel,
              ),
              SizedBox(width: tokens.spaceLayoutGapSm),
              Button.iconSmall(
                color: ButtonColor.success,
                icon: Icons.check,
                onPressed: isSaving.value ? null : save,
              ),
            ],
          ),
        ],
      );
    }

    final previewText = isMarkdown && value.trim().isNotEmpty
        ? MarkdownText(
            data: value,
            baseTextStyle: textStyle,
            maxLines: maxLines,
            mode: MarkdownTextMode.previewSelectable,
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
      mainAxisAlignment: TextHelper.getMainAxisAlignmentForTextAlign(textAlign),
      children: [
        Flexible(child: previewText),
        if (enabled) Button.iconOnlySmall(icon: Icons.edit, onPressed: edit),
      ],
    );
  }
}
