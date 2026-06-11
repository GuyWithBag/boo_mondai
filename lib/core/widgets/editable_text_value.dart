import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonDepth,
        ButtonTone,
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
    this.fieldVariants = const [
      TextFieldSize.normal,
      TextFieldFrame.underline,
      TextFieldTone.neutral,
    ],
    super.key,
  });

  final String value;
  final String? editingValue;
  final EditableTextValueSave onSave;
  final bool enabled;
  final String? placeholder;
  final TextStyle? textStyle;
  final int? maxLines;
  final Iterable<Object> fieldVariants;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final isEditing = useState(false);
    final isSaving = useState(false);
    final controller = useTextEditingController(text: editingValue ?? value);
    final focusNode = useFocusNode();

    useEffect(() {
      if (!isEditing.value) {
        controller.text = editingValue ?? value;
      }
      return null;
    }, [editingValue, value, isEditing.value]);

    Future<void> save() async {
      if (isSaving.value) return;

      isSaving.value = true;
      try {
        await onSave(controller.text);
        isEditing.value = false;
      } finally {
        isSaving.value = false;
      }
    }

    void cancel() {
      controller.text = editingValue ?? value;
      isEditing.value = false;
    }

    void edit() {
      controller.text = editingValue ?? value;
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
          SizedBox(height: tokens.spacePanelGapSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Button.icon(
                icon: Icons.close,
                depth: ButtonDepth.flat,
                onPressed: isSaving.value ? null : cancel,
              ),
              SizedBox(width: tokens.spacePanelGapSm),
              Button.icon(
                icon: Icons.check,
                tone: ButtonTone.success,
                depth: ButtonDepth.flat,
                onPressed: isSaving.value ? null : save,
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text(value, style: textStyle)),
        if (enabled) ...[
          SizedBox(width: tokens.spacePanelGapSm),
          Button.icon(
            icon: Icons.edit,
            tone: ButtonTone.text,
            depth: ButtonDepth.flat,
            onPressed: edit,
          ),
        ],
      ],
    );
  }
}
