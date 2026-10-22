import 'package:boo_mondai/lib.barrel.dart' show StatusLayoutState, showModal;
import 'package:flutter/material.dart';

const icon = Icon(Icons.construction_outlined);
const title = 'Coming Soon';
const subtitle = 'This feature is coming soon and is currently disabled.';

Future<void> showFeatureDisabledModal(BuildContext context) {
  return showModal<void>(
    context: context,
    leading: icon,
    title: title,
    subtitle: subtitle,
    showCancelButton: true,
  );
}

class FeatureDisabledState extends StatelessWidget {
  const FeatureDisabledState({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusLayoutState(leading: icon, title: title, message: subtitle);
  }
}
