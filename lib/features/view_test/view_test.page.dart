import 'package:flutter/material.dart' as material;
import 'package:flutter_hooks/flutter_hooks.dart';

class ViewTestPage extends HookWidget {
  const ViewTestPage({super.key});

  @override
  material.Widget build(material.BuildContext context) {
    final controller = useTextEditingController(
      text: 'Native Material TextField test text',
    );

    return material.Scaffold(
      appBar: material.AppBar(title: const material.Text('test')),
      body: material.Padding(
        padding: const material.EdgeInsets.all(24),
        child: material.Column(
          crossAxisAlignment: material.CrossAxisAlignment.stretch,
          children: [
            const material.Text(
              'This page uses only material.Scaffold and material.TextField.',
            ),
            const material.SizedBox(height: 16),
            material.TextField(
              controller: controller,
              decoration: const material.InputDecoration(
                border: material.OutlineInputBorder(),
                labelText: 'Native text field',
              ),
              maxLines: null,
              keyboardType: material.TextInputType.multiline,
            ),
          ],
        ),
      ),
    );
  }
}
