import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplate, EditDeckController;

abstract class CardTemplateEditorController<C extends CardTemplate> {
  CardTemplateEditorController({required this.editDeckController})
    : _template = editDeckController.selectedTemplate.value! as C;

  final EditDeckController editDeckController;
  C _template;

  String get templateId => _template.id;

  C get template {
    final current = editDeckController.templateById(templateId);
    if (current is C) {
      _template = current;
    }
    return _template;
  }

  set template(C value) {
    _template = value;
    editDeckController.updateTemplate(value);
  }

  void onVerticalAlignmentControlChanged(bool value) {
    template = template.copyWith(verticallyCentered: value) as C;
  }

  void dispose() {}
}
