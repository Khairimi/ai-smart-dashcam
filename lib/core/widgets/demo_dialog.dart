import 'package:flutter/material.dart';

/// Dialog for actions whose real implementation (calls, dispatch, sharing,
/// recording storage …) is not connected. Makes the demo status explicit
/// instead of pretending the action happened.
Future<void> showDemoDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text('$message\n\nDEMO / SIMULATED — no real action was taken.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
